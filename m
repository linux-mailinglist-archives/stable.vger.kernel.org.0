Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5146DEF30
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjDLItB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjDLIsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963747ED9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B418D6311B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84C2C433EF;
        Wed, 12 Apr 2023 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289264;
        bh=AeKYbk+bSL0H5ExY4FVuP8fdSoNMmFesGea8FnmH6Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEtY+d9aRUHnKR1c4Fw8QWJHWMBTtKeXXHkt0OJ78A367K/R7Tww0XPmYhpHatP5K
         yHgGjMrlaWELfBDWwEN6vWNkOwO3cQkESxzAl/8pvV2p27QZE74p5c3V+871jngXjr
         f83dtpNfvoz7tscBaFDIYouyAzph3HbhXhd+0BP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 033/173] drm/i915/huc: Cancel HuC delayed load timer on reset.
Date:   Wed, 12 Apr 2023 10:32:39 +0200
Message-Id: <20230412082839.416958261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit c74237496fbc799257b091179dd01a3200f7314d ]

In the rare case where we do a full GT reset after starting the HuC
load and before it completes (which basically boils down to i915 hanging
during init), we need to cancel the delayed load fence, as it will be
re-initialized in the post-reset recovery.

Fixes: 27536e03271d ("drm/i915/huc: track delayed HuC load with a fence")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Reviewed-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230313205556.1174503-1-daniele.ceraolospurio@intel.com
(cherry picked from commit cdf7911f7dbcb37228409a63bf75630776c45a15)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_huc.c | 7 +++++++
 drivers/gpu/drm/i915/gt/uc/intel_huc.h | 7 +------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_huc.c b/drivers/gpu/drm/i915/gt/uc/intel_huc.c
index 410905da8e974..0c103ca160d10 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_huc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_huc.c
@@ -235,6 +235,13 @@ static void delayed_huc_load_fini(struct intel_huc *huc)
 	i915_sw_fence_fini(&huc->delayed_load.fence);
 }
 
+int intel_huc_sanitize(struct intel_huc *huc)
+{
+	delayed_huc_load_complete(huc);
+	intel_uc_fw_sanitize(&huc->fw);
+	return 0;
+}
+
 static bool vcs_supported(struct intel_gt *gt)
 {
 	intel_engine_mask_t mask = gt->info.engine_mask;
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_huc.h b/drivers/gpu/drm/i915/gt/uc/intel_huc.h
index 52db03620c609..db555b3c1f562 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_huc.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_huc.h
@@ -41,6 +41,7 @@ struct intel_huc {
 	} delayed_load;
 };
 
+int intel_huc_sanitize(struct intel_huc *huc);
 void intel_huc_init_early(struct intel_huc *huc);
 int intel_huc_init(struct intel_huc *huc);
 void intel_huc_fini(struct intel_huc *huc);
@@ -54,12 +55,6 @@ bool intel_huc_is_authenticated(struct intel_huc *huc);
 void intel_huc_register_gsc_notifier(struct intel_huc *huc, struct bus_type *bus);
 void intel_huc_unregister_gsc_notifier(struct intel_huc *huc, struct bus_type *bus);
 
-static inline int intel_huc_sanitize(struct intel_huc *huc)
-{
-	intel_uc_fw_sanitize(&huc->fw);
-	return 0;
-}
-
 static inline bool intel_huc_is_supported(struct intel_huc *huc)
 {
 	return intel_uc_fw_is_supported(&huc->fw);
-- 
2.39.2



