Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFB9594B94
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346193AbiHPAW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353101AbiHPAUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:20:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C220717B822;
        Mon, 15 Aug 2022 13:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C4CF6117D;
        Mon, 15 Aug 2022 20:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EA3C433D6;
        Mon, 15 Aug 2022 20:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595611;
        bh=3DYUns0bvxVARDYeCIucXBYeeHnzF1psCJsi+8eGx64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKxrsOOkUB5HmtOu4i5MxqWBg1VXMODRJnvNAyaihnKSQ2L3UmvLDFBdSKmz1R9tq
         UmjgDECoiA0FcCa8lYsEoKWOuk+F8K5t+jZdRbtceZzuw+Vmb2PYeME2VpyGhxo928
         CnXDMDfFKy03i+QYbSSbKBAFkvke/xPUb4j1prWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Wang <patrick.wang.shcn@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0819/1157] mm: percpu: use kmemleak_ignore_phys() instead of kmemleak_free()
Date:   Mon, 15 Aug 2022 20:02:55 +0200
Message-Id: <20220815180512.251603428@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Patrick Wang <patrick.wang.shcn@gmail.com>

[ Upstream commit a317ebccaa3609917a2c021af870cf3fa607ab0c ]

Kmemleak recently added a rbtree to store the objects allocted with
physical address.  Those objects can't be freed with kmemleak_free().

According to the comments, percpu allocations are tracked by kmemleak
separately.  Kmemleak_free() was used to avoid the unnecessary
tracking.  If kmemleak_free() fails, those objects would be scanned by
kmemleak, which is unnecessary but shouldn't lead to other effects.

Use kmemleak_ignore_phys() instead of kmemleak_free() for those
objects.

Link: https://lkml.kernel.org/r/20220705113158.127600-1-patrick.wang.shcn@gmail.com
Fixes: 0c24e061196c ("mm: kmemleak: add rbtree and store physical address for objects allocated with PA")
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/percpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3633eeefaa0d..27697b2429c2 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3104,7 +3104,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 			goto out_free_areas;
 		}
 		/* kmemleak tracks the percpu allocations separately */
-		kmemleak_free(ptr);
+		kmemleak_ignore_phys(__pa(ptr));
 		areas[group] = ptr;
 
 		base = min(ptr, base);
@@ -3304,7 +3304,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 				goto enomem;
 			}
 			/* kmemleak tracks the percpu allocations separately */
-			kmemleak_free(ptr);
+			kmemleak_ignore_phys(__pa(ptr));
 			pages[j++] = virt_to_page(ptr);
 		}
 	}
@@ -3417,7 +3417,7 @@ void __init setup_per_cpu_areas(void)
 	if (!ai || !fc)
 		panic("Failed to allocate memory for percpu areas.");
 	/* kmemleak tracks the percpu allocations separately */
-	kmemleak_free(fc);
+	kmemleak_ignore_phys(__pa(fc));
 
 	ai->dyn_size = unit_size;
 	ai->unit_size = unit_size;
-- 
2.35.1



