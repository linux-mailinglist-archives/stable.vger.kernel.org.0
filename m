Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21629582F4B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242035AbiG0RXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242008AbiG0RW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:22:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD197AB02;
        Wed, 27 Jul 2022 09:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F5561561;
        Wed, 27 Jul 2022 16:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB81C433D6;
        Wed, 27 Jul 2022 16:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940339;
        bh=vTiLwE0dkZkmLTjWT9JEPftwV50J2xM5ZrnPnwkywy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiXj7e11cQ0bu71s/SvF0X2mnysvYsu5smg0vZntc3reH+/zyoj/03VrjciUf6r4/
         3ZVlFZxetjyW+Di9PI/5bAulembE1AQTri5gzZxaRnQmRdMOjhBJRJ2S8633dqlydn
         Fobs72vv5Assl9KS+YmuNPi9beTBHzr5OJgpiwgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.15 190/201] tty: drop tty_schedule_flip()
Date:   Wed, 27 Jul 2022 18:11:34 +0200
Message-Id: <20220727161035.639661748@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

commit 5db96ef23bda6c2a61a51693c85b78b52d03f654 upstream.

Since commit a9c3f68f3cd8d (tty: Fix low_latency BUG) in 2014,
tty_flip_buffer_push() is only a wrapper to tty_schedule_flip(). All
users were converted in the previous patches, so remove
tty_schedule_flip() completely while inlining its body into
tty_flip_buffer_push().

One less exported function.

Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20211122111648.30379-4-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_buffer.c |   30 ++++++++----------------------
 include/linux/tty_flip.h |    1 -
 2 files changed, 8 insertions(+), 23 deletions(-)

--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -403,27 +403,6 @@ int __tty_insert_flip_char(struct tty_po
 EXPORT_SYMBOL(__tty_insert_flip_char);
 
 /**
- *	tty_schedule_flip	-	push characters to ldisc
- *	@port: tty port to push from
- *
- *	Takes any pending buffers and transfers their ownership to the
- *	ldisc side of the queue. It then schedules those characters for
- *	processing by the line discipline.
- */
-
-void tty_schedule_flip(struct tty_port *port)
-{
-	struct tty_bufhead *buf = &port->buf;
-
-	/* paired w/ acquire in flush_to_ldisc(); ensures
-	 * flush_to_ldisc() sees buffer data.
-	 */
-	smp_store_release(&buf->tail->commit, buf->tail->used);
-	queue_work(system_unbound_wq, &buf->work);
-}
-EXPORT_SYMBOL(tty_schedule_flip);
-
-/**
  *	tty_prepare_flip_string		-	make room for characters
  *	@port: tty port
  *	@chars: return pointer for character write area
@@ -567,7 +546,14 @@ static void flush_to_ldisc(struct work_s
 
 void tty_flip_buffer_push(struct tty_port *port)
 {
-	tty_schedule_flip(port);
+	struct tty_bufhead *buf = &port->buf;
+
+	/*
+	 * Paired w/ acquire in flush_to_ldisc(); ensures flush_to_ldisc() sees
+	 * buffer data.
+	 */
+	smp_store_release(&buf->tail->commit, buf->tail->used);
+	queue_work(system_unbound_wq, &buf->work);
 }
 EXPORT_SYMBOL(tty_flip_buffer_push);
 
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -17,7 +17,6 @@ extern int tty_insert_flip_string_fixed_
 extern int tty_prepare_flip_string(struct tty_port *port,
 		unsigned char **chars, size_t size);
 extern void tty_flip_buffer_push(struct tty_port *port);
-void tty_schedule_flip(struct tty_port *port);
 int __tty_insert_flip_char(struct tty_port *port, unsigned char ch, char flag);
 
 static inline int tty_insert_flip_char(struct tty_port *port,


