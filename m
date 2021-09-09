Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972FB405648
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359188AbhIINTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358650AbhIINJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7593E61452;
        Thu,  9 Sep 2021 12:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188856;
        bh=UmH3tyQhlZMb5iouAeSw2MzsrySdnZUzxrI6Fv6GO2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3UkJ2AwKYi8nQG1vrVFzLMsDbhfbAc7Hi0J8d+M3G0cqOB7Ga9s0+1Ehmzm890zb
         vSyWrmkOtAB/gbd6N8CWcnlUsWtuPjksVMrClJqjlA/Grwno+2JMRmEb6sThTUNRfN
         Jrd6l+ByTgwr6gwI4OvflGupGO3Uw0jqOMkYUpaW9E7enbgtnu8fAFTZQXVmKyIwZV
         vfczDA1W2zKzs8PrI5djNtsjzu73yIzXjXUFhNrVNNet92GBL3XIk5Eu9kVXQNtZpU
         vwinyxKyE3UVRzEnw1kYnq4hISKW15Q5Rxi30iEufgiuNd500t45oBEGxY/Vz82tOk
         RMQPTboPqdB7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 32/48] gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()
Date:   Thu,  9 Sep 2021 07:59:59 -0400
Message-Id: <20210909120015.150411-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit a211260c34cfadc6068fece8c9e99e0fe1e2a2b6 ]

The variable val is declared without initialization, and its address is
passed to amdgpu_i2c_get_byte(). In this function, the value of val is
accessed in:
  DRM_DEBUG("i2c 0x%02x 0x%02x read failed\n",
       addr, *val);

Also, when amdgpu_i2c_get_byte() returns, val may remain uninitialized,
but it is accessed in:
  val &= ~amdgpu_connector->router.ddc_mux_control_pin;

To fix this possible uninitialized-variable access, initialize val to 0 in
amdgpu_i2c_router_select_ddc_port().

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
index 91d367399956..a334eb7dbff4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -339,7 +339,7 @@ static void amdgpu_i2c_put_byte(struct amdgpu_i2c_chan *i2c_bus,
 void
 amdgpu_i2c_router_select_ddc_port(const struct amdgpu_connector *amdgpu_connector)
 {
-	u8 val;
+	u8 val = 0;
 
 	if (!amdgpu_connector->router.ddc_valid)
 		return;
-- 
2.30.2

