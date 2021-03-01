Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7842B3286C1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhCAROF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:14:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237544AbhCARIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30BCF64F87;
        Mon,  1 Mar 2021 16:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616883;
        bh=ihkjfv3QUOQ+XYuaYwF02p96VkvpK5bZr/DlSJ0w4Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ip+7d5SylBvQRFYoMBL/MZqa7V32mMl2xB9Luurq91ttChqVRQ3QtoKWO2l1iUwZV
         S1WQWlGZU+xKC3+AANXoYBd5Lg+ZvEo7tKrzJ4MVCPmJC/aUsQt7nJ8uCLQMkfnMTN
         Psan4n9ZQt+QwsYq7eQ+OX2puezrDxV5l88tCQFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/247] drm/amdgpu: Prevent shift wrapping in amdgpu_read_mask()
Date:   Mon,  1 Mar 2021 17:11:58 +0100
Message-Id: <20210301161036.477443445@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c915ef890d5dc79f483e1ca3b3a5b5f1a170690c ]

If the user passes a "level" value which is higher than 31 then that
leads to shift wrapping.  The undefined behavior will lead to a
syzkaller stack dump.

Fixes: 5632708f4452 ("drm/amd/powerplay: add dpm force multiple levels on cz/tonga/fiji/polaris (v2)")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
index e63a253eb4255..cbb969a870f6a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -617,7 +617,7 @@ static ssize_t amdgpu_get_pp_dpm_sclk(struct device *dev,
 static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
 {
 	int ret;
-	long level;
+	unsigned long level;
 	char *sub_str = NULL;
 	char *tmp;
 	char buf_cpy[AMDGPU_MASK_BUF_MAX + 1];
@@ -633,8 +633,8 @@ static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
 	while (tmp[0]) {
 		sub_str = strsep(&tmp, delimiter);
 		if (strlen(sub_str)) {
-			ret = kstrtol(sub_str, 0, &level);
-			if (ret)
+			ret = kstrtoul(sub_str, 0, &level);
+			if (ret || level > 31)
 				return -EINVAL;
 			*mask |= 1 << level;
 		} else
-- 
2.27.0



