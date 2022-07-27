Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3E6582AB9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbiG0QXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiG0QWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:22:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478954D178;
        Wed, 27 Jul 2022 09:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D743D617F2;
        Wed, 27 Jul 2022 16:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3607C433D6;
        Wed, 27 Jul 2022 16:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938962;
        bh=9l/ukxD80M6SYVcKZPl4/IMvtG9p/sFEi5Q5ZtKnaDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mjoq0hHJSM7WohfWF0bm3oYsiybxqjvIm00fWo8s46J88WH3C5Epvtlx17lXgo7uc
         zCEovBnOA/W9E/iwzKDnHznUW6vYT9HXgm/0+LVWlqZBDvWDsy5PY5DyuI6L1ch+h6
         MiaZkEnsNusZrmXEGWKkT+yvf/SfPcWCBea/HvN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@reisers.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.9 22/26] tty: the rest, stop using tty_schedule_flip()
Date:   Wed, 27 Jul 2022 18:10:51 +0200
Message-Id: <20220727161000.015867460@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
References: <20220727160959.122591422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit b68b914494df4f79b4e9b58953110574af1cb7a2 upstream.

Since commit a9c3f68f3cd8d (tty: Fix low_latency BUG) in 2014,
tty_flip_buffer_push() is only a wrapper to tty_schedule_flip(). We are
going to remove the latter (as it is used less), so call the former in
the rest of the users.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: William Hubbs <w.d.hubbs@gmail.com>
Cc: Chris Brannon <chris@the-brannons.com>
Cc: Kirk Reiser <kirk@reisers.ca>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20211122111648.30379-3-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/srmcons.c  |    2 +-
 drivers/s390/char/keyboard.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -58,7 +58,7 @@ srmcons_do_receive_chars(struct tty_port
 	} while((result.bits.status & 1) && (++loops < 10));
 
 	if (count)
-		tty_schedule_flip(port);
+		tty_flip_buffer_push(port);
 
 	return count;
 }
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -44,7 +44,7 @@ static inline void
 kbd_put_queue(struct tty_port *port, int ch)
 {
 	tty_insert_flip_char(port, ch, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static inline void
@@ -52,5 +52,5 @@ kbd_puts_queue(struct tty_port *port, ch
 {
 	while (*cp)
 		tty_insert_flip_char(port, *cp++, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }


