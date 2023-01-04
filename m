Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9507365D9BD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbjADQ2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239936AbjADQ2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:28:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CA543A09
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:27:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BBC6617A8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F86FC433EF;
        Wed,  4 Jan 2023 16:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849650;
        bh=WdZBzUqzHsSXtl/ImaD5Xx7b6UTjmMax8khZpOu+Gws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoUQMnl6Oo1sMiWNpa9OtxhlsVup48K8XSzjYDas1jWQci49GnSTFGr2LrfiJ2HyX
         LapuQwU6NG7cSxRh++QyulWNTEStDXLqQf0SK8NeSkpqAWTOxKp2/nRa1YmyzC7N/w
         GZReE9FGcMVGg7ZNXj41OMEuPCA3tTGqnMAWF1fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Wilson <chris.p.wilson@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.0 173/177] drm/i915/migrate: Account for the reserved_space
Date:   Wed,  4 Jan 2023 17:07:44 +0100
Message-Id: <20230104160512.918333942@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Chris Wilson <chris.p.wilson@intel.com>

commit 31a2e6cbe8a4eb0d1650fff4b77872b744e14a62 upstream.

If the ring is nearly full when calling into emit_pte(), we might
incorrectly trample the reserved_space when constructing the packet to
emit the PTEs. This then triggers the GEM_BUG_ON(rq->reserved_space >
ring->space) when later submitting the request, since the request itself
doesn't have enough space left in the ring to emit things like
workarounds, breadcrumbs etc.

v2: Fix the whitespace errors

Testcase: igt@i915_selftests@live_emit_pte_full_ring
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7535
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6889
Fixes: cf586021642d ("drm/i915/gt: Pipelined page migration")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
Tested-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221202122844.428006-1-matthew.auld@intel.com
(cherry picked from commit 35168a6c4ed53db4f786858bac23b1474fd7d0dc)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -341,6 +341,16 @@ static int emit_no_arbitration(struct i9
 	return 0;
 }
 
+static int max_pte_pkt_size(struct i915_request *rq, int pkt)
+{
+	struct intel_ring *ring = rq->ring;
+
+	pkt = min_t(int, pkt, (ring->space - rq->reserved_space) / sizeof(u32) + 5);
+	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+
+	return pkt;
+}
+
 static int emit_pte(struct i915_request *rq,
 		    struct sgt_dma *it,
 		    enum i915_cache_level cache_level,
@@ -387,8 +397,7 @@ static int emit_pte(struct i915_request
 		return PTR_ERR(cs);
 
 	/* Pack as many PTE updates as possible into a single MI command */
-	pkt = min_t(int, dword_length, ring->space / sizeof(u32) + 5);
-	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+	pkt = max_pte_pkt_size(rq, dword_length);
 
 	hdr = cs;
 	*cs++ = MI_STORE_DATA_IMM | REG_BIT(21); /* as qword elements */
@@ -421,8 +430,7 @@ static int emit_pte(struct i915_request
 				}
 			}
 
-			pkt = min_t(int, dword_rem, ring->space / sizeof(u32) + 5);
-			pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+			pkt = max_pte_pkt_size(rq, dword_rem);
 
 			hdr = cs;
 			*cs++ = MI_STORE_DATA_IMM | REG_BIT(21);


