Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B395C23A6FB
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgHCM4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgHCMWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FDCF2076B;
        Mon,  3 Aug 2020 12:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457321;
        bh=+II4H3RfJq9qbm60b9uw3j/pv8zcAsh0c81QTLRm2Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2Ap/gset+z8DyHZMCKNNzBDfCeZHGfMmt8XZVo/YF4fbKmmdCNf1kyQ0zTmdkWLd
         u1QMDT0a6jytdsdulcrtw1P+ebb/Asi6cqPB/oS+GiULluTqoWOr/a8nyRh2xQbKDB
         eWeI6wGfzhQOsky75xVSXrfXVSkXU/6wMfApVGA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 025/120] drm/amdgpu: Prevent kernel-infoleak in amdgpu_info_ioctl()
Date:   Mon,  3 Aug 2020 14:18:03 +0200
Message-Id: <20200803121904.071364135@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 543e8669ed9bfb30545fd52bc0e047ca4df7fb31 upstream.

Compiler leaves a 4-byte hole near the end of `dev_info`, causing
amdgpu_info_ioctl() to copy uninitialized kernel stack memory to userspace
when `size` is greater than 356.

In 2015 we tried to fix this issue by doing `= {};` on `dev_info`, which
unfortunately does not initialize that 4-byte hole. Fix it by using
memset() instead.

Cc: stable@vger.kernel.org
Fixes: c193fa91b918 ("drm/amdgpu: information leak in amdgpu_info_ioctl()")
Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -692,9 +692,10 @@ static int amdgpu_info_ioctl(struct drm_
 		return n ? -EFAULT : 0;
 	}
 	case AMDGPU_INFO_DEV_INFO: {
-		struct drm_amdgpu_info_device dev_info = {};
+		struct drm_amdgpu_info_device dev_info;
 		uint64_t vm_size;
 
+		memset(&dev_info, 0, sizeof(dev_info));
 		dev_info.device_id = dev->pdev->device;
 		dev_info.chip_rev = adev->rev_id;
 		dev_info.external_rev = adev->external_rev_id;


