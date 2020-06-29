Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E93A20DA09
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgF2TxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387686AbgF2Tk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4909251BB;
        Mon, 29 Jun 2020 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444491;
        bh=2QGbqlj29PbLRqTPspr6W19awiuDaSEDafDJQiGb6l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJ0bHke7A8LWGiaFagGECEWBWw9/bbLGwD2cIDT/SriobjTj34UHvuRyBk/fCxqNh
         7cq6Win5oyG29mY6IyPJarBJaFTTlN73JtoNGaMTdPAhRx2MuAxJV0rMk6+IV0xTh4
         PUi4J1mp3IFO7qYbtVqiCBurO8Vqiy/61fuXZ2Mw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenhui Sheng <Wenhui.Sheng@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 168/178] drm/amdgpu: add fw release for sdma v5_0
Date:   Mon, 29 Jun 2020 11:25:13 -0400
Message-Id: <20200629152523.2494198-169-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
index bd715012185c6..23fc16dc92b4d 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1273,8 +1273,12 @@ static int sdma_v5_0_sw_fini(void *handle)
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

