Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2A56FC37
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbiGKJkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiGKJkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:40:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657B35289A;
        Mon, 11 Jul 2022 02:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EA44B80E7A;
        Mon, 11 Jul 2022 09:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F8DC34115;
        Mon, 11 Jul 2022 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531236;
        bh=Oc8LmOjFtOIVcOaO6TY+N7i6SkFtqCkhytIlUUqIE84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNnAc6+ejm+pORN3xmd56F4tyttPHp99UVySseM3AO/H2S0vY89Fw/jUil5qhMdoO
         h5kZc0/K8zJMkzorcDJg88vAqk77rB3IkIFujMai3Fo5iqYOTN/pxZ7iQpWnpk3vh3
         Gx/CLunp40o70he0v11edxgViunAKpLz+4RwjvEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Matt Roper <matthew.d.roper@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/230] drm/i915: Disable bonding on gen12+ platforms
Date:   Mon, 11 Jul 2022 11:04:47 +0200
Message-Id: <20220711090604.961757355@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit ce7e75c7ef1bf8ea3d947da8c674d2f40fd7d734 ]

Disable bonding on gen12+ platforms aside from ones already supported by
the i915 - TGL, RKL, and ADL-S.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210728192100.132425-1-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index ee0c0b712522..ba2e037a82e4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -442,6 +442,13 @@ set_proto_ctx_engines_bond(struct i915_user_extension __user *base, void *data)
 	u16 idx, num_bonds;
 	int err, n;
 
+	if (GRAPHICS_VER(i915) >= 12 && !IS_TIGERLAKE(i915) &&
+	    !IS_ROCKETLAKE(i915) && !IS_ALDERLAKE_S(i915)) {
+		drm_dbg(&i915->drm,
+			"Bonding on gen12+ aside from TGL, RKL, and ADL_S not supported\n");
+		return -ENODEV;
+	}
+
 	if (get_user(idx, &ext->virtual_index))
 		return -EFAULT;
 
-- 
2.35.1



