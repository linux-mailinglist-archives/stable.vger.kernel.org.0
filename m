Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA4E35BF33
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239343AbhDLJDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239817AbhDLJBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B67961284;
        Mon, 12 Apr 2021 08:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217964;
        bh=Nc6Rfly5SvvWUza6ZLhx8slyRFUcmVCJiKioxGl2ltA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byE0MamxdNOQVHBMjcIiaFzklQgfTPPPGCeaB56Xnpaakzh5vJ6yEJJVguP47BtyT
         k9AlCYHFePa6MXkwHAX4dRlyssnmMP0lIoisWBWQp8vA8lGxGYRoXVK9VI76vGlQW4
         rmTHG/QIrNdkL6f+oG4iKCUeiGm2zoQR3zM3sMnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 022/210] drm/amdgpu: Fix size overflow
Date:   Mon, 12 Apr 2021 10:38:47 +0200
Message-Id: <20210412084016.751526558@linuxfoundation.org>
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

commit 1b0b6e939f112949089e32ec89fd27796677263a upstream.

ttm->num_pages is uint32. Hit overflow when << PAGE_SHIFT directly

Fixes: 230c079fdcf4 ("drm/ttm: make num_pages uint32_t")
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -907,7 +907,7 @@ static int amdgpu_ttm_tt_pin_userptr(str
 
 	/* Allocate an SG array and squash pages into it */
 	r = sg_alloc_table_from_pages(ttm->sg, ttm->pages, ttm->num_pages, 0,
-				      ttm->num_pages << PAGE_SHIFT,
+				      (u64)ttm->num_pages << PAGE_SHIFT,
 				      GFP_KERNEL);
 	if (r)
 		goto release_sg;


