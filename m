Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387C65AB012
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbiIBMse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbiIBMsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CF2F23C2;
        Fri,  2 Sep 2022 05:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A0B621AD;
        Fri,  2 Sep 2022 12:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7528BC433D7;
        Fri,  2 Sep 2022 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121956;
        bh=FltnmrbUJl4Kk01iRhvVTQ+ruxZmvAigpAopAE70PwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJIbfbuDPJYXF2Fy2hfko2XyqHDTD8k36wh/Z8/gGRqnm51OjelOO+mlfLyVq1fuW
         orwqIHGFKfdQFCFlF2JNcGOj4WH1yovXTJKMSq4a6lqfrxGr2+fVylpz51HoyjAWdu
         mCh4SyBZJV1wR4dO8lZggbgZicKglCUYTJg7Tquc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/73] drm/i915/gt: Skip TLB invalidations once wedged
Date:   Fri,  2 Sep 2022 14:19:05 +0200
Message-Id: <20220902121405.797844124@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

[ Upstream commit e5a95c83ed1492c0f442b448b20c90c8faaf702b ]

Skip all further TLB invalidations once the device is wedged and
had been reset, as, on such cases, it can no longer process instructions
on the GPU and the user no longer has access to the TLB's in each engine.

So, an attempt to do a TLB cache invalidation will produce a timeout.

That helps to reduce the performance regression introduced by TLB
invalidate logic.

Cc: stable@vger.kernel.org
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/5aa86564b9ec5fe7fe605c1dd7de76855401ed73.1658924372.git.mchehab@kernel.org
(cherry picked from commit be0366f168033374a93e4c43fdaa1a90ab905184)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 3a76000d15bfd..ed8ad3b263959 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -949,6 +949,9 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	if (I915_SELFTEST_ONLY(gt->awake == -ENODEV))
 		return;
 
+	if (intel_gt_is_wedged(gt))
+		return;
+
 	if (GRAPHICS_VER(i915) == 12) {
 		regs = gen12_regs;
 		num = ARRAY_SIZE(gen12_regs);
-- 
2.35.1



