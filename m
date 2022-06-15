Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2289B54CCF5
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 17:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242530AbiFOP3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 11:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355365AbiFOP2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 11:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CBC4F456;
        Wed, 15 Jun 2022 08:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DE6461730;
        Wed, 15 Jun 2022 15:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075C2C341C4;
        Wed, 15 Jun 2022 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655306866;
        bh=ArrWWi9aGs9TPTpy73ldENPFG9RCYJiCftXoVPyfiXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+Z9a8tBUvrdOq9En5CSui7C1egHykyAomklROUSNevyZlUzrxdBtW+8Jg/Sbs3dx
         B/frSxNCMCV1HpkQb3FUy9yPEHvE/C4Fgcscb6nwZk2wud73DWJQmGG+ZnZeaMqoqj
         S4tTuphrd2FjPf2ytW5WMFAYIzf4OoLS6qhqVzgqnTBXWADmBbQnxh9XrDdAC5v4o8
         DKszVAokucAtHdAzZu2vvm0TGcdwwfuXbJEyhSwPMcZQ73CL7YMWu1oShtibuLPhCx
         +43Tz0HKhqsADIEkozMT7BH7OSAxi6O3sxqaB4RdVWT2S1xvBhG2DqLK/O3jJNGX25
         2jkOkUinAk7vQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o1Uvm-00A4Jm-FD;
        Wed, 15 Jun 2022 16:27:42 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        "Fei Yang" <fei.yang@intel.com>,
        "Thomas Hellstrom" <thomas.hellstrom@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        Andi Shyti <andi.shyti@linux.intel.com>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/6] drm/i915/gt: Only invalidate TLBs exposed to user manipulation
Date:   Wed, 15 Jun 2022 16:27:38 +0100
Message-Id: <387b9a8d3e719ad2db4fce56c0bfc0f909fd6df6.1655306128.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655306128.git.mchehab@kernel.org>
References: <cover.1655306128.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
control of the kernel, as there's no risk of of concurrent access
and stale access from prefetch.

We only need to invalidate the TLB if they are accessible by the user.

Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")

Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

See [PATCH 0/6] at: https://lore.kernel.org/all/cover.1655306128.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/i915_vma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 0bffb70b3c5f..7989986161e8 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -537,7 +537,8 @@ int i915_vma_bind(struct i915_vma *vma,
 				   bind_flags);
 	}
 
-	set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+	if (bind_flags & I915_VMA_LOCAL_BIND)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
 
 	atomic_or(bind_flags, &vma->flags);
 	return 0;
-- 
2.36.1

