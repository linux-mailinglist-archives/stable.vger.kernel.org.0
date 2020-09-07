Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E98260031
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 18:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbgIGQpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730221AbgIGQfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDAA621941;
        Mon,  7 Sep 2020 16:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496530;
        bh=A1GglWH/Xqi80/BCeRtvDldnvRBNc1Oeew/+yalEkgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGej1oPHVz+1mi1WIlI6OW0optlKBmMMRK5OHCerEcj9Nbzz/0lQIiUYCS+va0bxU
         3e+W/ZHOhkm6l9igdDsG34yWzlTfTZZAR77bVh2K4N4+ErJVFqQqxvh4b2naBVcmX4
         V6KKUMhNNs65YMfBKfmbztVk9QDZUtsoV8H8ma9o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mohan Kumar <mkumard@nvidia.com>, Sameer Pujar <spujar@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 04/13] ALSA: hda: Fix 2 channel swapping for Tegra
Date:   Mon,  7 Sep 2020 12:35:15 -0400
Message-Id: <20200907163524.1281734-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163524.1281734-1-sashal@kernel.org>
References: <20200907163524.1281734-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohan Kumar <mkumard@nvidia.com>

[ Upstream commit 216116eae43963c662eb84729507bad95214ca6b ]

The Tegra HDA codec HW implementation has an issue related to not
swapping the 2 channel Audio Sample Packet(ASP) channel mapping.
Whatever the FL and FR mapping specified the left channel always
comes out of left speaker and right channel on right speaker. So
add condition to disallow the swapping of FL,FR during the playback.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Acked-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/20200825052415.20626-2-mkumard@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 2def4ad579ccf..4f8dd558af48f 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3224,6 +3224,7 @@ static int tegra_hdmi_build_pcms(struct hda_codec *codec)
 
 static int patch_tegra_hdmi(struct hda_codec *codec)
 {
+	struct hdmi_spec *spec;
 	int err;
 
 	err = patch_generic_hdmi(codec);
@@ -3231,6 +3232,10 @@ static int patch_tegra_hdmi(struct hda_codec *codec)
 		return err;
 
 	codec->patch_ops.build_pcms = tegra_hdmi_build_pcms;
+	spec = codec->spec;
+	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
+		nvhdmi_chmap_cea_alloc_validate_get_type;
+	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
 
 	return 0;
 }
-- 
2.25.1

