Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BB26C187F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjCTPZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjCTPYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:24:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC53034C18
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50407B80D34
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F38C433EF;
        Mon, 20 Mar 2023 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325466;
        bh=7P+Qk8UVbePONM+ocqLe5OYH4QQA7VaeuOo7lQH6DQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jU+q6Onj1uu6gPLh24DvM6nMjIx/VmrTUj5nVIRPMmlWGdbgc8JPqtZp/cLhRKQyM
         Fh1kTv1oRf0XjaxzNQ7Pl2TmgihYexZlINJxrObsfbhc3f2udrYoeLX84v+Ia5VQNt
         YabfReT0Ar8wqL1WdfYbr8wNS0azTdmPOsI7it70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 046/211] drm/i915/sseu: fix max_subslices array-index-out-of-bounds access
Date:   Mon, 20 Mar 2023 15:53:01 +0100
Message-Id: <20230320145515.170154194@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit 193c41926d152761764894f46e23b53c00186a82 ]

It seems that commit bc3c5e0809ae ("drm/i915/sseu: Don't try to store EU
mask internally in UAPI format") exposed a potential out-of-bounds
access, reported by UBSAN as following on a laptop with a gen 11 i915
card:

  UBSAN: array-index-out-of-bounds in drivers/gpu/drm/i915/gt/intel_sseu.c:65:27
  index 6 is out of range for type 'u16 [6]'
  CPU: 2 PID: 165 Comm: systemd-udevd Not tainted 6.2.0-9-generic #9-Ubuntu
  Hardware name: Dell Inc. XPS 13 9300/077Y9N, BIOS 1.11.0 03/22/2022
  Call Trace:
   <TASK>
   show_stack+0x4e/0x61
   dump_stack_lvl+0x4a/0x6f
   dump_stack+0x10/0x18
   ubsan_epilogue+0x9/0x3a
   __ubsan_handle_out_of_bounds.cold+0x42/0x47
   gen11_compute_sseu_info+0x121/0x130 [i915]
   intel_sseu_info_init+0x15d/0x2b0 [i915]
   intel_gt_init_mmio+0x23/0x40 [i915]
   i915_driver_mmio_probe+0x129/0x400 [i915]
   ? intel_gt_probe_all+0x91/0x2e0 [i915]
   i915_driver_probe+0xe1/0x3f0 [i915]
   ? drm_privacy_screen_get+0x16d/0x190 [drm]
   ? acpi_dev_found+0x64/0x80
   i915_pci_probe+0xac/0x1b0 [i915]
   ...

According to the definition of sseu_dev_info, eu_mask->hsw is limited to
a maximum of GEN_MAX_SS_PER_HSW_SLICE (6) sub-slices, but
gen11_sseu_info_init() can potentially set 8 sub-slices, in the
!IS_JSL_EHL(gt->i915) case.

Fix this by reserving up to 8 slots for max_subslices in the eu_mask
struct.

Reported-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Fixes: bc3c5e0809ae ("drm/i915/sseu: Don't try to store EU mask internally in UAPI format")
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230220171858.131416-1-andrea.righi@canonical.com
(cherry picked from commit 3cba09a6ac86ea1d456909626eb2685596c07822)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_sseu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_sseu.h b/drivers/gpu/drm/i915/gt/intel_sseu.h
index aa87d3832d60d..d7e8c374f153e 100644
--- a/drivers/gpu/drm/i915/gt/intel_sseu.h
+++ b/drivers/gpu/drm/i915/gt/intel_sseu.h
@@ -27,7 +27,7 @@ struct drm_printer;
  * is only relevant to pre-Xe_HP platforms (Xe_HP and beyond use the
  * I915_MAX_SS_FUSE_BITS value below).
  */
-#define GEN_MAX_SS_PER_HSW_SLICE	6
+#define GEN_MAX_SS_PER_HSW_SLICE	8
 
 /*
  * Maximum number of 32-bit registers used by hardware to express the
-- 
2.39.2



