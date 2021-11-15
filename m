Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41895450B84
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbhKORZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:25:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237774AbhKORYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F58663248;
        Mon, 15 Nov 2021 17:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996587;
        bh=PZdRMieWAzNMSAGH2/e0RFLuUg7It5s/xjYSrYzHf9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEZo22OGUx2dd01ruftuXGf1ovfGYz3dEGthigtEe4dUgfix/xeRgQK5IL8GbisC9
         Z22AwgTOGjLjix616od4+N9UZC6svKcD/yKsALFiz5qmWlKrGjJMbrXBPtpV4e41Nf
         uAWmsH4zu7+QZOojIoQ0AlyvmXNMXd9a6pbjCmPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/355] drm/amdgpu: fix warning for overflow check
Date:   Mon, 15 Nov 2021 18:01:58 +0100
Message-Id: <20211115165320.045044506@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 335aea75b0d95518951cad7c4c676e6f1c02c150 ]

The overflow check in amdgpu_bo_list_create() causes a warning with
clang-14 on 64-bit architectures, since the limit can never be
exceeded.

drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c:74:18: error: result of comparison of constant 256204778801521549 with expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (num_entries > (SIZE_MAX - sizeof(struct amdgpu_bo_list))
            ~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The check remains useful for 32-bit architectures, so just avoid the
warning by using size_t as the type for the count.

Fixes: 920990cb080a ("drm/amdgpu: allocate the bo_list array after the list")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 85b0515c0fdcf..e0d2f79571ef5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -61,7 +61,7 @@ static void amdgpu_bo_list_free(struct kref *ref)
 
 int amdgpu_bo_list_create(struct amdgpu_device *adev, struct drm_file *filp,
 			  struct drm_amdgpu_bo_list_entry *info,
-			  unsigned num_entries, struct amdgpu_bo_list **result)
+			  size_t num_entries, struct amdgpu_bo_list **result)
 {
 	unsigned last_entry = 0, first_userptr = num_entries;
 	struct amdgpu_bo_list_entry *array;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
index a130e766cbdbe..529d52a204cf4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
@@ -60,7 +60,7 @@ int amdgpu_bo_create_list_entry_array(struct drm_amdgpu_bo_list_in *in,
 int amdgpu_bo_list_create(struct amdgpu_device *adev,
 				 struct drm_file *filp,
 				 struct drm_amdgpu_bo_list_entry *info,
-				 unsigned num_entries,
+				 size_t num_entries,
 				 struct amdgpu_bo_list **list);
 
 static inline struct amdgpu_bo_list_entry *
-- 
2.33.0



