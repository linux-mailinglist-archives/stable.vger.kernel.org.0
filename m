Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229D745E515
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358276AbhKZCjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:39:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358001AbhKZChW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:37:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F21AD611CE;
        Fri, 26 Nov 2021 02:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893975;
        bh=cCkMMf905Hpb8flwkJwQ9Jezp64VLSVJQydBbhtNflQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGZEjTlt4/dv2ENk2RSBtyfrQOJF8CrBkzaQd1OWe0idmFXsSwA8ImEIv9LQQqFJ7
         fpro69K1c2pTkfspY5RWdFwxhFy8elbgeDd8+YQLiQ5o7uHm2584coDFrVbpnnN9fK
         KzuyQel1XaNJugrPqkcyDOlHLO/pWKc/NfNjZrkyd2F2rMILWxUXhFwhep2K1VUiDl
         kuQlgSFQ+vrYl5yYJ7iBcYFnF55o13P/aS6z9IbkabRkeNp4TSoq324RiFQN+1Bjfs
         bfM8uF728fCBbhZrpx0JJQYsja7FlxTgd1bzDST9swrtR0n++N0liKX+aiHTPhqDAi
         OloivjsFetPOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, john.clements@amd.com, jonathan.kim@amd.com,
        tiantao6@hisilicon.com, shaoyun.liu@amd.com, kevin1.wang@amd.com,
        tao.zhou1@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 26/39] drm/amd/amdgpu: fix potential memleak
Date:   Thu, 25 Nov 2021 21:31:43 -0500
Message-Id: <20211126023156.441292-26-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

[ Upstream commit 27dfaedc0d321b4ea4e10c53e4679d6911ab17aa ]

In function amdgpu_get_xgmi_hive, when kobject_init_and_add failed
There is a potential memleak if not call kobject_put.

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Bernard Zhao <bernard@vivo.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index 978ac927ac11d..a799e0b1ff736 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -386,6 +386,7 @@ struct amdgpu_hive_info *amdgpu_get_xgmi_hive(struct amdgpu_device *adev)
 			"%s", "xgmi_hive_info");
 	if (ret) {
 		dev_err(adev->dev, "XGMI: failed initializing kobject for xgmi hive\n");
+		kobject_put(&hive->kobj);
 		kfree(hive);
 		hive = NULL;
 		goto pro_end;
-- 
2.33.0

