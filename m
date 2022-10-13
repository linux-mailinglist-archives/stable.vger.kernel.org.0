Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DCA5FD005
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiJMAYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiJMAXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B4AAC4AD;
        Wed, 12 Oct 2022 17:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8729616D8;
        Thu, 13 Oct 2022 00:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713A6C433D6;
        Thu, 13 Oct 2022 00:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620422;
        bh=4kmDb3KHHylw+eDUb0jbPSSY6h1B5b/2uzbRSJomm6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgPgrtZBdAXnJVDMEJohXfnwI+mxWV2bBBJ16h2KY/oNnolHXQZJA695A6RFoga+B
         7HXcU5OmDW1+tZ4xbNujxugQewFHgQp6hxuL/Xl1Dg362PrDMQuc0Ok9BTlpAVal/T
         Q6rpgEePDTnk/EMps2hD2wm/wk0Aia7zaoTpfK3v/J1Q4V1t6Wp8TMPCgliz6TnH3I
         9qQOw5EK3TaUhzRCLf7+yGIH9dOVjPV8IyTTUkF1qXCfo6aUNv/HpEOSxjrCubDsFl
         pAkL8Mcjd7UrcwRya9eVbGp6OPdMEj4z/a9jtmEVdzQ/4BWWp7f11qgWAcEen4L51x
         jjJlL+nh+Rs5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Starke <daniel.starke@siemens.com>,
        kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org
Subject: [PATCH AUTOSEL 5.19 42/63] tty: n_gsm: replace use of gsm_read_ea() with gsm_read_ea_val()
Date:   Wed, 12 Oct 2022 20:18:16 -0400
Message-Id: <20221013001842.1893243-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 669609cea1d294f43efdd8d57ab65927df90e6df ]

Replace the use of gsm_read_ea() with gsm_read_ea_val() where applicable to
improve code readability and avoid errors like in the past. See first link
below for reference.

Link: https://lore.kernel.org/all/20220504081733.3494-1-daniel.starke@siemens.com/
Link: https://lore.kernel.org/all/202208222147.WfFRmf1r-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220831073800.7459-3-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 95 ++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 01c112e2e214..1ff7f03a12ea 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1407,18 +1407,12 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 	unsigned int modem = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
-	int slen;
+	int cl = clen;
 	const u8 *dp = data;
 	struct tty_struct *tty;
 
-	while (gsm_read_ea(&addr, *dp++) == 0) {
-		len--;
-		if (len == 0)
-			return;
-	}
-	/* Must be at least one byte following the EA */
-	len--;
-	if (len <= 0)
+	len = gsm_read_ea_val(&addr, data, cl);
+	if (len < 1)
 		return;
 
 	addr >>= 1;
@@ -1427,15 +1421,20 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 		return;
 	dlci = gsm->dlci[addr];
 
-	slen = len;
-	while (gsm_read_ea(&modem, *dp++) == 0) {
-		len--;
-		if (len == 0)
-			return;
-	}
-	len--;
+	/* Must be at least one byte following the EA */
+	if ((cl - len) < 1)
+		return;
+
+	dp += len;
+	cl -= len;
+
+	/* get the modem status */
+	len = gsm_read_ea_val(&modem, dp, cl);
+	if (len < 1)
+		return;
+
 	tty = tty_port_tty_get(&dlci->port);
-	gsm_process_modem(tty, dlci, modem, slen - len);
+	gsm_process_modem(tty, dlci, modem, cl);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
@@ -1910,11 +1909,10 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 	struct tty_port *port = &dlci->port;
 	struct tty_struct *tty;
 	unsigned int modem = 0;
-	int len = clen;
-	int slen = 0;
+	int len;
 
 	if (debug & 16)
-		pr_debug("%d bytes for tty\n", len);
+		pr_debug("%d bytes for tty\n", clen);
 	switch (dlci->adaption)  {
 	/* Unsupported types */
 	case 4:		/* Packetised interruptible data */
@@ -1922,24 +1920,22 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 	case 3:		/* Packetised uininterruptible voice/data */
 		break;
 	case 2:		/* Asynchronous serial with line state in each frame */
-		while (gsm_read_ea(&modem, *data++) == 0) {
-			len--;
-			slen++;
-			if (len == 0)
-				return;
-		}
-		len--;
-		slen++;
+		len = gsm_read_ea_val(&modem, data, clen);
+		if (len < 1)
+			return;
 		tty = tty_port_tty_get(port);
 		if (tty) {
-			gsm_process_modem(tty, dlci, modem, slen);
+			gsm_process_modem(tty, dlci, modem, len);
 			tty_wakeup(tty);
 			tty_kref_put(tty);
 		}
+		/* Skip processed modem data */
+		data += len;
+		clen -= len;
 		fallthrough;
 	case 1:		/* Line state will go via DLCI 0 controls only */
 	default:
-		tty_insert_flip_string(port, data, len);
+		tty_insert_flip_string(port, data, clen);
 		tty_flip_buffer_push(port);
 	}
 }
@@ -1960,24 +1956,27 @@ static void gsm_dlci_command(struct gsm_dlci *dlci, const u8 *data, int len)
 {
 	/* See what command is involved */
 	unsigned int command = 0;
-	while (len-- > 0) {
-		if (gsm_read_ea(&command, *data++) == 1) {
-			int clen = *data++;
-			len--;
-			/* FIXME: this is properly an EA */
-			clen >>= 1;
-			/* Malformed command ? */
-			if (clen > len)
-				return;
-			if (command & 1)
-				gsm_control_message(dlci->gsm, command,
-								data, clen);
-			else
-				gsm_control_response(dlci->gsm, command,
-								data, clen);
-			return;
-		}
-	}
+	unsigned int clen = 0;
+	unsigned int dlen;
+
+	/* read the command */
+	dlen = gsm_read_ea_val(&command, data, len);
+	len -= dlen;
+	data += dlen;
+
+	/* read any control data */
+	dlen = gsm_read_ea_val(&clen, data, len);
+	len -= dlen;
+	data += dlen;
+
+	/* Malformed command? */
+	if (clen > len)
+		return;
+
+	if (command & 1)
+		gsm_control_message(dlci->gsm, command, data, clen);
+	else
+		gsm_control_response(dlci->gsm, command, data, clen);
 }
 
 /**
-- 
2.35.1

