Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DD34BE6B8
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349055AbiBUJYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:24:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349060AbiBUJXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:23:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064A238DB3;
        Mon, 21 Feb 2022 01:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBDC760018;
        Mon, 21 Feb 2022 09:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B74C340E9;
        Mon, 21 Feb 2022 09:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434620;
        bh=Jzwig2ETBUjtV3yNVtjB7gtfZ6hB+2/9VrSTOAVKCkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h15QTjv53AGENhR/Zbg4/naI6gepkL/cQIYi5zTBbTjlmE/56AT7oU9aa0qMkX66I
         gS7RGJpwVkA5R80mAXeYBEmVqqKkcJ9aGyDu8GjSB7ZFZlR73BVckT8qd5t3OiDXBN
         kVbbgVbvjR/BlMjAvZJRHjaezmLWbziSqwzXUEoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Subject: [PATCH 5.15 071/196] drm/cma-helper: Set VM_DONTEXPAND for mmap
Date:   Mon, 21 Feb 2022 09:48:23 +0100
Message-Id: <20220221084933.319838096@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Robin Murphy <robin.murphy@arm.com>

commit 59f39bfa6553d598cb22f694d45e89547f420d85 upstream.

drm_gem_cma_mmap() cannot assume every implementation of dma_mmap_wc()
will end up calling remap_pfn_range() (which happens to set the relevant
vma flag, among others), so in order to make sure expectations around
VM_DONTEXPAND are met, let it explicitly set the flag like most other
GEM mmap implementations do.

This avoids repeated warnings on a small minority of systems where the
display is behind an IOMMU, and has a simple driver which does not
override drm_gem_cma_default_funcs. Arm hdlcd is an in-tree affected
driver. Out-of-tree, the Apple DCP driver is affected; this fix is
required for DCP to be mainlined.

[Alyssa: Update commit message.]

Fixes: c40069cb7bd6 ("drm: add mmap() to drm_gem_object_funcs")
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013143654.39031-1-alyssa@rosenzweig.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_cma_helper.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_gem_cma_helper.c
+++ b/drivers/gpu/drm/drm_gem_cma_helper.c
@@ -515,6 +515,7 @@ int drm_gem_cma_mmap(struct drm_gem_obje
 	 */
 	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
 	vma->vm_flags &= ~VM_PFNMAP;
+	vma->vm_flags |= VM_DONTEXPAND;
 
 	cma_obj = to_drm_gem_cma_obj(obj);
 


