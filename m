Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22FF2476B6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404252AbgHQTkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729712AbgHQPZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD2623A03;
        Mon, 17 Aug 2020 15:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677915;
        bh=T0tVjBCCXbNXEeU92uTxmw1N0dDtQvtH7f6NELAnp1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkuf0c3zmzAJy7TYJ61ZE8olcXaBqiC2dgYBuNPwvoHT1YEDZedvkZC9SBCNv4yf/
         uRdFxSUQAF7+NZ9TwvD6RnUhykVrrK3p87Fg41e02K7oKJKhklsXoWRZGVjAbzIfHH
         yCA69Sz/5tk+4W/KWu+vy22Ry4pXetHvJ18CACWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 124/464] drm/amd/powerplay: suppress compile error around BUG_ON
Date:   Mon, 17 Aug 2020 17:11:17 +0200
Message-Id: <20200817143839.751831494@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 75bc07e2403caea9ecac69f766dfb7dc33547594 ]

To suppress the compile error below for "ARCH=arc".
   drivers/gpu/drm/amd/amdgpu/../powerplay/arcturus_ppt.c: In function 'arcturus_fill_eeprom_i2c_req':
>> arch/arc/include/asm/bug.h:22:2: error: implicit declaration of function 'pr_warn'; did you mean 'pci_warn'? [-Werror=implicit-function-declaration]
      22 |  pr_warn("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
         |  ^~~~~~~
   include/asm-generic/bug.h:62:57: note: in expansion of macro 'BUG'
      62 | #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
         |                                                         ^~~
   drivers/gpu/drm/amd/amdgpu/../powerplay/arcturus_ppt.c:2157:2: note: in expansion of macro 'BUG_ON'
    2157 |  BUG_ON(numbytes > MAX_SW_I2C_COMMANDS);

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/arcturus_ppt.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c b/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
index 27c5fc9572b27..e4630a76d7bf5 100644
--- a/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
@@ -2042,8 +2042,6 @@ static void arcturus_fill_eeprom_i2c_req(SwI2cRequest_t  *req, bool write,
 {
 	int i;
 
-	BUG_ON(numbytes > MAX_SW_I2C_COMMANDS);
-
 	req->I2CcontrollerPort = 0;
 	req->I2CSpeed = 2;
 	req->SlaveAddress = address;
@@ -2081,6 +2079,12 @@ static int arcturus_i2c_eeprom_read_data(struct i2c_adapter *control,
 	struct smu_table_context *smu_table = &adev->smu.smu_table;
 	struct smu_table *table = &smu_table->driver_table;
 
+	if (numbytes > MAX_SW_I2C_COMMANDS) {
+		dev_err(adev->dev, "numbytes requested %d is over max allowed %d\n",
+			numbytes, MAX_SW_I2C_COMMANDS);
+		return -EINVAL;
+	}
+
 	memset(&req, 0, sizeof(req));
 	arcturus_fill_eeprom_i2c_req(&req, false, address, numbytes, data);
 
@@ -2117,6 +2121,12 @@ static int arcturus_i2c_eeprom_write_data(struct i2c_adapter *control,
 	SwI2cRequest_t req;
 	struct amdgpu_device *adev = to_amdgpu_device(control);
 
+	if (numbytes > MAX_SW_I2C_COMMANDS) {
+		dev_err(adev->dev, "numbytes requested %d is over max allowed %d\n",
+			numbytes, MAX_SW_I2C_COMMANDS);
+		return -EINVAL;
+	}
+
 	memset(&req, 0, sizeof(req));
 	arcturus_fill_eeprom_i2c_req(&req, true, address, numbytes, data);
 
-- 
2.25.1



