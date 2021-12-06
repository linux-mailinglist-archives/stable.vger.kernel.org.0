Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D26E469C47
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350151AbhLFPVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37622 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357615AbhLFPSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:18:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 056296132F;
        Mon,  6 Dec 2021 15:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A4AC341C1;
        Mon,  6 Dec 2021 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803714;
        bh=/U9FxitpadGD+gXB9HlW7Ev7z2e8KTHdVeMPb3pDD9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNVy9HmoMpN2Hy6dFvAmUc90lGjOQfn6DBtlpTsqx/atZVz4Y3kAAdBo2UlGKw0Ji
         Vl4lCFRQAm/94/Dw6XlZpoTYN7daPGMp+pEK2qw+uBP1+BgR0F1rOW2ZZnkPAAk4cu
         lT15vAmo7TNnJriB6TGO0EGB8L8ezvgy8fmj64dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Bernard Zhao <bernard@vivo.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/130] drm/amd/amdgpu: fix potential memleak
Date:   Mon,  6 Dec 2021 15:55:37 +0100
Message-Id: <20211206145600.332924515@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0526dec1d736e..042c85fc528bb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -358,6 +358,7 @@ struct amdgpu_hive_info *amdgpu_get_xgmi_hive(struct amdgpu_device *adev)
 			"%s", "xgmi_hive_info");
 	if (ret) {
 		dev_err(adev->dev, "XGMI: failed initializing kobject for xgmi hive\n");
+		kobject_put(&hive->kobj);
 		kfree(hive);
 		hive = NULL;
 		goto pro_end;
-- 
2.33.0



