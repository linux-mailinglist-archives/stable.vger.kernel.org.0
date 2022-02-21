Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D804BDC2E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiBUJ1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349303AbiBUJZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:25:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1E639699;
        Mon, 21 Feb 2022 01:10:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DD9D608C4;
        Mon, 21 Feb 2022 09:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A41C340E9;
        Mon, 21 Feb 2022 09:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434626;
        bh=64VlcYegJ7J3ajnlObHc0xZ4ibsZb9NovkvekZYyx/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDuHZrw4vynd7iesf82NmKOe8TclrpyOA4WGq+1/wfRfV9cEy3Sg/ny1n2AoVOssG
         PeLYSLDmgOcLzVKIs0V9nNRbWC4C+W2/4+A1HOpB8tm0sT3IF4D5cXb1Fxz3Xl8JIy
         YAPpdO49MDeRi4GVSBkxf0d5PAvXxblIOqSXFvnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 073/196] drm/i915/ttm: tweak priority hint selection
Date:   Mon, 21 Feb 2022 09:48:25 +0100
Message-Id: <20220221084933.386477663@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

commit 0bdc0a0699929c814a8aecd55d2accb8c11beae2 upstream.

For some reason we are selecting PRIO_HAS_PAGES when we don't have
mm.pages, and vice versa.

v2(Thomas):
  - Add missing fixes tag

Fixes: 213d50927763 ("drm/i915/ttm: Introduce a TTM i915 gem object backend")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220209111652.468762-1-matthew.auld@intel.com
(cherry picked from commit ba2c5d15022a565da187d90e2fe44768e33e5034)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -759,11 +759,9 @@ static void i915_ttm_adjust_lru(struct d
 	if (obj->mm.madv != I915_MADV_WILLNEED) {
 		bo->priority = I915_TTM_PRIO_PURGE;
 	} else if (!i915_gem_object_has_pages(obj)) {
-		if (bo->priority < I915_TTM_PRIO_HAS_PAGES)
-			bo->priority = I915_TTM_PRIO_HAS_PAGES;
+		bo->priority = I915_TTM_PRIO_NO_PAGES;
 	} else {
-		if (bo->priority > I915_TTM_PRIO_NO_PAGES)
-			bo->priority = I915_TTM_PRIO_NO_PAGES;
+		bo->priority = I915_TTM_PRIO_HAS_PAGES;
 	}
 
 	ttm_bo_move_to_lru_tail(bo, bo->resource, NULL);


