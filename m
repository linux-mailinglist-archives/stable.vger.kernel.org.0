Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE078246B1B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgHQPsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730860AbgHQPsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:48:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A780622BEF;
        Mon, 17 Aug 2020 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679319;
        bh=TgO8yez27Pv9eKX7UwZMZBzRs+WyT8PAfWOJG//8w00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tc51xxuGh1rC98Gu9F7l8z0K/5EfMiiU6aG/0l2i6l7whbUoltheEhKvPyCuQOrS5
         0/H06MWWBnSWcbpLC5G4szhMmNeuBm3TH9Z3t/wgl2OuqeJ/XK8cVS1KldjoUnN53b
         cgtSBUX7DgkvmpLENaa/mTOl0verStv4rq/rGHgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 171/393] drm/radeon: fix array out-of-bounds read and write issues
Date:   Mon, 17 Aug 2020 17:13:41 +0200
Message-Id: <20200817143827.916491042@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
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
index 30b5a59353c52..ddc9c034ff9e0 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4365,7 +4365,7 @@ static int ci_set_mc_special_registers(struct radeon_device *rdev,
 					table->mc_reg_table_entry[k].mc_data[j] |= 0x100;
 			}
 			j++;
-			if (j > SMU7_DISCRETE_MC_REGISTER_ARRAY_SIZE)
+			if (j >= SMU7_DISCRETE_MC_REGISTER_ARRAY_SIZE)
 				return -EINVAL;
 
 			if (!pi->mem_gddr5) {
-- 
2.25.1



