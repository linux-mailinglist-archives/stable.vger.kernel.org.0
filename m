Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C6C15E7C3
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392910AbgBNQza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404671AbgBNQST (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:18:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E33F24692;
        Fri, 14 Feb 2020 16:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697099;
        bh=FcvBkKpzEgcoIU2wYmSoYkgz1dx3PGPVxKSmKX7uaaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOQTgiUAaHAsMep+qdvRdQMLDg6fECNbPgyCRDEe+0hj8pFN33StdoRv+b9+hJgfS
         wpjSVBa6eMMnyroanra2Vu9B7mtZlmU1i7/yN7o8qbYoH6TFt1s72CVsaBe60n6m6B
         /X9p/Gw+g72rMpALLoq5nIINCxoEsrjBryzTHUc8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 049/186] drm/amdgpu: remove always false comparison in 'amdgpu_atombios_i2c_process_i2c_ch'
Date:   Fri, 14 Feb 2020 11:14:58 -0500
Message-Id: <20200214161715.18113-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit 220ac8d1444054ade07ce14498fcda266410f90e ]

Fixes gcc '-Wtype-limits' warning:

drivers/gpu/drm/amd/amdgpu/atombios_i2c.c: In function
‘amdgpu_atombios_i2c_process_i2c_ch’:
drivers/gpu/drm/amd/amdgpu/atombios_i2c.c:79:11: warning: comparison is
always false due to limited range of data type [-Wtype-limits]

'num' is 'u8', so it will never be greater than 'TOM_MAX_HW_I2C_READ',
which is defined as 255. Therefore, the comparison can be removed.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atombios_i2c.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atombios_i2c.c b/drivers/gpu/drm/amd/amdgpu/atombios_i2c.c
index b374653bd6cf3..741bd1e52699b 100644
--- a/drivers/gpu/drm/amd/amdgpu/atombios_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/atombios_i2c.c
@@ -69,11 +69,6 @@ static int amdgpu_atombios_i2c_process_i2c_ch(struct amdgpu_i2c_chan *chan,
 			memcpy(&out, &buf[1], num);
 		args.lpI2CDataOut = cpu_to_le16(out);
 	} else {
-		if (num > ATOM_MAX_HW_I2C_READ) {
-			DRM_ERROR("hw i2c: tried to read too many bytes (%d vs 255)\n", num);
-			r = -EINVAL;
-			goto done;
-		}
 		args.ucRegIndex = 0;
 		args.lpI2CDataOut = 0;
 	}
-- 
2.20.1

