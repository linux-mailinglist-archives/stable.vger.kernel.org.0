Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CD24B4A9A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346143AbiBNKRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346722AbiBNKP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:15:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA377923D;
        Mon, 14 Feb 2022 01:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BBA6130D;
        Mon, 14 Feb 2022 09:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B6FC340F1;
        Mon, 14 Feb 2022 09:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832379;
        bh=CZLhnC2bJWNiM3wvuHY9Uh4DOezRKY5x4zwTTBr13EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFDMzX+f0ZGoLAfGq7svbcyQ0gkL2v9SCkNLBUUF6KFH7WcCma963Bjb5KSQ7htNI
         BuJmZ8IASgysfFsLz/1B7MmdjK8XCesUkujhl48mWhQesyLGCTv5cwnSrAtB/VwWA+
         jEjvdodKWT/8nCaE93tEUGW9rrmuUNpgxdhZZQHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kosuke Tatsukawa <tatsu-ab1@nec.com>
Subject: [PATCH 5.15 136/172] n_tty: wake up poll(POLLRDNORM) on receiving data
Date:   Mon, 14 Feb 2022 10:26:34 +0100
Message-Id: <20220214092511.099950653@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: TATSUKAWA KOSUKE (立川 江介) <tatsu-ab1@nec.com>

commit c816b2e65b0e86b95011418cad334f0524fc33b8 upstream.

The poll man page says POLLRDNORM is equivalent to POLLIN when used as
an event.
$ man poll
<snip>
              POLLRDNORM
                     Equivalent to POLLIN.

However, in n_tty driver, POLLRDNORM does not return until timeout even
if there is terminal input, whereas POLLIN returns.

The following test program works until kernel-3.17, but the test stops
in poll() after commit 57087d515441 ("tty: Fix spurious poll() wakeups").

[Steps to run test program]
  $ cc -o test-pollrdnorm test-pollrdnorm.c
  $ ./test-pollrdnorm
  foo          <-- Type in something from the terminal followed by [RET].
                   The string should be echoed back.

  ------------------------< test-pollrdnorm.c >------------------------
  #include <stdio.h>
  #include <errno.h>
  #include <poll.h>
  #include <unistd.h>

  void main(void)
  {
	int		n;
	unsigned char	buf[8];
	struct pollfd	fds[1] = {{ 0, POLLRDNORM, 0 }};

	n = poll(fds, 1, -1);
	if (n < 0)
		perror("poll");
	n = read(0, buf, 8);
	if (n < 0)
		perror("read");
	if (n > 0)
		write(1, buf, n);
  }
  ------------------------------------------------------------------------

The attached patch fixes this problem.  Many calls to
wake_up_interruptible_poll() in the kernel source code already specify
"POLLIN | POLLRDNORM".

Fixes: 57087d515441 ("tty: Fix spurious poll() wakeups")
Cc: stable@vger.kernel.org
Signed-off-by: Kosuke Tatsukawa <tatsu-ab1@nec.com>
Link: https://lore.kernel.org/r/TYCPR01MB81901C0F932203D30E452B3EA5209@TYCPR01MB8190.jpnprd01.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1369,7 +1369,7 @@ handle_newline:
 			put_tty_queue(c, ldata);
 			smp_store_release(&ldata->canon_head, ldata->read_head);
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
-			wake_up_interruptible_poll(&tty->read_wait, EPOLLIN);
+			wake_up_interruptible_poll(&tty->read_wait, EPOLLIN | EPOLLRDNORM);
 			return;
 		}
 	}
@@ -1589,7 +1589,7 @@ static void __receive_buf(struct tty_str
 
 	if (read_cnt(ldata)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
-		wake_up_interruptible_poll(&tty->read_wait, EPOLLIN);
+		wake_up_interruptible_poll(&tty->read_wait, EPOLLIN | EPOLLRDNORM);
 	}
 }
 


