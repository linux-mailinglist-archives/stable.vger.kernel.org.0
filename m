Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66BC579C01
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbiGSMfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241041AbiGSMej (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:34:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7A378233;
        Tue, 19 Jul 2022 05:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65299B81B2C;
        Tue, 19 Jul 2022 12:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA744C341C6;
        Tue, 19 Jul 2022 12:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232814;
        bh=fvg2bkj8z5Ppk4ktr8qjTgz1iKiQ/89YzGS0rKplh3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILihPOfB+TXX7/J+HO9it0Px5wmq/iYb1NUOhJPIcJbwErKmo/THsGk4CGfu3ZdXa
         5BbZX8ZMVkn+QMWoQWiWTgfAIHDiR1nnU19LhmRnTtGOIo9UwpXy5gXV9e4yJdcVTh
         zYUlViyZ3MkgWpfF2gMwneAUFGobj1oxClc05zwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Chang <yu.bruce.chang@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/167] drm/i915/dg2: Add Wa_22011100796
Date:   Tue, 19 Jul 2022 13:53:27 +0200
Message-Id: <20220719114703.791187066@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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

From: Bruce Chang <yu.bruce.chang@intel.com>

[ Upstream commit 154cfae6158141b18d65abb0db679bb51a8294e7 ]

Whenever Full soft reset is required, reset all individual engines
first, and then do a full soft reset.

Signed-off-by: Bruce Chang <yu.bruce.chang@intel.com>
cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Ramalingam C <ramalingam.c@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220128185209.18077-5-ramalingam.c@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_reset.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index 91200c43951f..b6697c1d260a 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -623,6 +623,15 @@ static int gen8_reset_engines(struct intel_gt *gt,
 		 */
 	}
 
+	/*
+	 * Wa_22011100796:dg2, whenever Full soft reset is required,
+	 * reset all individual engines firstly, and then do a full soft reset.
+	 *
+	 * This is best effort, so ignore any error from the initial reset.
+	 */
+	if (IS_DG2(gt->i915) && engine_mask == ALL_ENGINES)
+		gen11_reset_engines(gt, gt->info.engine_mask, 0);
+
 	if (GRAPHICS_VER(gt->i915) >= 11)
 		ret = gen11_reset_engines(gt, engine_mask, retry);
 	else
-- 
2.35.1



