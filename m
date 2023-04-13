Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359CF6E14EF
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 21:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDMTOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 15:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjDMTOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 15:14:03 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224E8869A
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 12:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681413241; x=1712949241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6LbDqH5anZY+c9RRHR2OipyEtk0sIq7DJ0r9nofBKss=;
  b=dxjdJPi8QtWHs9+cAjxWLzeoB0jZwZswbqEVKLq2o+DuobppFrC/ZxwH
   aln3sa0/qZCcaVAf+hUHA0hEZ2Tgokd43Z9yFak6m1BCwNDmQCJ+O/wsj
   yhbdUf6kjX3TNn2ZI3TpC9qXgxWPJKjG0n/gIrmFEkuSS5FUC6HxAd/oG
   cEgm43hAgYtxe3k3ng+SKovFCWL9I4g2VRJO3iENq7IgjhumlfAGvUOHx
   mHcWZdRnXj9wxUJHNjVAfAM366o2kk/1Dldrc2YIbui4mMdS8UmZ8xs1X
   fKiVfnrYr0gKOY6aVPp91Y8AESlMjci1c3M5XOvvKUf26hx+RQ1Gsynad
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="344276635"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="344276635"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 12:14:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="639804126"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="639804126"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by orsmga003.jf.intel.com with ESMTP; 13 Apr 2023 12:13:59 -0700
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     uma.shankar@intel.com, intel-gfx@lists.freedesktop.org,
        kai.vehmanen@linux.intel.com, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/hdmi: disable KAE for Intel DG2
Date:   Thu, 13 Apr 2023 22:11:53 +0300
Message-Id: <20230413191153.3692049-1-kai.vehmanen@linux.intel.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use of keep-alive (KAE) has resulted in loss of audio on some A750/770
cards as the transition from keep-alive to stream playback is not
working as expected. As there is limited benefit of the new KAE mode
on discrete cards, revert back to older silent-stream implementation
on these systems.

Cc: stable@vger.kernel.org
Fixes: 15175a4f2bbb ("ALSA: hda/hdmi: add keep-alive support for ADL-P and DG2")
Link: https://gitlab.freedesktop.org/drm/intel/-/issues/8307
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
---
 sound/pci/hda/patch_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 4ffa3a59f419..5c6980394dce 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4604,7 +4604,7 @@ HDA_CODEC_ENTRY(0x80862814, "DG1 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862815, "Alderlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862816, "Rocketlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862818, "Raptorlake HDMI",	patch_i915_tgl_hdmi),
-HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_adlp_hdmi),
+HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281b, "Elkhartlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_adlp_hdmi),

base-commit: be6247640eea9d9b0ff15607fab7a12f40974985
-- 
2.40.0

