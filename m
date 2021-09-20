Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF95C411AC7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244503AbhITQwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244500AbhITQu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B96F16127B;
        Mon, 20 Sep 2021 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156539;
        bh=7bFbsGkqnveGerGt8Uvc6MaWqVEX3Q4HJMbFzdXQtGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVsgpT4r/BDA/ZBw1hxlkAd4xYi8/A6qrYwVXy20JdqlFZvSwuqOJNL+bswRijttE
         xz1tez5m1KbTqB3l381NULl6BoDXFM/JsyGr+zDbBLpwZJY73fNyTT9DADOfiMB1f+
         piKdpaiO9rHDNikanJIzhPJi16jexnBx2qylSWG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 106/133] gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()
Date:   Mon, 20 Sep 2021 18:43:04 +0200
Message-Id: <20210920163916.094605655@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 31a676376d73..3490d300bed2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -340,7 +340,7 @@ static void amdgpu_i2c_put_byte(struct amdgpu_i2c_chan *i2c_bus,
 void
 amdgpu_i2c_router_select_ddc_port(struct amdgpu_connector *amdgpu_connector)
 {
-	u8 val;
+	u8 val = 0;
 
 	if (!amdgpu_connector->router.ddc_valid)
 		return;
-- 
2.30.2



