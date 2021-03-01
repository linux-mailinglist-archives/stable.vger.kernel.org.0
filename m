Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1345A328C67
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbhCASvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:51:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237099AbhCASpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:45:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D738164E12;
        Mon,  1 Mar 2021 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618773;
        bh=6l8EQL6pTGEDKoOy63AMW/PtpowgN3J+JPAKAnjR4c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcgES/LA7VqafSne4VR1jnJ3Qj6/6RLyOhu/01U+T7pNvUgXnm1MC5+6y4z5Wgej8
         zx5b6o23XtGxy+sl2Iv+0veoQesENu4IMkfuhOrC0PgzWUWlkZtse97D81bo7x9hA0
         4g3EpB/oLiltSvNtucNBGU1teQdvixFK5OAA/JmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/663] drm/amdgpu: Prevent shift wrapping in amdgpu_read_mask()
Date:   Mon,  1 Mar 2021 17:07:40 +0100
Message-Id: <20210301161152.278660107@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 529816637c731..9f383b9041d28 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1070,7 +1070,7 @@ static ssize_t amdgpu_get_pp_dpm_sclk(struct device *dev,
 static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
 {
 	int ret;
-	long level;
+	unsigned long level;
 	char *sub_str = NULL;
 	char *tmp;
 	char buf_cpy[AMDGPU_MASK_BUF_MAX + 1];
@@ -1086,8 +1086,8 @@ static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
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



