Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F73676E57
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjAVPJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjAVPJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:09:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940111F4A8
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:09:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B3DEB80B18
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F00C4339B;
        Sun, 22 Jan 2023 15:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400167;
        bh=SCyM8HrUweYpQq+N+YkET1rbG1VnqhTbZXLSVK+UK+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/oHjMDZ0YNpxCs4CndZWHwR2+7Axdb5TFtObKo7QYRHJ4NWIilYUB/+01ut4b+gf
         IInVs5Fl7CHVK3inNuHdZyVFU6VVPWzylqItIX1e9P3288cuCE7ratjEbxDlsQs29R
         tW5oWW4cfusCGtq9NZw8oaQNBKXHu+Y2P3nwNN5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/55] drm/i915/gt: Reset twice
Date:   Sun, 22 Jan 2023 16:03:57 +0100
Message-Id: <20230122150222.670650159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit d3de5616d36462a646f5b360ba82d3b09ff668eb ]

After applying an engine reset, on some platforms like Jasperlake, we
occasionally detect that the engine state is not cleared until shortly
after the resume. As we try to resume the engine with volatile internal
state, the first request fails with a spurious CS event (it looks like
it reports a lite-restore to the hung context, instead of the expected
idle->active context switch).

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221212161338.1007659-1-andi.shyti@linux.intel.com
(cherry picked from commit 3db9d590557da3aa2c952f2fecd3e9b703dad790)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_reset.c | 34 ++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index 8cea42379dd7..48aed34e19df 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -257,6 +257,7 @@ static int ironlake_do_reset(struct intel_gt *gt,
 static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 {
 	struct intel_uncore *uncore = gt->uncore;
+	int loops = 2;
 	int err;
 
 	/*
@@ -264,17 +265,38 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 	 * for fifo space for the write or forcewake the chip for
 	 * the read
 	 */
-	intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
+	do {
+		intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
 
-	/* Wait for the device to ack the reset requests */
-	err = __intel_wait_for_register_fw(uncore,
-					   GEN6_GDRST, hw_domain_mask, 0,
-					   500, 0,
-					   NULL);
+		/*
+		 * Wait for the device to ack the reset requests.
+		 *
+		 * On some platforms, e.g. Jasperlake, we see that the
+		 * engine register state is not cleared until shortly after
+		 * GDRST reports completion, causing a failure as we try
+		 * to immediately resume while the internal state is still
+		 * in flux. If we immediately repeat the reset, the second
+		 * reset appears to serialise with the first, and since
+		 * it is a no-op, the registers should retain their reset
+		 * value. However, there is still a concern that upon
+		 * leaving the second reset, the internal engine state
+		 * is still in flux and not ready for resuming.
+		 */
+		err = __intel_wait_for_register_fw(uncore, GEN6_GDRST,
+						   hw_domain_mask, 0,
+						   2000, 0,
+						   NULL);
+	} while (err == 0 && --loops);
 	if (err)
 		DRM_DEBUG_DRIVER("Wait for 0x%08x engines reset failed\n",
 				 hw_domain_mask);
 
+	/*
+	 * As we have observed that the engine state is still volatile
+	 * after GDRST is acked, impose a small delay to let everything settle.
+	 */
+	udelay(50);
+
 	return err;
 }
 
-- 
2.39.0



