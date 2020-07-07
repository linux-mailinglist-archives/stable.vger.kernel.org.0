Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885BC21724E
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgGGPb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbgGGPXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F1920663;
        Tue,  7 Jul 2020 15:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135382;
        bh=NBfZR347CX3NjXV8lpgwwhncpWpFn2IdfEY6lIHKI78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXu0ue5batlgQsKVVoyBTl0bFHmF9bRTiUNLF22wyvT11onk77K5W3At5ZdK2hAKF
         0lIxqYN7dC7OVDySqj5i485rAAqGG0YAHklHhwZpa8DGdE1eQJ+6Q9w+1s9pJEUK3Q
         2c44mxIQiuAl9qTwfrWQ+SVNAdygufZ8I2jdGLv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        John Clements <John.Clements@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 019/112] drm/amdgpu: fix kernel page fault issue by ras recovery on sGPU
Date:   Tue,  7 Jul 2020 17:16:24 +0200
Message-Id: <20200707145801.910328468@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 12c17b9d62663c14a5343d6742682b3e67280754 ]

When running ras uncorrectable error injection and triggering GPU
reset on sGPU, below issue is observed. It's caused by the list
uninitialized when accessing.

[   80.047227] BUG: unable to handle page fault for address: ffffffffc0f4f750
[   80.047300] #PF: supervisor write access in kernel mode
[   80.047351] #PF: error_code(0x0003) - permissions violation
[   80.047404] PGD 12c20e067 P4D 12c20e067 PUD 12c210067 PMD 41c4ee067 PTE 404316061
[   80.047477] Oops: 0003 [#1] SMP PTI
[   80.047516] CPU: 7 PID: 377 Comm: kworker/7:2 Tainted: G           OE     5.4.0-rc7-guchchen #1
[   80.047594] Hardware name: System manufacturer System Product Name/TUF Z370-PLUS GAMING II, BIOS 0411 09/21/2018
[   80.047888] Workqueue: events amdgpu_ras_do_recovery [amdgpu]

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: John Clements <John.Clements@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index b0aa4e1ed4df7..cd18596b47d33 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1444,9 +1444,10 @@ static void amdgpu_ras_do_recovery(struct work_struct *work)
 	struct amdgpu_hive_info *hive = amdgpu_get_xgmi_hive(adev, false);
 
 	/* Build list of devices to query RAS related errors */
-	if  (hive && adev->gmc.xgmi.num_physical_nodes > 1) {
+	if  (hive && adev->gmc.xgmi.num_physical_nodes > 1)
 		device_list_handle = &hive->device_list;
-	} else {
+	else {
+		INIT_LIST_HEAD(&device_list);
 		list_add_tail(&adev->gmc.xgmi.head, &device_list);
 		device_list_handle = &device_list;
 	}
-- 
2.25.1



