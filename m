Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDD86CC401
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbjC1O7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjC1O7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60735E3BB
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:58:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0317B81D75
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161CBC433D2;
        Tue, 28 Mar 2023 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015530;
        bh=IqEiUQbttfL/xOv88x+u1C59kMEht3yVQg2svo++ADY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUoeqHn+s7MSmemyj/hawrOLA//CwyO1QZs0A6xvoxG8iHFBz5GkPkiezE1NkhkvC
         mHoNtTDU/cL6vRmKkg5qWJ7PewYz+ukrjSZZbmrchRj8QNqnxPa2VQp/Slw4pCZExq
         lZqUNFwIKajEgbrghtsqnWYgPFJwCuWSTmkCEg/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Harrison <John.C.Harrison@Intel.com>,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Aravind Iddamsetty <aravind.iddamsetty@intel.com>,
        Michael Cheng <michael.cheng@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/224] drm/i915/guc: Fix missing ecodes
Date:   Tue, 28 Mar 2023 16:40:47 +0200
Message-Id: <20230328142619.498600790@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 8df23e4c4f72f4e201c28e6fb0a67e2dbf30628a ]

Error captures are tagged with an 'ecode'. This is a pseduo-unique magic
number that is meant to distinguish similar seeming bugs with
different underlying signatures. It is a combination of two ring state
registers. Unfortunately, the register state being used is only valid
in execlist mode. In GuC mode, the register state exists in a separate
list of arbitrary register address/value pairs rather than the named
entry structure. So, search through that list to find the two exciting
registers and copy them over to the structure's named members.

v2: if else if instead of if if (Alan)

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Fixes: a6f0f9cf330a ("drm/i915/guc: Plumb GuC-capture into gpu_coredump")
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
Cc: Michael Cheng <michael.cheng@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230311063714.570389-2-John.C.Harrison@Intel.com
(cherry picked from commit 9724ecdbb9ddd6da3260e4a442574b90fc75188a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/uc/intel_guc_capture.c    | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index 13118609339ac..1e1fa20fb41c9 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -1556,6 +1556,27 @@ int intel_guc_capture_print_engine_node(struct drm_i915_error_state_buf *ebuf,
 
 #endif //CONFIG_DRM_I915_CAPTURE_ERROR
 
+static void guc_capture_find_ecode(struct intel_engine_coredump *ee)
+{
+	struct gcap_reg_list_info *reginfo;
+	struct guc_mmio_reg *regs;
+	i915_reg_t reg_ipehr = RING_IPEHR(0);
+	i915_reg_t reg_instdone = RING_INSTDONE(0);
+	int i;
+
+	if (!ee->guc_capture_node)
+		return;
+
+	reginfo = ee->guc_capture_node->reginfo + GUC_CAPTURE_LIST_TYPE_ENGINE_INSTANCE;
+	regs = reginfo->regs;
+	for (i = 0; i < reginfo->num_regs; i++) {
+		if (regs[i].offset == reg_ipehr.reg)
+			ee->ipehr = regs[i].value;
+		else if (regs[i].offset == reg_instdone.reg)
+			ee->instdone.instdone = regs[i].value;
+	}
+}
+
 void intel_guc_capture_free_node(struct intel_engine_coredump *ee)
 {
 	if (!ee || !ee->guc_capture_node)
@@ -1597,6 +1618,7 @@ void intel_guc_capture_get_matching_node(struct intel_gt *gt,
 			list_del(&n->link);
 			ee->guc_capture_node = n;
 			ee->guc_capture = guc->capture;
+			guc_capture_find_ecode(ee);
 			return;
 		}
 	}
-- 
2.39.2



