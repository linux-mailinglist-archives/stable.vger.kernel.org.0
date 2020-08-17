Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F2324767C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732442AbgHQTiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729411AbgHQP1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:27:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D08238E6;
        Mon, 17 Aug 2020 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678030;
        bh=E4lK+dqFUzpw7gqJd5bSG/HC6k97NF3vbobVxr/JN90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oDnuHAuucrPbLkj6kxvJ3mp7WbkJbXAaCJ1VX4gqauUwlahT2GbgP1Ct1Jy2S6zp
         llIyFxwPyeQwx+qR8Au22zdVCd/M+R7X8uju25fD/dT8lJb0Ig+7E3yKcXOboB59PP
         3SdZICkJ9Kb0CrGmedD71fSDeherPzV+MfPxRAkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 195/464] drm/radeon: fix array out-of-bounds read and write issues
Date:   Mon, 17 Aug 2020 17:12:28 +0200
Message-Id: <20200817143843.162887170@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 7ee78aff9de13d5dccba133f4a0de5367194b243 ]

There is an off-by-one bounds check on the index into arrays
table->mc_reg_address and table->mc_reg_table_entry[k].mc_data[j] that
can lead to reads and writes outside of arrays. Fix the bound checking
off-by-one error.

Addresses-Coverity: ("Out-of-bounds read/write")
Fixes: cc8dbbb4f62a ("drm/radeon: add dpm support for CI dGPUs (v2)")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index f434efdeca44d..ba20c6f037198 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4351,7 +4351,7 @@ static int ci_set_mc_special_registers(struct radeon_device *rdev,
 					table->mc_reg_table_entry[k].mc_data[j] |= 0x100;
 			}
 			j++;
-			if (j > SMU7_DISCRETE_MC_REGISTER_ARRAY_SIZE)
+			if (j >= SMU7_DISCRETE_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;
 
 			if (!pi->mem_gddr5) {
-- 
2.25.1



