Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414E76CC402
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbjC1O7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbjC1O7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FEEE065
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1C46B81D77
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7E5C433D2;
        Tue, 28 Mar 2023 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015533;
        bh=GZhSue5rY9ROcgCKXYoSzWcRJHzeF9GO76gdvEh9ipQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8abi0akguc4BF7x2BKN5TTq1jPBhX82YMJFhwmorr5TKYumJmKQ3qp2JL54UKeFg
         ZN4slIy7vyQKK+8oKfoHuYmketMC/7Mf6jg9uTnKALO9q9wBTfMm+cBOASTVfwjocM
         ePX4Ho+u11TyZr8BzsCPMcGJ4+BD/11h6jqYFRhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nirmoy Das <nirmoy.das@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/224] drm/i915/gt: perform uc late init after probe error injection
Date:   Tue, 28 Mar 2023 16:40:48 +0200
Message-Id: <20230328142619.539912157@linuxfoundation.org>
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

From: Andrzej Hajda <andrzej.hajda@intel.com>

[ Upstream commit 150784f9285e656373cf3953ef4a7663f1e1a0f2 ]

Probe pseudo errors should be injected only in places where real errors
can be encountered, otherwise unwinding code can be broken.
Placing intel_uc_init_late before i915_inject_probe_error violated
this rule, resulting in following bug:
__intel_gt_disable:655 GEM_BUG_ON(intel_gt_pm_is_awake(gt))

Fixes: 481d458caede ("drm/i915/guc: Add golden context to GuC ADS")
Acked-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230314151920.1065847-1-andrzej.hajda@intel.com
(cherry picked from commit c4252a11131c7f27a158294241466e2a4e7ff94e)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index c7db49749a636..d12ec092e62df 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -691,12 +691,12 @@ int intel_gt_init(struct intel_gt *gt)
 	if (err)
 		goto err_gt;
 
-	intel_uc_init_late(&gt->uc);
-
 	err = i915_inject_probe_error(gt->i915, -EIO);
 	if (err)
 		goto err_gt;
 
+	intel_uc_init_late(&gt->uc);
+
 	intel_migrate_init(&gt->migrate, gt);
 
 	intel_pxp_init(&gt->pxp);
-- 
2.39.2



