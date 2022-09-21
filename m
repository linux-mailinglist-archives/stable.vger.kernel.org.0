Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05B15C0244
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiIUPuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiIUPuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:50:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82AA9A9D7;
        Wed, 21 Sep 2022 08:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D8A863126;
        Wed, 21 Sep 2022 15:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB80FC433C1;
        Wed, 21 Sep 2022 15:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775303;
        bh=oc6alvbrAk656ZrKOEIJJIun1IBR2lDaOl7X6JBRJKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvBIlQ5wKlF777Yya+s6pik7O4LfNM6Sn0j3n/XLj/ClO6fOeR6CvkDodIXHRzLZK
         YuNodbMqnJdj2+HVwJEL1Vj4QL4b4tyI/VKlS2lP8tyVcCptOdMfjruL++3WivuezX
         uhEQRHpB/llICKr03wlbZmK8bpKweZVKXAFcAdZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 17/38] drm/i915/guc: Cancel GuC engine busyness worker synchronously
Date:   Wed, 21 Sep 2022 17:46:01 +0200
Message-Id: <20220921153646.824146216@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit aee5ae7c8492eaca2be20d202887c9c716ffc86f ]

The worker is canceled in gt_park path, but earlier it was assumed that
gt_park path cannot sleep and the cancel is asynchronous. This caused a
race with suspend flow where the worker runs after suspend and causes an
unclaimed register access warning. Cancel the worker synchronously since
the gt_park is indeed allowed to sleep.

v2: Fix author name and sign-off mismatch

Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4419
Fixes: 77cdd054dd2c ("drm/i915/pmu: Connect engine busyness stats from GuC to pmu")
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220827002135.139349-1-umesh.nerlige.ramappa@intel.com
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit 31335aa8e08be3fe10c50aecd2f11aba77544a78)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 96022f49f9b5..d7e4681d7297 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1438,7 +1438,12 @@ void intel_guc_busyness_park(struct intel_gt *gt)
 	if (!guc_submission_initialized(guc))
 		return;
 
-	cancel_delayed_work(&guc->timestamp.work);
+	/*
+	 * There is a race with suspend flow where the worker runs after suspend
+	 * and causes an unclaimed register access warning. Cancel the worker
+	 * synchronously here.
+	 */
+	cancel_delayed_work_sync(&guc->timestamp.work);
 
 	/*
 	 * Before parking, we should sample engine busyness stats if we need to.
-- 
2.35.1



