Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8D829B89E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368895AbgJ0PmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800333AbgJ0Pfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B73F12225E;
        Tue, 27 Oct 2020 15:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812942;
        bh=8qropFHjUNuvi8RqMClfXfK5Khb0sacbZdTAFFiZXLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpU3zEvIbzCQLBxXJUPfHljgvwuY9GpdqEAEOYcIPw93VWqS+qB+KhfqCkWijIh5P
         zMtkNB9XO3/LMLLLopRwtmjX+jFIuOxvQWX+10siK52VnzFO8bb360UbNg05UUuXox
         EFLXPa9nz6oKnv74/QNBL+aXkyacB0eAkeSNt82c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Ye Bin <yebin10@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 384/757] drm/amdgpu: Fix invalid number of character { in amdgpu_acpi_init
Date:   Tue, 27 Oct 2020 14:50:34 +0100
Message-Id: <20201027135508.563382170@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 9c27bc97aff8bbe62b5b29ebf528291dd85d9c86 ]

Fix follow warning:
Checking drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c...
[drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c:770]: (error) Invalid number
of character '{' when these macros are defined: ''.
Checking drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c: CONFIG_ACPI...
[drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c:770]: (error) Invalid number
of character '{' when these macros are defined: 'CONFIG_ACPI'.
......
Checking drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c: CONFIG_X86...
[drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c:770]: (error) Invalid number
of character '{' when these macros are defined: 'CONFIG_X86'.
Checking drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c: _X86_...
[drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c:770]: (error) Invalid number
of character '{' when these macros are defined: '_X86_'.
Checking drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c: __linux__...
[drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c:770]: (error) Invalid number
of character '{' when these macros are defined: '__linux__'.

Fixes: 97d798b276e9 ("drm/amdgpu: simplify ATIF backlight handling")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 913c8f0513bd3..5b7dc1d1b44c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -806,8 +806,8 @@ int amdgpu_acpi_init(struct amdgpu_device *adev)
 	}
 	adev->atif = atif;
 
-	if (atif->notifications.brightness_change) {
 #if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
+	if (atif->notifications.brightness_change) {
 		if (amdgpu_device_has_dc_support(adev)) {
 #if defined(CONFIG_DRM_AMD_DC)
 			struct amdgpu_display_manager *dm = &adev->dm;
-- 
2.25.1



