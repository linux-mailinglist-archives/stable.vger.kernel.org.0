Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6681265D906
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbjADQU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240032AbjADQUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF7EC74A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E97F2B81722
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9C8C433EF;
        Wed,  4 Jan 2023 16:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849240;
        bh=EV5fyugVb4Hrhhura0t+d/w8dUF7LHNL+DIqthJzKEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=of889iUjRpfC8VP51ePLWXesPrdLMxZbsM0ZkYQ3b+yn2bRPETyek412NLZzukomv
         THjjVfuBq9O9dSj9T1ku8VY/uWq9v9Tr6ndt+jT3TWfCnNXU0eYrrFhUJP9xnukl7R
         RqcvxeCP9pSqcwLh3q06CrLWP+4EcRpVW5Vw7tcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 6.1 156/207] drm/etnaviv: move idle mapping reaping into separate function
Date:   Wed,  4 Jan 2023 17:06:54 +0100
Message-Id: <20230104160516.837706350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

commit 5a40837debaa9dcc71765d32ce1a15be068b6cc2 upstream.

The same logic is already used in two different places and now
it will also be needed outside of the compilation unit, so split
it into a separate function.

Cc: stable@vger.kernel.org # 5.19
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c |   23 +++++++++++++++--------
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h |    1 +
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -135,6 +135,19 @@ static void etnaviv_iommu_remove_mapping
 	drm_mm_remove_node(&mapping->vram_node);
 }
 
+void etnaviv_iommu_reap_mapping(struct etnaviv_vram_mapping *mapping)
+{
+	struct etnaviv_iommu_context *context = mapping->context;
+
+	lockdep_assert_held(&context->lock);
+	WARN_ON(mapping->use);
+
+	etnaviv_iommu_remove_mapping(context, mapping);
+	etnaviv_iommu_context_put(mapping->context);
+	mapping->context = NULL;
+	list_del_init(&mapping->mmu_node);
+}
+
 static int etnaviv_iommu_find_iova(struct etnaviv_iommu_context *context,
 				   struct drm_mm_node *node, size_t size)
 {
@@ -202,10 +215,7 @@ static int etnaviv_iommu_find_iova(struc
 		 * this mapping.
 		 */
 		list_for_each_entry_safe(m, n, &list, scan_node) {
-			etnaviv_iommu_remove_mapping(context, m);
-			etnaviv_iommu_context_put(m->context);
-			m->context = NULL;
-			list_del_init(&m->mmu_node);
+			etnaviv_iommu_reap_mapping(m);
 			list_del_init(&m->scan_node);
 		}
 
@@ -257,10 +267,7 @@ static int etnaviv_iommu_insert_exact(st
 	}
 
 	list_for_each_entry_safe(m, n, &scan_list, scan_node) {
-		etnaviv_iommu_remove_mapping(context, m);
-		etnaviv_iommu_context_put(m->context);
-		m->context = NULL;
-		list_del_init(&m->mmu_node);
+		etnaviv_iommu_reap_mapping(m);
 		list_del_init(&m->scan_node);
 	}
 
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
@@ -91,6 +91,7 @@ int etnaviv_iommu_map_gem(struct etnaviv
 	struct etnaviv_vram_mapping *mapping, u64 va);
 void etnaviv_iommu_unmap_gem(struct etnaviv_iommu_context *context,
 	struct etnaviv_vram_mapping *mapping);
+void etnaviv_iommu_reap_mapping(struct etnaviv_vram_mapping *mapping);
 
 int etnaviv_iommu_get_suballoc_va(struct etnaviv_iommu_context *ctx,
 				  struct etnaviv_vram_mapping *mapping,


