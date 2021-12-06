Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C23C469EB6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386696AbhLFPnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357806AbhLFPh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:37:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29DFC08EAE9;
        Mon,  6 Dec 2021 07:23:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D0CCB81125;
        Mon,  6 Dec 2021 15:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAE9C341C5;
        Mon,  6 Dec 2021 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804217;
        bh=cCkMMf905Hpb8flwkJwQ9Jezp64VLSVJQydBbhtNflQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkykrkEdFo0sr8Jy5F9MVVQSFUWwzmx717x95EURv2QQi61GGqXo1S6NLHgtQzZT5
         85rPlPZU5aj1V0Soko0FBb9dRQjqOxVxPm7Myxy14ddSjeoQfAlFjMCHsCjr8iZVNU
         LvzDKD1uAcVvIl2ocOIM2Y5YtDk9MikLcYS74A3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Bernard Zhao <bernard@vivo.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/207] drm/amd/amdgpu: fix potential memleak
Date:   Mon,  6 Dec 2021 15:54:50 +0100
Message-Id: <20211206145611.474746147@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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



