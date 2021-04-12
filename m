Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBE735BF68
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbhDLJGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239022AbhDLJCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE16961279;
        Mon, 12 Apr 2021 09:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218060;
        bh=4axfGow5Za1rXLA7i86IV3xMvzcIupo+VCkPC/mZgCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5TOWXQctm2x0XWqyVzrOuirwKD6NbqaNyB/3Uz4fiBtgedu+e91DNhFJXPojLYF0
         TrKlccSKpwUIlX6QNjpKR8YUvqwO/R5wkvqcE3xJLRHuNH2UrhXEdlutbI/bVyRiQ7
         fcfmWY74YGltPPVY/hL5CjHRFxXlt+v8jr707fVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 021/210] drm/radeon: Fix size overflow
Date:   Mon, 12 Apr 2021 10:38:46 +0200
Message-Id: <20210412084016.722085761@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

commit 2efc021060c2aa55e1e8f7b98249d3ea63232fc7 upstream.

ttm->num_pages is uint32. Hit overflow when << PAGE_SHIFT directly

Fixes: 230c079fdcf4 ("drm/ttm: make num_pages uint32_t")
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_ttm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -365,7 +365,7 @@ static int radeon_ttm_tt_pin_userptr(str
 	if (gtt->userflags & RADEON_GEM_USERPTR_ANONONLY) {
 		/* check that we only pin down anonymous memory
 		   to prevent problems with writeback */
-		unsigned long end = gtt->userptr + ttm->num_pages * PAGE_SIZE;
+		unsigned long end = gtt->userptr + (u64)ttm->num_pages * PAGE_SIZE;
 		struct vm_area_struct *vma;
 		vma = find_vma(gtt->usermm, gtt->userptr);
 		if (!vma || vma->vm_file || vma->vm_end < end)
@@ -387,7 +387,7 @@ static int radeon_ttm_tt_pin_userptr(str
 	} while (pinned < ttm->num_pages);
 
 	r = sg_alloc_table_from_pages(ttm->sg, ttm->pages, ttm->num_pages, 0,
-				      ttm->num_pages << PAGE_SHIFT,
+				      (u64)ttm->num_pages << PAGE_SHIFT,
 				      GFP_KERNEL);
 	if (r)
 		goto release_sg;


