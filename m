Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85D582F61
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbiG0RYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242029AbiG0RX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:23:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6FD7AC03;
        Wed, 27 Jul 2022 09:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CFB860D38;
        Wed, 27 Jul 2022 16:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E5CC433D7;
        Wed, 27 Jul 2022 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940347;
        bh=tERZppFqcEhedvwOcLJyBDztk0AV46GCOnRXiuvGQrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gy5SWLPIsiPgZHr/SjqoQ2yEfk2zmk2GERGX8Dv0XjGiJS0gKvgTCvPZAd+nT3X1r
         gbam32LF303l2uW4uGf4KWITtSQoquKO8MFCEyu+4gL5M+LOqXhV4W9jVyMpIGRM2l
         40W8th61ByYzft+O8nKLkgBg68SLywktF7+GPnFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E4=B8=80=E5=8F=AA=E7=8B=97?= <chennbnbnb@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.15 192/201] tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()
Date:   Wed, 27 Jul 2022 18:11:36 +0200
Message-Id: <20220727161035.722436889@linuxfoundation.org>
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

commit a501ab75e7624d133a5a3c7ec010687c8b961d23 upstream.

There is a race in pty_write(). pty_write() can be called in parallel
with e.g. ioctl(TIOCSTI) or ioctl(TCXONC) which also inserts chars to
the buffer. Provided, tty_flip_buffer_push() in pty_write() is called
outside the lock, it can commit inconsistent tail. This can lead to out
of bounds writes and other issues. See the Link below.

To fix this, we have to introduce a new helper called
tty_insert_flip_string_and_push_buffer(). It does both
tty_insert_flip_string() and tty_flip_buffer_commit() under the port
lock. It also calls queue_work(), but outside the lock. See
71a174b39f10 (pty: do tty_flip_buffer_push without port->lock in
pty_write) for the reasons.

Keep the helper internal-only (in drivers' tty.h). It is not intended to
be used widely.

Link: https://seclists.org/oss-sec/2022/q2/155
Fixes: 71a174b39f10 (pty: do tty_flip_buffer_push without port->lock in pty_write)
Cc: 一只狗 <chennbnbnb@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220707082558.9250-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/pty.c        |   14 ++------------
 drivers/tty/tty.h        |    3 +++
 drivers/tty/tty_buffer.c |   31 +++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 12 deletions(-)

--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -111,21 +111,11 @@ static void pty_unthrottle(struct tty_st
 static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 {
 	struct tty_struct *to = tty->link;
-	unsigned long flags;
 
-	if (tty->flow.stopped)
+	if (tty->flow.stopped || !c)
 		return 0;
 
-	if (c > 0) {
-		spin_lock_irqsave(&to->port->lock, flags);
-		/* Stuff the data into the input queue of the other end */
-		c = tty_insert_flip_string(to->port, buf, c);
-		spin_unlock_irqrestore(&to->port->lock, flags);
-		/* And shovel */
-		if (c)
-			tty_flip_buffer_push(to->port);
-	}
-	return c;
+	return tty_insert_flip_string_and_push_buffer(to->port, buf, c);
 }
 
 /**
--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -111,4 +111,7 @@ static inline void tty_audit_tiocsti(str
 
 ssize_t redirected_tty_write(struct kiocb *, struct iov_iter *);
 
+int tty_insert_flip_string_and_push_buffer(struct tty_port *port,
+		const unsigned char *chars, size_t cnt);
+
 #endif
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -563,6 +563,37 @@ void tty_flip_buffer_push(struct tty_por
 EXPORT_SYMBOL(tty_flip_buffer_push);
 
 /**
+ * tty_insert_flip_string_and_push_buffer - add characters to the tty buffer and
+ *	push
+ * @port: tty port
+ * @chars: characters
+ * @size: size
+ *
+ * The function combines tty_insert_flip_string() and tty_flip_buffer_push()
+ * with the exception of properly holding the @port->lock.
+ *
+ * To be used only internally (by pty currently).
+ *
+ * Returns: the number added.
+ */
+int tty_insert_flip_string_and_push_buffer(struct tty_port *port,
+		const unsigned char *chars, size_t size)
+{
+	struct tty_bufhead *buf = &port->buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	size = tty_insert_flip_string(port, chars, size);
+	if (size)
+		tty_flip_buffer_commit(buf->tail);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	queue_work(system_unbound_wq, &buf->work);
+
+	return size;
+}
+
+/**
  *	tty_buffer_init		-	prepare a tty buffer structure
  *	@port: tty port to initialise
  *


