Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775A115EE28
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389557AbgBNRiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389979AbgBNQEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 433E0217F4;
        Fri, 14 Feb 2020 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696279;
        bh=od+SI3t3l/h/t9vQefa9qz4b6qpFO7CWkN6xczo4vyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOFttAOsO3TdhF0RPZTWSkyfdUzvybeefadJMlAW0zmM3RszCmgnPvQEQ8TeL+ZJb
         73xKxR3cL9zbhbqZ2fiaIZaH4ltMoXxoyZLaiPvrL7+CysgcRY5Y2bd7vQqsHg36U2
         XpPSKG1k+u8Relvtymk+gcUVkRxqdhqHGjG4jHJU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 128/459] drm/amdgpu: remove set but not used variable 'count'
Date:   Fri, 14 Feb 2020 10:56:18 -0500
Message-Id: <20200214160149.11681-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit a1bd079fca6219e18bb0892f0a7228a76dd6292c ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/amdkfd/kfd_device.c: In function
‘kgd2kfd_post_reset’:
drivers/gpu/drm/amd/amdkfd/kfd_device.c:745:11: warning:
variable ‘count’ set but not used [-Wunused-but-set-variable]

'count' is never used, so can be removed. Thus 'atomic_dec_return'
can be replaced as 'atomic_dec'

Fixes: e42051d2133b ("drm/amdkfd: Implement GPU reset handlers in KFD")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 0dc1084b5e829..2e744fa3adb6a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -766,7 +766,7 @@ int kgd2kfd_pre_reset(struct kfd_dev *kfd)
 
 int kgd2kfd_post_reset(struct kfd_dev *kfd)
 {
-	int ret, count;
+	int ret;
 
 	if (!kfd->init_complete)
 		return 0;
@@ -776,7 +776,7 @@ int kgd2kfd_post_reset(struct kfd_dev *kfd)
 	ret = kfd_resume(kfd);
 	if (ret)
 		return ret;
-	count = atomic_dec_return(&kfd_locked);
+	atomic_dec(&kfd_locked);
 
 	atomic_set(&kfd->sram_ecc_flag, 0);
 
-- 
2.20.1

