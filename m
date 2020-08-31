Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45116257CC5
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgHaPbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbgHaPbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:31:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B98302083E;
        Mon, 31 Aug 2020 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887881;
        bh=FTjms7RAStT6C6sTV5fyF/nplxmW+bXYc9VNgjwOUWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2cqTzv0CYHZBRfa4mBEEBCPD5yubbs0BZvDRjLcAA6sohOd5gmaA66vI5YcrpuKe
         9BC9wMr/vuiov9+Xc4Vx9f9W4EFANWg7Y5pr7ord97spY3jJ7Kygjon1hgwT0qwBdG
         O+nXEzxSLgj/L046b5ZRYlWW1ctBYCfGVTF6YLmU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 02/11] speakup: Fix wait_for_xmitr for ttyio case
Date:   Mon, 31 Aug 2020 11:31:08 -0400
Message-Id: <20200831153117.1024537-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153117.1024537-1-sashal@kernel.org>
References: <20200831153117.1024537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

[ Upstream commit 2b86d9b8ec6efb86fc5ea44f2d49b1df17f699a1 ]

This was missed while introducing the tty-based serial access.

The only remaining use of wait_for_xmitr with tty-based access is in
spk_synth_is_alive_restart to check whether the synth can be restarted.
With tty-based this is up to the tty layer to cope with the buffering
etc. so we can just say yes.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20200804160637.x3iycau5izywbgzl@function
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/speakup/serialio.c  | 8 +++++---
 drivers/staging/speakup/spk_priv.h  | 1 -
 drivers/staging/speakup/spk_ttyio.c | 7 +++++++
 drivers/staging/speakup/spk_types.h | 1 +
 drivers/staging/speakup/synth.c     | 2 +-
 5 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/speakup/serialio.c b/drivers/staging/speakup/serialio.c
index 177a2988641c1..403b01d66367e 100644
--- a/drivers/staging/speakup/serialio.c
+++ b/drivers/staging/speakup/serialio.c
@@ -32,6 +32,7 @@ static void spk_serial_tiocmset(unsigned int set, unsigned int clear);
 static unsigned char spk_serial_in(void);
 static unsigned char spk_serial_in_nowait(void);
 static void spk_serial_flush_buffer(void);
+static int spk_serial_wait_for_xmitr(struct spk_synth *in_synth);
 
 struct spk_io_ops spk_serial_io_ops = {
 	.synth_out = spk_serial_out,
@@ -40,6 +41,7 @@ struct spk_io_ops spk_serial_io_ops = {
 	.synth_in = spk_serial_in,
 	.synth_in_nowait = spk_serial_in_nowait,
 	.flush_buffer = spk_serial_flush_buffer,
+	.wait_for_xmitr = spk_serial_wait_for_xmitr,
 };
 EXPORT_SYMBOL_GPL(spk_serial_io_ops);
 
@@ -211,7 +213,7 @@ void spk_stop_serial_interrupt(void)
 }
 EXPORT_SYMBOL_GPL(spk_stop_serial_interrupt);
 
-int spk_wait_for_xmitr(struct spk_synth *in_synth)
+static int spk_serial_wait_for_xmitr(struct spk_synth *in_synth)
 {
 	int tmout = SPK_XMITR_TIMEOUT;
 
@@ -280,7 +282,7 @@ static void spk_serial_flush_buffer(void)
 
 static int spk_serial_out(struct spk_synth *in_synth, const char ch)
 {
-	if (in_synth->alive && spk_wait_for_xmitr(in_synth)) {
+	if (in_synth->alive && spk_serial_wait_for_xmitr(in_synth)) {
 		outb_p(ch, speakup_info.port_tts);
 		return 1;
 	}
@@ -295,7 +297,7 @@ const char *spk_serial_synth_immediate(struct spk_synth *synth,
 	while ((ch = *buff)) {
 		if (ch == '\n')
 			ch = synth->procspeech;
-		if (spk_wait_for_xmitr(synth))
+		if (spk_serial_wait_for_xmitr(synth))
 			outb(ch, speakup_info.port_tts);
 		else
 			return buff;
diff --git a/drivers/staging/speakup/spk_priv.h b/drivers/staging/speakup/spk_priv.h
index 796ffcca43c18..de1ed6c5018f6 100644
--- a/drivers/staging/speakup/spk_priv.h
+++ b/drivers/staging/speakup/spk_priv.h
@@ -36,7 +36,6 @@
 
 const struct old_serial_port *spk_serial_init(int index);
 void spk_stop_serial_interrupt(void);
-int spk_wait_for_xmitr(struct spk_synth *in_synth);
 void spk_serial_release(void);
 void spk_ttyio_release(void);
 void spk_ttyio_register_ldisc(void);
diff --git a/drivers/staging/speakup/spk_ttyio.c b/drivers/staging/speakup/spk_ttyio.c
index 93742dbdee77b..07948755cf9ed 100644
--- a/drivers/staging/speakup/spk_ttyio.c
+++ b/drivers/staging/speakup/spk_ttyio.c
@@ -116,6 +116,7 @@ static void spk_ttyio_tiocmset(unsigned int set, unsigned int clear);
 static unsigned char spk_ttyio_in(void);
 static unsigned char spk_ttyio_in_nowait(void);
 static void spk_ttyio_flush_buffer(void);
+static int spk_ttyio_wait_for_xmitr(struct spk_synth *in_synth);
 
 struct spk_io_ops spk_ttyio_ops = {
 	.synth_out = spk_ttyio_out,
@@ -125,6 +126,7 @@ struct spk_io_ops spk_ttyio_ops = {
 	.synth_in = spk_ttyio_in,
 	.synth_in_nowait = spk_ttyio_in_nowait,
 	.flush_buffer = spk_ttyio_flush_buffer,
+	.wait_for_xmitr = spk_ttyio_wait_for_xmitr,
 };
 EXPORT_SYMBOL_GPL(spk_ttyio_ops);
 
@@ -283,6 +285,11 @@ static void spk_ttyio_tiocmset(unsigned int set, unsigned int clear)
 	mutex_unlock(&speakup_tty_mutex);
 }
 
+static int spk_ttyio_wait_for_xmitr(struct spk_synth *in_synth)
+{
+	return 1;
+}
+
 static unsigned char ttyio_in(int timeout)
 {
 	struct spk_ldisc_data *ldisc_data = speakup_tty->disc_data;
diff --git a/drivers/staging/speakup/spk_types.h b/drivers/staging/speakup/spk_types.h
index a2fc72c298944..f2d3bd72c2c19 100644
--- a/drivers/staging/speakup/spk_types.h
+++ b/drivers/staging/speakup/spk_types.h
@@ -157,6 +157,7 @@ struct spk_io_ops {
 	unsigned char (*synth_in)(void);
 	unsigned char (*synth_in_nowait)(void);
 	void (*flush_buffer)(void);
+	int (*wait_for_xmitr)(struct spk_synth *synth);
 };
 
 struct spk_synth {
diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 3568bfb89912c..ac47dbac72075 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -159,7 +159,7 @@ int spk_synth_is_alive_restart(struct spk_synth *synth)
 {
 	if (synth->alive)
 		return 1;
-	if (spk_wait_for_xmitr(synth) > 0) {
+	if (synth->io_ops->wait_for_xmitr(synth) > 0) {
 		/* restart */
 		synth->alive = 1;
 		synth_printf("%s", synth->init);
-- 
2.25.1

