Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA620D9E2
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388154AbgF2Tvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387716AbgF2Tkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2FA7251BA;
        Mon, 29 Jun 2020 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444490;
        bh=jj3Ljte/sgoT3oHrDvoMUysMOGVCiWeb/5cZvyxK/jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWhuJ3m2qVXRRwVDkcuM26gPis+So7L4ZLEqR7a1iXc3mxTeu6zbuqzSlqURFbRAm
         wO4iVjyEcAVFd1ToEqpOOOpwWb8AJnMvhJRjzh0b+FqAZ5fuhUQhdg2nneE5E8Tvd8
         MHM760fuhyQvVFAZh5ItBuzFPPET/LHd1PjZJTgk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 167/178] drm/radeon: fix fb_div check in ni_init_smc_spll_table()
Date:   Mon, 29 Jun 2020 11:25:12 -0400
Message-Id: <20200629152523.2494198-168-sashal@kernel.org>
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

From: Denis Efremov <efremov@linux.com>

commit 35f760b44b1b9cb16a306bdcc7220fbbf78c4789 upstream.

clk_s is checked twice in a row in ni_init_smc_spll_table().
fb_div should be checked instead.

Fixes: 69e0b57a91ad ("drm/radeon/kms: add dpm support for cayman (v5)")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/ni_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index d9e62ca65ab8d..bd2e577c701f2 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -2128,7 +2128,7 @@ static int ni_init_smc_spll_table(struct radeon_device *rdev)
 		if (clk_s & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_SHIFT))
 			ret = -EINVAL;
 
-		if (clk_s & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_SHIFT))
+		if (fb_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_SHIFT))
 			ret = -EINVAL;
 
 		if (clk_v & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKV_SHIFT))
-- 
2.25.1

