Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BB75C0227
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIUPs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiIUPr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EE3923D3;
        Wed, 21 Sep 2022 08:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC50761BD5;
        Wed, 21 Sep 2022 15:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD097C433C1;
        Wed, 21 Sep 2022 15:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775249;
        bh=ithr9k7O+nzM2l5y5r8KeGH+jQGPQyK/7KtGeFY4fJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zX1pcrUP5OwYv37JM7sjLeddSdUnE4HeIvRRURDmVHpiip4z5QZMeG2Ld2Kek3lbR
         b6gZsTPNFsK55nepBwISd3L6Dz41ILFhRPtC6je+ItUbR6EO4NS6uTORpWCtFXxbfx
         gJRw8mGb+7Wn95Np14V74hXNFbCjtZWqKXCAjryU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.19 29/38] drm/i915: Set correct domains values at _i915_vma_move_to_active
Date:   Wed, 21 Sep 2022 17:46:13 +0200
Message-Id: <20220921153647.186661288@linuxfoundation.org>
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

From: Nirmoy Das <nirmoy.das@intel.com>

commit 08b812985996924c0ccf79d54a31fc9757c0a6ca upstream.

Fix regression introduced by commit:
"drm/i915: Individualize fences before adding to dma_resv obj"
which sets obj->read_domains to 0 for both read and write paths.
Also set obj->write_domain to 0 on read path which was removed by
the commit.

Fixes: 420a07b841d0 ("drm/i915: Individualize fences before adding to dma_resv obj")
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v5.16+
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220907172641.12555-1-nirmoy.das@intel.com
(cherry picked from commit 04f7eb3d4582a0a4da67c86e55fda7de2df86d91)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_vma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1870,12 +1870,13 @@ int _i915_vma_move_to_active(struct i915
 		enum dma_resv_usage usage;
 		int idx;
 
-		obj->read_domains = 0;
 		if (flags & EXEC_OBJECT_WRITE) {
 			usage = DMA_RESV_USAGE_WRITE;
 			obj->write_domain = I915_GEM_DOMAIN_RENDER;
+			obj->read_domains = 0;
 		} else {
 			usage = DMA_RESV_USAGE_READ;
+			obj->write_domain = 0;
 		}
 
 		dma_fence_array_for_each(curr, idx, fence)


