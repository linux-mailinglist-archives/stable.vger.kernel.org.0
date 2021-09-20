Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32164411E20
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347932AbhITR1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349935AbhITRZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 634926134F;
        Mon, 20 Sep 2021 17:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157341;
        bh=0af7XYpiDaqKh3arO7Wo+2DKVh53HZlCjD+rRxGqUBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/gEXxG/x2r9/G/CtMsdcZxHnu5mdSIBOzXsnc06odqsGzbQ6fwS6ZUkj0g2JpZrQ
         7OI+t2JBRZPiFTdctia/Oesl1ZgL2t5PNHuY2/IlFp/wZ7gXC4pFlT8EZjSSf8gVo5
         KJlcIupysZdQvdNXSt3hU6lP+jRcYOmZk5Mq9rkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 164/217] gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()
Date:   Mon, 20 Sep 2021 18:43:05 +0200
Message-Id: <20210920163930.201337027@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index f2739995c335..199eccee0b0b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c
@@ -338,7 +338,7 @@ static void amdgpu_i2c_put_byte(struct amdgpu_i2c_chan *i2c_bus,
 void
 amdgpu_i2c_router_select_ddc_port(const struct amdgpu_connector *amdgpu_connector)
 {
-	u8 val;
+	u8 val = 0;
 
 	if (!amdgpu_connector->router.ddc_valid)
 		return;
-- 
2.30.2



