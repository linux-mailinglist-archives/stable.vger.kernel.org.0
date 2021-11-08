Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9717E44A045
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhKIBCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241498AbhKIBCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:02:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D4C461353;
        Tue,  9 Nov 2021 00:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419599;
        bh=UENeAA502HIHNyO7CyFRjrTKbnGmtxfBOjhgp7HsDCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNTB/b7b9ta4ueNp5+q5kFJBViKu7PiWTp61gZkdwjNWZSnRJ1fwv8DenJwXxZvIQ
         gaBqw+cVc51VV/ohXToGzk0n4naHAcHzkbKsi/3RoWudb35L+xS3DzGp0R82a36+ri
         kIjIR3RBgf/DMtWaiWSNK0qrUT3HXhKyONHmLHCfUKeL7wrpkLN7J+V2juumyTSORQ
         PAM0Q5zj0oLs+3/ZSmtlvSmQEJ91MEvXhma6Qy5A2gnuX1tTb8QJKk8c0PJTYIKpYU
         JuYBWdXN3h0yR8juVvq/IfMOs/0+6MdIdVeNxX3zNTAQO3ovuWwwHFYlF4qd2ZzVt0
         Fbzlzxwy/HxoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        evan.quan@amd.com, Hawking.Zhang@amd.com,
        andrey.grodzovsky@amd.com, shaoyun.liu@amd.com,
        Jack.Zhang1@amd.com, lijo.lazar@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 011/146] drm/amdgpu: move iommu_resume before ip init/resume
Date:   Mon,  8 Nov 2021 12:42:38 -0500
Message-Id: <20211108174453.1187052-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

[ Upstream commit 9cec53c18a3170c7e5673c414da56aeecee94832 ]

Separate iommu_resume from kfd_resume, and move it before
other amdgpu ip init/resume.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211277
Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index af9bdf16eefd4..f5ce8bcb313e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2394,6 +2394,10 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (r)
 		goto init_failed;
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
-- 
2.33.0

