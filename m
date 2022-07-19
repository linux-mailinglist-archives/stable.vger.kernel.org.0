Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74EA579D99
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242010AbiGSMw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242012AbiGSMwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:52:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B956390F;
        Tue, 19 Jul 2022 05:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30D7161772;
        Tue, 19 Jul 2022 12:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7801C341C6;
        Tue, 19 Jul 2022 12:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233231;
        bh=ASsZ87Qcp96nGVuUoINaJyFZXCA14MyEoFJuMLRfDAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbzulWQKUt+fGsyx5e7LXDw8aAwS45oEHBkABZ8+oy5JpQpxJo0w/0YTK1a1zXs2E
         C8MzquWtpAc8GAzldQydFPBsLRX6hUhxeCYWRKMTTDS3XJToFQrhA2o15A7yUNvmv0
         VQbQTMT8Hp1VFNJGoqd2His+Gw9VPccQyHNzB6sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Harrison <John.C.Harrison@Intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 051/231] drm/i915/guc: ADL-N should use the same GuC FW as ADL-S
Date:   Tue, 19 Jul 2022 13:52:16 +0200
Message-Id: <20220719114718.544993954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 25c95bf494067f7bd1dfa8064ef964abe88cafc2 ]

The only difference between the ADL S and P GuC FWs is the HWConfig
support. ADL-N does not support HWConfig, so we should use the same
binary as ADL-S, otherwise the GuC might attempt to fetch a config
table that does not exist. ADL-N is internally identified as an ADL-P,
so we need to special-case it in the FW selection code.

Fixes: 7e28d0b26759 ("drm/i915/adl-n: Enable ADL-N platform")
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: Anusha Srivatsa <anusha.srivatsa@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220621233005.3952293-1-daniele.ceraolospurio@intel.com
(cherry picked from commit 971e4a9781742aaad1587e25fd5582b2dd595ef8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
index 9b6fbad47646..097b0c8b8531 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
@@ -160,6 +160,15 @@ __uc_fw_auto_select(struct drm_i915_private *i915, struct intel_uc_fw *uc_fw)
 	u8 rev = INTEL_REVID(i915);
 	int i;
 
+	/*
+	 * The only difference between the ADL GuC FWs is the HWConfig support.
+	 * ADL-N does not support HWConfig, so we should use the same binary as
+	 * ADL-S, otherwise the GuC might attempt to fetch a config table that
+	 * does not exist.
+	 */
+	if (IS_ADLP_N(i915))
+		p = INTEL_ALDERLAKE_S;
+
 	GEM_BUG_ON(uc_fw->type >= ARRAY_SIZE(blobs_all));
 	fw_blobs = blobs_all[uc_fw->type].blobs;
 	fw_count = blobs_all[uc_fw->type].count;
-- 
2.35.1



