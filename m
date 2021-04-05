Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B799353D79
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhDEJAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236891AbhDEJAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E86E460238;
        Mon,  5 Apr 2021 08:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613194;
        bh=LHdZhhen3vKYu4pE0APWOszXTbH6gJF9/gz9z/fbL84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzAW4gg7o0DF+Jypk4fptRH62uf3C58ViSIfwdhLf6B3c+Cb8rRYsDLmWWhbpywvB
         uZJffgYG0WlHRySI2a81cJlgYXvVo9l3P09JT0cojN9BsLaw3F23v/ApXi8aJJUE8q
         SMYcOQqa+2gsX74X4mrmpiSv96m3UCGF9PX7qoRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.14 30/52] drm/amdgpu: check alignment on CPU page for bo map
Date:   Mon,  5 Apr 2021 10:53:56 +0200
Message-Id: <20210405085022.967531890@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
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
@@ -2074,8 +2074,8 @@ int amdgpu_vm_bo_map(struct amdgpu_devic
 	uint64_t eaddr;
 
 	/* validate the parameters */
-	if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK ||
-	    size == 0 || size & AMDGPU_GPU_PAGE_MASK)
+	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK ||
+	    size == 0 || size & ~PAGE_MASK)
 		return -EINVAL;
 
 	/* make sure object fit at this offset */
@@ -2142,8 +2142,8 @@ int amdgpu_vm_bo_replace_map(struct amdg
 	int r;
 
 	/* validate the parameters */
-	if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK ||
-	    size == 0 || size & AMDGPU_GPU_PAGE_MASK)
+	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK ||
+	    size == 0 || size & ~PAGE_MASK)
 		return -EINVAL;
 
 	/* make sure object fit at this offset */


