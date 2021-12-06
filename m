Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD9C46A965
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350451AbhLFVRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:17:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46936 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350456AbhLFVRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:17:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51FABCE13C6;
        Mon,  6 Dec 2021 21:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9208C341C1;
        Mon,  6 Dec 2021 21:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825232;
        bh=goW8oIG28WV3KZJVc82GGxoWcMS+FNrG4DxLeoFlqWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daT5f9ueN16Q4RxOgnRv2wawU2976dlqmOtx3Y+7KZcjCbHL5JsVP3go5O6T3/29t
         MiWHVyuV6VnFVqRkoNpV8fZE2MwSDb57U4m1zVmI5kW5zzqwastWCuxfTq2KSOyctr
         NUvcuiuHVzgAZ2gsToUzWMTzpyIC8i6M3qOdeas7QDi0K/C6rkgm7EuiYha58Fe1lp
         o35oJMnuAASdxo1XDh++ecm8Pgpk52Uti2pzEPjDUUOaGBcvY+UGKhQ8Fs4va1KznM
         UOpT5jRi8/YMspfmPA/kd1GSss6XDO7X9DrF+0hKugWik9GbQsBChokTtQHOt0Yij3
         y1MA6HdlURrcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com,
        guennadi.liakhovetski@linux.intel.com,
        ranjani.sridharan@linux.intel.com, uma.shankar@intel.com,
        hui.wang@canonical.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 12/24] ALSA: hda/hdmi: fix HDA codec entry table order for ADL-P
Date:   Mon,  6 Dec 2021 16:12:17 -0500
Message-Id: <20211206211230.1660072-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 289047db1143c42c81820352f195a393ff639a52 ]

Keep the HDA_CODEC_ENTRY entries sorted by the codec VID. ADL-P
is the only misplaced Intel HDMI codec.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211130124732.696896-2-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 98633d2684deb..415701bd10ac8 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4380,11 +4380,11 @@ HDA_CODEC_ENTRY(0x8086280f, "Icelake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862812, "Tigerlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862814, "DG1 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862815, "Alderlake HDMI",	patch_i915_tgl_hdmi),
-HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862816, "Rocketlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281b, "Elkhartlake HDMI",	patch_i915_icl_hdmi),
+HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
 HDA_CODEC_ENTRY(0x80862882, "Valleyview2 HDMI",	patch_i915_byt_hdmi),
 HDA_CODEC_ENTRY(0x80862883, "Braswell HDMI",	patch_i915_byt_hdmi),
-- 
2.33.0

