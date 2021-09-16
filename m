Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2478540E04E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240842AbhIPQUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241223AbhIPQTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:19:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D518C6138E;
        Thu, 16 Sep 2021 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808804;
        bh=rPW4weNS1rJgczyBsbBFdNp7YgrJ3bWcPLZVVztza48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIohiz8bjMbkxB08mugHYazPQ2EORTuyISPnIi9898HFrVbvIm8bYOg92B0r8Gtke
         okcK1iE6cPmUfzoCWh5kwMrUUrYkVW5d4F6HQb5vc+aag6sUBrmIUB7fCjfUkDcAHD
         wOX5U1vAwtnkX5CCKAN9iZj/QN9suiFBNjLmNaiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/306] gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()
Date:   Thu, 16 Sep 2021 17:59:16 +0200
Message-Id: <20210916155801.237742815@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 47cad23a6b9e..b91d3d29b410 100644
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



