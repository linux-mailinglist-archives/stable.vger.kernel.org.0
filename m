Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514506CC2A3
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbjC1OrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjC1Oq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B4CE05F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA6016181D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCBFC433D2;
        Tue, 28 Mar 2023 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014802;
        bh=h+rM9Ro5SWa307yziHccNUDK8JRR76SfqOnp9Wtk7vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBnROsskiclqiAk9HbhnSxMgmvXJPxS1Yrhg0Hi2XwaQNKUBFTiO+mSQAN5rkN4Rl
         liTbO8Hz/N3VLstTz69iHsyBADZQpjCdn5Zjjp8Q47/I2uZ54yWsPBCY4xcQDdcuCn
         enbw4gV5gxiRr3hT8a35/TgWd9Y8huHrZoUgRLd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nirmoy Das <nirmoy.das@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 057/240] drm/i915/gt: perform uc late init after probe error injection
Date:   Tue, 28 Mar 2023 16:40:20 +0200
Message-Id: <20230328142622.091001181@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index 9c18b5f2e7892..7868da20d5ea3 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -745,12 +745,12 @@ int intel_gt_init(struct intel_gt *gt)
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



