Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AE5475F11
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245689AbhLOR13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343551AbhLOR0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6721C0698DE;
        Wed, 15 Dec 2021 09:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B069B81F1C;
        Wed, 15 Dec 2021 17:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE64C36AE3;
        Wed, 15 Dec 2021 17:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589127;
        bh=wqPOorAJNjodfP+jwRE4baCBPYtL/nuulx6d44VMbhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYcj1QxfNerk4OBBrt5mEk82JF5NUhrlZkU8Ol4vvMFa/ddiBzdO6nmhtTvv6V4rR
         j/qrU2gXsYgSuxr5dwJ0/gZnXTLQ39gppxzZxtlc/x8UnjsUUNSkc1ue0LBX2TK6yk
         Paa2QmFdvDJD9jbJbUkqomF3k9yR5AqcqF9fS41g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/33] ALSA: hda/hdmi: fix HDA codec entry table order for ADL-P
Date:   Wed, 15 Dec 2021 18:21:06 +0100
Message-Id: <20211215172025.061997490@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7b91615bcac32..fe725f0f09312 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4362,11 +4362,11 @@ HDA_CODEC_ENTRY(0x8086280f, "Icelake HDMI",	patch_i915_icl_hdmi),
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



