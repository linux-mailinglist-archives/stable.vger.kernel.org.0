Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332E1240E4E
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgHJTMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729562AbgHJTMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:12:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 381B222BED;
        Mon, 10 Aug 2020 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086753;
        bh=C7FuPpEvit4W3eOn4nPCY2We+IRa/QZOzXOY9OqqX4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g83ghpaAwn68DeWOgfQfWeNZgSs3Pxdbf/XMzF//AeQkSCmeEE4k8WxcW8n0npplp
         c6JN0FgYeM5G97V5IlKEuba6A9JO9NpXtK+ESZJfn/6Yh7w/PEd3X+BbYm8wj8AWh5
         oB+R+ahGG1OP1c24UDgXDYVbitiq98J1ZrevnrmI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>, kernel test robot <lkp@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 28/45] drm/amd/powerplay: fix compile error with ARCH=arc
Date:   Mon, 10 Aug 2020 15:11:36 -0400
Message-Id: <20200810191153.3794446-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191153.3794446-1-sashal@kernel.org>
References: <20200810191153.3794446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 9822ba2ead1baa3de4860ad9472f652c4cc78c9c ]

Fix the compile error below:
drivers/gpu/drm/amd/amdgpu/../powerplay/smu_v11_0.c: In function 'smu_v11_0_init_microcode':
>> arch/arc/include/asm/bug.h:22:2: error: implicit declaration of function 'pr_warn'; did you mean 'pci_warn'? [-Werror=implicit-function-declaration]
      22 |  pr_warn("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
         |  ^~~~~~~
drivers/gpu/drm/amd/amdgpu/../powerplay/smu_v11_0.c:176:3: note: in expansion of macro 'BUG'
     176 |   BUG();

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
index 0922d9cd858a0..c4d8c52c6b9ca 100644
--- a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
@@ -171,7 +171,8 @@ static int smu_v11_0_init_microcode(struct smu_context *smu)
 		chip_name = "navi12";
 		break;
 	default:
-		BUG();
+		dev_err(adev->dev, "Unsupported ASIC type %d\n", adev->asic_type);
+		return -EINVAL;
 	}
 
 	snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_smc.bin", chip_name);
-- 
2.25.1

