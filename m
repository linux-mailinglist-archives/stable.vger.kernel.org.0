Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3070E24109A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgHJTba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728820AbgHJTKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:10:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF04322B47;
        Mon, 10 Aug 2020 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086605;
        bh=T0tVjBCCXbNXEeU92uTxmw1N0dDtQvtH7f6NELAnp1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmercCbQgD1u+sH56W6H+MuOxptXryH2jPIRg3CnxZXjPargev4FA4c8Nhfu+bRIS
         JX3/nKwJ2S52n5GvdlS6oaonntGRt01oCzb/YDiJPtA0pI6cCWXCzGygBmb4ucv+ja
         7RNmSeJuvhr3ORfitahVuvbSnrqOqZgRKsazLQhc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 48/64] drm/amd/powerplay: suppress compile error around BUG_ON
Date:   Mon, 10 Aug 2020 15:08:43 -0400
Message-Id: <20200810190859.3793319-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

