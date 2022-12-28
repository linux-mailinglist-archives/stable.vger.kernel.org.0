Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9173657BE9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbiL1P06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiL1P0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5FDB05
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CE49B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FD2C433EF;
        Wed, 28 Dec 2022 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241196;
        bh=gb2+8WEVCParMDt/c+JhBcm5qkrAhe164cAQF9O891U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ernk3HwIKUkHUN77x5TM2sj2tDdLbcCU2M4Sjov94aLB2E98RY6GGLcLGEWc+0Nxl
         B69Gf2tLJhSrBssWDnKehepbiCvktKvhLJVY7yFehg5J8dn/Q0SwGAziY5jaw2J/tt
         Mb9lGgYSh20gjWuTDEdgsXXIN7A+D3O2iAOM1vlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0252/1073] drm/i915/guc: Add a helper for log buffer size
Date:   Wed, 28 Dec 2022 15:30:40 +0100
Message-Id: <20221228144334.865340615@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Previn <alan.previn.teres.alexis@intel.com>

[ Upstream commit 5ce27d6210018e972197ff7e5da6309f919fd61b ]

Add a helper to get GuC log buffer size.

Signed-off-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220728022028.2190627-2-John.C.Harrison@Intel.com
Stable-dep-of: befb231d5de2 ("drm/i915/guc: Fix GuC error capture sizing estimation and reporting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c | 49 ++++++++++++----------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
index 25b2d7ce6640..492bbf419d4d 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
@@ -15,6 +15,32 @@
 
 static void guc_log_copy_debuglogs_for_relay(struct intel_guc_log *log);
 
+static u32 intel_guc_log_size(struct intel_guc_log *log)
+{
+	/*
+	 *  GuC Log buffer Layout:
+	 *
+	 *  NB: Ordering must follow "enum guc_log_buffer_type".
+	 *
+	 *  +===============================+ 00B
+	 *  |      Debug state header       |
+	 *  +-------------------------------+ 32B
+	 *  |    Crash dump state header    |
+	 *  +-------------------------------+ 64B
+	 *  |     Capture state header      |
+	 *  +-------------------------------+ 96B
+	 *  |                               |
+	 *  +===============================+ PAGE_SIZE (4KB)
+	 *  |          Debug logs           |
+	 *  +===============================+ + DEBUG_SIZE
+	 *  |        Crash Dump logs        |
+	 *  +===============================+ + CRASH_SIZE
+	 *  |         Capture logs          |
+	 *  +===============================+ + CAPTURE_SIZE
+	 */
+	return PAGE_SIZE + CRASH_BUFFER_SIZE + DEBUG_BUFFER_SIZE + CAPTURE_BUFFER_SIZE;
+}
+
 /**
  * DOC: GuC firmware log
  *
@@ -461,32 +487,11 @@ int intel_guc_log_create(struct intel_guc_log *log)
 
 	GEM_BUG_ON(log->vma);
 
-	/*
-	 *  GuC Log buffer Layout
-	 * (this ordering must follow "enum guc_log_buffer_type" definition)
-	 *
-	 *  +===============================+ 00B
-	 *  |      Debug state header       |
-	 *  +-------------------------------+ 32B
-	 *  |    Crash dump state header    |
-	 *  +-------------------------------+ 64B
-	 *  |     Capture state header      |
-	 *  +-------------------------------+ 96B
-	 *  |                               |
-	 *  +===============================+ PAGE_SIZE (4KB)
-	 *  |          Debug logs           |
-	 *  +===============================+ + DEBUG_SIZE
-	 *  |        Crash Dump logs        |
-	 *  +===============================+ + CRASH_SIZE
-	 *  |         Capture logs          |
-	 *  +===============================+ + CAPTURE_SIZE
-	 */
 	if (intel_guc_capture_output_min_size_est(guc) > CAPTURE_BUFFER_SIZE)
 		DRM_WARN("GuC log buffer for state_capture maybe too small. %d < %d\n",
 			 CAPTURE_BUFFER_SIZE, intel_guc_capture_output_min_size_est(guc));
 
-	guc_log_size = PAGE_SIZE + CRASH_BUFFER_SIZE + DEBUG_BUFFER_SIZE +
-		       CAPTURE_BUFFER_SIZE;
+	guc_log_size = intel_guc_log_size(log);
 
 	vma = intel_guc_allocate_vma(guc, guc_log_size);
 	if (IS_ERR(vma)) {
-- 
2.35.1



