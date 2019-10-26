Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181A7E5D5D
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfJZNg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfJZNQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F09121D7F;
        Sat, 26 Oct 2019 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095787;
        bh=p0HHcBifrQYJhjYLaF0G02z99ymmBCH/m5amuEIZddM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOLxj6AedY5iZiCzS/j2axpPBq+kZvVgAkxwIwVCTbfrVHtaw/6wfdakWqpLaqoBx
         QL2Ayw0geLRSYTfKWcda1pcLkt78GLuOQbNm9LUizSnC+i7g6ZWj+W/loTmKwsEGth
         SFluw5zjj1gOkiwEfEqEe3+njdbRQpNd76JTN2kI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rander Wang <rander.wang@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 15/99] ALSA: hdac: clear link output stream mapping
Date:   Sat, 26 Oct 2019 09:14:36 -0400
Message-Id: <20191026131600.2507-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@linux.intel.com>

[ Upstream commit 130bce3afbbbbe585cba8604f2124c28e8d86fb0 ]

Fix potential DMA hang upon starting playback on devices in HDA mode
on Intel platforms (Gemini Lake/Whiskey Lake/Comet Lake/Ice Lake). It
doesn't affect platforms before Gemini Lake or any Intel device in
non-HDA mode.

The reset value for the LOSDIV register is all output streams valid.
Clear this register to invalidate non-existent streams when the bus
is powered up.

Signed-off-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190930142945.7805-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_register.h        | 3 +++
 sound/hda/ext/hdac_ext_controller.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/include/sound/hda_register.h b/include/sound/hda_register.h
index 0fd39295b426b..057d2a2d0bd05 100644
--- a/include/sound/hda_register.h
+++ b/include/sound/hda_register.h
@@ -264,6 +264,9 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO1, SDO2, SDO3 };
 #define AZX_REG_ML_LOUTPAY		0x20
 #define AZX_REG_ML_LINPAY		0x30
 
+/* bit0 is reserved, with BIT(1) mapping to stream1 */
+#define ML_LOSIDV_STREAM_MASK		0xFFFE
+
 #define ML_LCTL_SCF_MASK			0xF
 #define AZX_MLCTL_SPA				(0x1 << 16)
 #define AZX_MLCTL_CPA				(0x1 << 23)
diff --git a/sound/hda/ext/hdac_ext_controller.c b/sound/hda/ext/hdac_ext_controller.c
index 211ca85acd8c4..cfab60d88c921 100644
--- a/sound/hda/ext/hdac_ext_controller.c
+++ b/sound/hda/ext/hdac_ext_controller.c
@@ -270,6 +270,11 @@ int snd_hdac_ext_bus_link_get(struct hdac_bus *bus,
 
 		ret = snd_hdac_ext_bus_link_power_up(link);
 
+		/*
+		 * clear the register to invalidate all the output streams
+		 */
+		snd_hdac_updatew(link->ml_addr, AZX_REG_ML_LOSIDV,
+				 ML_LOSIDV_STREAM_MASK, 0);
 		/*
 		 *  wait for 521usec for codec to report status
 		 *  HDA spec section 4.3 - Codec Discovery
-- 
2.20.1

