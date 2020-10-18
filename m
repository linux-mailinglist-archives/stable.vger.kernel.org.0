Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0D4291D97
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgJRTWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbgJRTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9E2422365;
        Sun, 18 Oct 2020 19:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048935;
        bh=+4Rvx/4igygj3eEWflGXS7nSIwGctC1nLqeaaOxGn98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3zGkUrmsk5UfWjUHwccB2NwiVG/tUOy1KL2QyFUQpwjj+rsa6buxBwYFW8SeJr0h
         BgpXWH/8XzqBcRIhYF9o2w2YRJh1z1HbdfsUvm2tHlDexoI5urHImPC+kzKdyg0NBU
         yFONM0WT6Zy+QKvj8P/oaA0g2Wd5+EunXvYL+FJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Connor McAdams <conmanx360@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.8 090/101] ALSA: hda/ca0132 - Add AE-7 microphone selection commands.
Date:   Sun, 18 Oct 2020 15:20:15 -0400
Message-Id: <20201018192026.4053674-90-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor McAdams <conmanx360@gmail.com>

[ Upstream commit ed93f9750c6c2ed371347d0aac3dcd31cb9cf256 ]

Add AE-7 quirk data for setting of microphone. The AE-7 has no front
panel connector, so only rear-mic/line-in have new commands.

Signed-off-by: Connor McAdams <conmanx360@gmail.com>
Link: https://lore.kernel.org/r/20200825201040.30339-19-conmanx360@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 6dfa864d3fe7b..62a9be5b827eb 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4675,6 +4675,15 @@ static int ca0132_alt_select_in(struct hda_codec *codec)
 			ca0113_mmio_command_set(codec, 0x30, 0x28, 0x00);
 			tmp = FLOAT_THREE;
 			break;
+		case QUIRK_AE7:
+			ca0113_mmio_command_set(codec, 0x30, 0x28, 0x00);
+			tmp = FLOAT_THREE;
+			chipio_set_conn_rate(codec, MEM_CONNID_MICIN2,
+					SR_96_000);
+			chipio_set_conn_rate(codec, MEM_CONNID_MICOUT2,
+					SR_96_000);
+			dspio_set_uint_param(codec, 0x80, 0x01, FLOAT_ZERO);
+			break;
 		default:
 			tmp = FLOAT_ONE;
 			break;
@@ -4720,6 +4729,14 @@ static int ca0132_alt_select_in(struct hda_codec *codec)
 		case QUIRK_AE5:
 			ca0113_mmio_command_set(codec, 0x30, 0x28, 0x00);
 			break;
+		case QUIRK_AE7:
+			ca0113_mmio_command_set(codec, 0x30, 0x28, 0x3f);
+			chipio_set_conn_rate(codec, MEM_CONNID_MICIN2,
+					SR_96_000);
+			chipio_set_conn_rate(codec, MEM_CONNID_MICOUT2,
+					SR_96_000);
+			dspio_set_uint_param(codec, 0x80, 0x01, FLOAT_ZERO);
+			break;
 		default:
 			break;
 		}
@@ -4729,7 +4746,10 @@ static int ca0132_alt_select_in(struct hda_codec *codec)
 		if (ca0132_quirk(spec) == QUIRK_R3DI)
 			chipio_set_conn_rate(codec, 0x0F, SR_96_000);
 
-		tmp = FLOAT_ZERO;
+		if (ca0132_quirk(spec) == QUIRK_AE7)
+			tmp = FLOAT_THREE;
+		else
+			tmp = FLOAT_ZERO;
 		dspio_set_uint_param(codec, 0x80, 0x00, tmp);
 
 		switch (ca0132_quirk(spec)) {
-- 
2.25.1

