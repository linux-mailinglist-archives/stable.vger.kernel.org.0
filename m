Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F256045BF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiJSMt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiJSMsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:48:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826B21958E2;
        Wed, 19 Oct 2022 05:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D9ECCE21C6;
        Wed, 19 Oct 2022 09:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959ADC433D6;
        Wed, 19 Oct 2022 09:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170829;
        bh=fvegeJIp2wdais0tigzcD56CJARkRkzBSW+xsY1dQP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNBSrzieqaFbScQPGVbk3bN4AXSkDNMAkcJhgQ5jEXLN9X50BH8JihQ+aZtJlZfis
         G5Pv2M5gBmtXMa32KxqFnsb4+aIFzG9uUZftMh21KaWAvaCwrXK+OMshgSV/lS7+gl
         yoo2ALJek4n1ImuC2j22XT3kKi4P7OD6i8Yg+fXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+38e6c55d4969a14c1534@syzkaller.appspotmail.com,
        Shigeru Yoshida <syoshida@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 802/862] nbd: Fix hung when signal interrupts nbd_start_device_ioctl()
Date:   Wed, 19 Oct 2022 10:34:49 +0200
Message-Id: <20221019083325.341406137@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 1de7c3cf48fc41cd95adb12bd1ea9033a917798a ]

syzbot reported hung task [1].  The following program is a simplified
version of the reproducer:

int main(void)
{
	int sv[2], fd;

	if (socketpair(AF_UNIX, SOCK_STREAM, 0, sv) < 0)
		return 1;
	if ((fd = open("/dev/nbd0", 0)) < 0)
		return 1;
	if (ioctl(fd, NBD_SET_SIZE_BLOCKS, 0x81) < 0)
		return 1;
	if (ioctl(fd, NBD_SET_SOCK, sv[0]) < 0)
		return 1;
	if (ioctl(fd, NBD_DO_IT) < 0)
		return 1;
	return 0;
}

When signal interrupt nbd_start_device_ioctl() waiting the condition
atomic_read(&config->recv_threads) == 0, the task can hung because it
waits the completion of the inflight IOs.

This patch fixes the issue by clearing queue, not just shutdown, when
signal interrupt nbd_start_device_ioctl().

Link: https://syzkaller.appspot.com/bug?id=7d89a3ffacd2b83fdd39549bc4d8e0a89ef21239 [1]
Reported-by: syzbot+38e6c55d4969a14c1534@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220907163502.577561-1-syoshida@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 2a709daefbc4..2a2a1d996a57 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1413,10 +1413,12 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd)
 	mutex_unlock(&nbd->config_lock);
 	ret = wait_event_interruptible(config->recv_wq,
 					 atomic_read(&config->recv_threads) == 0);
-	if (ret)
+	if (ret) {
 		sock_shutdown(nbd);
-	flush_workqueue(nbd->recv_workq);
+		nbd_clear_que(nbd);
+	}
 
+	flush_workqueue(nbd->recv_workq);
 	mutex_lock(&nbd->config_lock);
 	nbd_bdev_reset(nbd);
 	/* user requested, ignore socket errors */
-- 
2.35.1



