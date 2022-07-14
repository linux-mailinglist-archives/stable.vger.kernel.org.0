Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F570574CFB
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 14:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238647AbiGNMGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 08:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238979AbiGNMGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 08:06:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4925C9C1;
        Thu, 14 Jul 2022 05:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D954B824E6;
        Thu, 14 Jul 2022 12:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05F2C36AEB;
        Thu, 14 Jul 2022 12:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657800390;
        bh=Jh3Kqp3PsRoCdV/mDv7WITLyqYY/AxdJ08g/jrYtT8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIgjqA3dm1ZNcOs4sigMBewggrVchZpVTA5rNuae+XM7YrjOQHNW9/uymVQfTZDu9
         Xxi0CncfiWX3qzNg0VM5v0h4yf6r/fp0ZbaKiHiocTVTEU4AKBTXHyDwKXA421eSs6
         PFQ/48Ul/D/UNepuw+Yx03bwVqEsN0vHzE9ihZzdTRjMxUBvOsfx01M+SYgiB0sk6k
         pf/vJ6rMebk8cNf53NU2TFIU0VWQnPNWU6YojkyrNyDhGXnX4Xzep3yXrY3qPwcVvF
         ChOV3jdrTXnDovNmFCdrCyOLJ34wyvUwN6SaPSzogeSgmqYwa2zqftFBvbow6Ak34a
         SOyTtnfKEslWg==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1oBxbv-0059se-RS;
        Thu, 14 Jul 2022 13:06:27 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 04/21] drm/i915/gt: Only invalidate TLBs exposed to user manipulation
Date:   Thu, 14 Jul 2022 13:06:09 +0100
Message-Id: <c0ab69f803cfe439f9218d0c0a930eae563dee83.1657800199.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657800199.git.mchehab@kernel.org>
References: <cover.1657800199.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

Don't flush TLBs when the buffer is only used in the GGTT under full
control of the kernel, as there's no risk of concurrent access
and stale access from prefetch.

We only need to invalidate the TLB if they are accessible by the user.
That helps to reduce the performance regression introduced by TLB
invalidate logic.

Cc: stable@vger.kernel.org
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v2 00/21] at: https://lore.kernel.org/all/cover.1657800199.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/i915_vma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index ef3b04c7e153..646f419b2035 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -538,7 +538,8 @@ int i915_vma_bind(struct i915_vma *vma,
 				   bind_flags);
 	}
 
-	set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+	if (bind_flags & I915_VMA_LOCAL_BIND)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
 
 	atomic_or(bind_flags, &vma->flags);
 	return 0;
-- 
2.36.1

