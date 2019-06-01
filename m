Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A3D31D2D
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbfFAN13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729952AbfFAN13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BDB524EEF;
        Sat,  1 Jun 2019 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395648;
        bh=VBtP+46+0ikRfN2VCn1+6UuYyC/LkPlmOox4Ox07x1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKONGtQ1yF0m9jgJyYND6Wd/BJsfQcCyg4PTN4qGCnTRE35dBHks6w9pR3AHTTaZ3
         HgGQGsbfbB2KKTOErbwIXSZDoW5onamE8Ygjys3/X7+2d7qPG7OyhP5C1Apk92w4f+
         uM5YdgQWcXHG2ksBIs5q2MNebv/KdsXY37E5hKr4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sahara <keun-o.park@darkmatter.ae>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 50/56] tty: pty: Fix race condition between release_one_tty and pty_write
Date:   Sat,  1 Jun 2019 09:25:54 -0400
Message-Id: <20190601132600.27427-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahara <keun-o.park@darkmatter.ae>

[ Upstream commit b9ca5f8560af244489b4a1bc1ae88b341f24bc95 ]

Especially when a linked tty is used such as pty, the linked tty
port's buf works have not been cancelled while master tty port's
buf work has been cancelled. Since release_one_tty and flush_to_ldisc
run in workqueue threads separately, when pty_cleanup happens and
link tty port is freed, flush_to_ldisc tries to access freed port
and port->itty, eventually it causes a panic.
This patch utilizes the magic value with holding the tty_mutex to
check if the tty->link is valid.

Fixes: 2b022ab7542d ("pty: cancel pty slave port buf's work in tty_release")
Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/pty.c    | 7 +++++++
 drivers/tty/tty_io.c | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index c8a2e5b0eff76..0e10600f3884d 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -111,6 +111,12 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 	if (tty->stopped)
 		return 0;
 
+	mutex_lock(&tty_mutex);
+	if (to->magic != TTY_MAGIC) {
+		mutex_unlock(&tty_mutex);
+		return -EIO;
+	}
+
 	if (c > 0) {
 		spin_lock_irqsave(&to->port->lock, flags);
 		/* Stuff the data into the input queue of the other end */
@@ -120,6 +126,7 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 			tty_flip_buffer_push(to->port);
 		spin_unlock_irqrestore(&to->port->lock, flags);
 	}
+	mutex_unlock(&tty_mutex);
 	return c;
 }
 
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b7effcfee91d8..acaf244859039 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1639,10 +1639,13 @@ static void release_one_tty(struct work_struct *work)
 	struct tty_driver *driver = tty->driver;
 	struct module *owner = driver->owner;
 
+	mutex_lock(&tty_mutex);
 	if (tty->ops->cleanup)
 		tty->ops->cleanup(tty);
 
 	tty->magic = 0;
+	mutex_unlock(&tty_mutex);
+
 	tty_driver_kref_put(driver);
 	module_put(owner);
 
-- 
2.20.1

