Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5932A35401A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240608AbhDEJP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239245AbhDEJPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D810960FE4;
        Mon,  5 Apr 2021 09:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614127;
        bh=+5SrYRVNhL/YDlt1KcL4hRwOiiG//MLFSe01ynDm7VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJB2RDSZAK/5hJsc9/1SDsjJqkcUanLvXLJytLV4d+H5VUNBUTFEhVlYtvvikW9Uk
         /vHiW7ckpB3vNFg57rEk50BUeUqV2b8jM8CoAL0HZRUXnHLJL5scF+DRsMxkqD1PXL
         sLXjq1b8psloPnhLxdnfd6LQv12QRlbdTOOIUB8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 093/152] drm/amdgpu: check alignment on CPU page for bo map
Date:   Mon,  5 Apr 2021 10:54:02 +0200
Message-Id: <20210405085037.272012267@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xℹ Ruoyao <xry111@mengyan1223.wang>

commit e3512fb67093fabdf27af303066627b921ee9bd8 upstream.

The page table of AMDGPU requires an alignment to CPU page so we should
check ioctl parameters for it.  Return -EINVAL if some parameter is
unaligned to CPU page, instead of corrupt the page table sliently.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2195,8 +2195,8 @@ int amdgpu_vm_bo_map(struct amdgpu_devic
 	uint64_t eaddr;
 
 	/* validate the parameters */
-	if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK ||
-	    size == 0 || size & AMDGPU_GPU_PAGE_MASK)
+	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK ||
+	    size == 0 || size & ~PAGE_MASK)
 		return -EINVAL;
 
 	/* make sure object fit at this offset */
@@ -2261,8 +2261,8 @@ int amdgpu_vm_bo_replace_map(struct amdg
 	int r;
 
 	/* validate the parameters */
-	if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK ||
-	    size == 0 || size & AMDGPU_GPU_PAGE_MASK)
+	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK ||
+	    size == 0 || size & ~PAGE_MASK)
 		return -EINVAL;
 
 	/* make sure object fit at this offset */


