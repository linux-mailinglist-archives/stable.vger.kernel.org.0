Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E4726012E
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgIGQdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 12:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729833AbgIGQdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6662321789;
        Mon,  7 Sep 2020 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496420;
        bh=R1DlbR4hqNKkIN0iCJx6S2toPcEtswptm9ebDwIlBXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlJlcl0KBCY5e99VdWRp3wktJpARrHex1PqH7V5i4U+1LMqNzgfB5J4h48uAQ40Gy
         ociVQykhp1S19GFBrERuVJQVbjF3ooKWMol6cORRouMi5AAfY1K/LXN9lKIABoZ93F
         silPbYipzFz+4aoGRSo4XcTbfdFE+KjeKug9DBkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mohan Kumar <mkumard@nvidia.com>, Sameer Pujar <spujar@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 08/43] ALSA: hda: Fix 2 channel swapping for Tegra
Date:   Mon,  7 Sep 2020 12:32:54 -0400
Message-Id: <20200907163329.1280888-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
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
index ec9460f3a288e..330fb7656c636 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3677,6 +3677,7 @@ static int tegra_hdmi_build_pcms(struct hda_codec *codec)
 
 static int patch_tegra_hdmi(struct hda_codec *codec)
 {
+	struct hdmi_spec *spec;
 	int err;
 
 	err = patch_generic_hdmi(codec);
@@ -3684,6 +3685,10 @@ static int patch_tegra_hdmi(struct hda_codec *codec)
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

