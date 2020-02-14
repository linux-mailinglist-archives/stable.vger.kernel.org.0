Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2505015F3CB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgBNSPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730919AbgBNPwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0718024681;
        Fri, 14 Feb 2020 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695519;
        bh=6Kpp5XQKnfldJow9/7QSpRHsX4NN+KQgo4uwuk5uwe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbaEFA2qEYCv7Eox3ztUO+MXRkFKw+NU5X4TQWYrJgnx8MJVOZDtbLJUy+18udMMV
         kC7WIXdIXD8pOQ9/vLrKsX3I0ry+5SjcT4E6y1ySxoo1iRedIijC6kKDqdEIjDrmiy
         p7LnWoDhRCSXQQ05AkizV9Bie2eYHZQEAH/92NUg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 142/542] drm/amdgpu: remove always false comparison in 'amdgpu_atombios_i2c_process_i2c_ch'
Date:   Fri, 14 Feb 2020 10:42:14 -0500
Message-Id: <20200214154854.6746-142-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index 980c363b1a0ae..b4cc7c55fa16f 100644
--- a/drivers/gpu/drm/amd/amdgpu/atombios_i2c.c
+++ b/drivers/gpu/drm/amd/amdgpu/atombios_i2c.c
@@ -76,11 +76,6 @@ static int amdgpu_atombios_i2c_process_i2c_ch(struct amdgpu_i2c_chan *chan,
 		}
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

