Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C997F20E691
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgF2Vsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgF2Sfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4406247DA;
        Mon, 29 Jun 2020 15:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444144;
        bh=brRajcykVy9yW26Z2PG9o1IhYOjKjuI0mu4oVX9mPHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGyNNCvz0ezcM+nOeIZ9k7ON8ZRg+/wFaF16KfSV+xgDEdw+lOLecZfTn60bN6w4c
         CElDJS60/UFhgJcjik4pw63D12sXe3Gg77MuwUQAJQ2XYs+zAPhUWTlPm4upvjGrD6
         70YwwUAie/14cC9g/mFV24IKYsL0sDv5zKx6mQsc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenhui Sheng <Wenhui.Sheng@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 249/265] drm/amdgpu: add fw release for sdma v5_0
Date:   Mon, 29 Jun 2020 11:18:02 -0400
Message-Id: <20200629151818.2493727-250-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenhui Sheng <Wenhui.Sheng@amd.com>

commit edfaf6fa73f15568d4337f208b2333f647c35810 upstream.

sdma fw isn't released when module exit

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Wenhui Sheng <Wenhui.Sheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index d2840c2f62865..1dc57079933ce 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1261,8 +1261,12 @@ static int sdma_v5_0_sw_fini(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	int i;
 
-	for (i = 0; i < adev->sdma.num_instances; i++)
+	for (i = 0; i < adev->sdma.num_instances; i++) {
+		if (adev->sdma.instance[i].fw != NULL)
+			release_firmware(adev->sdma.instance[i].fw);
+
 		amdgpu_ring_fini(&adev->sdma.instance[i].ring);
+	}
 
 	return 0;
 }
-- 
2.25.1

