Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED98DD1D8
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731392AbfJRWGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731348AbfJRWGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B492222C6;
        Fri, 18 Oct 2019 22:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436381;
        bh=V66dqJ7GqHdk4+Kq8+BJzlhMH7HjRIFnD+0b2tKx0oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vx0q/ZVLXCg8jXPxSLDbksw7VBmxpM+P8vMImgaIeGjwe3wmtXO/+GVEa/2TVG+SN
         znJPmRB6BVYBNITCNky7Vzbi7IPXYgDM8an6AgeyiqmvQKYz14NPd/39hd8+BpiPFX
         aqNjB7VGmOFC2tfp+0yb+7hUeplBJbE7d5u5xOxU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jussi Laako <jussi@sonarnerd.net>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 034/100] ALSA: usb-audio: Cleanup DSD whitelist
Date:   Fri, 18 Oct 2019 18:04:19 -0400
Message-Id: <20191018220525.9042-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jussi Laako <jussi@sonarnerd.net>

[ Upstream commit 202e69e645545e8dcec5e239658125276a7a315a ]

XMOS/Thesycon family of USB Audio Class firmware flags DSD altsetting
separate from the PCM ones. Thus the DSD altsetting can be auto-detected
based on the flag and doesn't need maintaining specific altsetting
whitelist.

In addition, static VID:PID-to-altsetting whitelisting causes problems
when firmware update changes the altsetting, or same VID:PID is reused
for another device that has different kind of firmware.

This patch removes existing explicit whitelist mappings for XMOS VID
(0x20b1) and Thesycon VID (0x152a).

Also corrects placement of Hegel HD12 and NuPrime DAC-10 to keep list
sorted based on VID.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index da0287441eab4..fb7f74b797ce0 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1461,10 +1461,6 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	/* XMOS based USB DACs */
 	switch (chip->usb_id) {
 	case USB_ID(0x1511, 0x0037): /* AURALiC VEGA */
-	case USB_ID(0x20b1, 0x0002): /* Wyred 4 Sound DAC-2 DSD */
-	case USB_ID(0x20b1, 0x2004): /* Matrix Audio X-SPDIF 2 */
-	case USB_ID(0x20b1, 0x2008): /* Matrix Audio X-Sabre */
-	case USB_ID(0x20b1, 0x300a): /* Matrix Audio Mini-i Pro */
 	case USB_ID(0x22d9, 0x0416): /* OPPO HA-1 */
 	case USB_ID(0x22d9, 0x0436): /* OPPO Sonica */
 	case USB_ID(0x22d9, 0x0461): /* OPPO UDP-205 */
@@ -1474,23 +1470,13 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 			return SNDRV_PCM_FMTBIT_DSD_U32_BE;
 		break;
 
-	case USB_ID(0x10cb, 0x0103): /* The Bit Opus #3; with fp->dsd_raw */
-	case USB_ID(0x152a, 0x85de): /* SMSL D1 DAC */
-	case USB_ID(0x16d0, 0x09dd): /* Encore mDSD */
 	case USB_ID(0x0d8c, 0x0316): /* Hegel HD12 DSD */
+	case USB_ID(0x10cb, 0x0103): /* The Bit Opus #3; with fp->dsd_raw */
 	case USB_ID(0x16b0, 0x06b2): /* NuPrime DAC-10 */
+	case USB_ID(0x16d0, 0x09dd): /* Encore mDSD */
 	case USB_ID(0x16d0, 0x0733): /* Furutech ADL Stratos */
 	case USB_ID(0x16d0, 0x09db): /* NuPrime Audio DAC-9 */
 	case USB_ID(0x1db5, 0x0003): /* Bryston BDA3 */
-	case USB_ID(0x20b1, 0x000a): /* Gustard DAC-X20U */
-	case USB_ID(0x20b1, 0x2005): /* Denafrips Ares DAC */
-	case USB_ID(0x20b1, 0x2009): /* DIYINHK DSD DXD 384kHz USB to I2S/DSD */
-	case USB_ID(0x20b1, 0x2023): /* JLsounds I2SoverUSB */
-	case USB_ID(0x20b1, 0x3021): /* Eastern El. MiniMax Tube DAC Supreme */
-	case USB_ID(0x20b1, 0x3023): /* Aune X1S 32BIT/384 DSD DAC */
-	case USB_ID(0x20b1, 0x302d): /* Unison Research Unico CD Due */
-	case USB_ID(0x20b1, 0x307b): /* CH Precision C1 DAC */
-	case USB_ID(0x20b1, 0x3086): /* Singxer F-1 converter board */
 	case USB_ID(0x22d9, 0x0426): /* OPPO HA-2 */
 	case USB_ID(0x22e1, 0xca01): /* HDTA Serenade DSD */
 	case USB_ID(0x249c, 0x9326): /* M2Tech Young MkIII */
-- 
2.20.1

