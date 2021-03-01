Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46301328854
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbhCARiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238227AbhCARbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:31:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E710065098;
        Mon,  1 Mar 2021 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617542;
        bh=P49396UpDN3u9Nk5BtJDGrbQo/JfsgHqH1KdBOW8D90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYuc5CKEx4/AM/cv9J8BuLIpNt3r/6nOWeThdV4hxsGy/+13vd0aLMFFcfogDmGY8
         li/7yU5YnfNRwfliq1YFLBk4beCzAYsRb5KtQ3fakeDUKH/1pFSUNdWF3bUQ3aJLyu
         bR1GgNAC6F8SJjMOpxarnOSd/p3DJ9sJjwqPnDE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/340] drm/amdgpu: Prevent shift wrapping in amdgpu_read_mask()
Date:   Mon,  1 Mar 2021 17:10:55 +0100
Message-Id: <20210301161053.800548096@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 3f744e72912f1..bcb7ab5c602d1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -870,7 +870,7 @@ static ssize_t amdgpu_get_pp_dpm_sclk(struct device *dev,
 static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
 {
 	int ret;
-	long level;
+	unsigned long level;
 	char *sub_str = NULL;
 	char *tmp;
 	char buf_cpy[AMDGPU_MASK_BUF_MAX + 1];
@@ -886,8 +886,8 @@ static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
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



