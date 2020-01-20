Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430B7143169
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 19:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgATSYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 13:24:48 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:46930 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATSYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 13:24:48 -0500
Received: by mail-qv1-f65.google.com with SMTP id u1so198720qvk.13
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 10:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YWUtfkitrmKbo67cSD1/zuV+fr6A5x6JR+2oM8WC5fs=;
        b=CTwmzD/BzauwmlUNlOFDcvnEoJ0ybuPojLOoVZzsinJwJ/1RpeFsVTchsWUZ5Mj8Lj
         5vsuvhibtJ4H/7r7WAu8balq/xpcX7I3yECJYXW5cvVzQSRWjRn+jJEqFDn3lHuMa3Tj
         fqtSAUxuWiNaUxtO8jyc5OwocpceCE3RrLok8yNCCKcuAFjlFicxcXQh5VBKFddY8b/8
         Flf7Ak3v0kJQIQEIxScFREAl2kHf3JGcitIrniXxpBY9piZFrWYtCokZsVYyeib37AGF
         P07zPEAJYseOm9h8PMi1uunmF6Hx7WrlnR/zBOr+7FFIk7Dog7XdHiKevvjYwSvy3dTt
         ZOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YWUtfkitrmKbo67cSD1/zuV+fr6A5x6JR+2oM8WC5fs=;
        b=uC0sx2QriqVoCIg8R6vuKBkE2cGZ2J/I277BTuOP6gULoecv6QGM6O+uFcufpaDVej
         7u0gv/lqeWK0WVojj55as58puraTrBOXxiiVSjIGnxKgkDfrw3HxCecurE810jsYG3B9
         E6UhQ2/kMT6uozco8rBDoNL55+/8xGzaRJ811riGHZIxF6rmyk+ujzs/71jIFbRune7J
         T/QHXXqwnY5eh+pHi2AX3vuIi2qz9/v9RPC95qYXwqH2xjtLZjx0RoxLZC5Sgefbw1AB
         obTzT8Mu8crB9soGBsg1cZJzmujlDBw/DDjxZpWo6rYYk5GGOWb5lLd+Hl9vX6ond3qM
         bt2A==
X-Gm-Message-State: APjAAAVHXNlMMon3doq7NlXNhkrPKx4LVKhpng2e19bZzoYpydBdvZyG
        NxDLDX/B6QnWbo93ixfbhCF4gPDn
X-Google-Smtp-Source: APXvYqx9wVmGTbi2Jyo2YRhtprJDDRbQH0ou4AjLK+4Ntr8Wah9f49//mjM6lujO+TBTto/xzArrCg==
X-Received: by 2002:a0c:904b:: with SMTP id o69mr1037713qvo.218.1579544687166;
        Mon, 20 Jan 2020 10:24:47 -0800 (PST)
Received: from localhost.localdomain ([71.219.59.120])
        by smtp.gmail.com with ESMTPSA id p185sm16281329qkd.126.2020.01.20.10.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 10:24:46 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     changzhu <Changfeng.Zhu@amd.com>, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amdgpu: allow direct upload save restore list for raven2
Date:   Mon, 20 Jan 2020 13:24:39 -0500
Message-Id: <20200120182439.602448-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: changzhu <Changfeng.Zhu@amd.com>

It will cause modprobe atombios stuck problem in raven2 if it doesn't
allow direct upload save restore list from gfx driver.
So it needs to allow direct upload save restore list for raven2
temporarily.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/1013
Signed-off-by: changzhu <Changfeng.Zhu@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit eebc7f4d7ffa09f2a620bd1e2c67ddd579118af9)
Cc: <stable@vger.kernel.org> # 5.4.x
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index ab4a0d8545dc..0125ea7c4103 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2923,7 +2923,9 @@ static void gfx_v9_0_init_pg(struct amdgpu_device *adev)
 	 * And it's needed by gfxoff feature.
 	 */
 	if (adev->gfx.rlc.is_rlc_v2_1) {
-		if (adev->asic_type == CHIP_VEGA12)
+		if (adev->asic_type == CHIP_VEGA12 ||
+		    (adev->asic_type == CHIP_RAVEN &&
+		     adev->rev_id >= 8))
 			gfx_v9_1_init_rlc_save_restore_list(adev);
 		gfx_v9_0_enable_save_restore_machine(adev);
 	}
-- 
2.24.1

