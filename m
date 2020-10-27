Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6200529B892
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368830AbgJ0Plt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800302AbgJ0Pfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D773222264;
        Tue, 27 Oct 2020 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812939;
        bh=77ptOLX3KQeh/RP+VjXPKJB9yWx9VC9Ttjn6ShYvepg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtcRPSif1vk18PtzcyCG/DANeZIr1l3DAOjSIRWaqMoTafdLu8KKe75qdIsqvt78M
         mshEhj+sDNrYAF2FYxiasK9YiTd5WzNEyhGURLVMfvh5HCrhZyFTKyC7hxk1N/I3Sb
         UwR2KqLMGB2wzEbV89dsUqlqy6SjFW2yKdiafoTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Christian Hewitt <christianshewitt@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 383/757] drm/panfrost: increase readl_relaxed_poll_timeout values
Date:   Tue, 27 Oct 2020 14:50:33 +0100
Message-Id: <20201027135508.518371190@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit c2df75ad2a9f205820e4bc0db936d3d9af3da1ae ]

Amlogic SoC devices report the following errors frequently causing excessive
dmesg log spam and early log rotataion, although the errors appear to be
harmless as everything works fine:

[    7.202702] panfrost ffe40000.gpu: error powering up gpu L2
[    7.203760] panfrost ffe40000.gpu: error powering up gpu shader

ARM staff have advised increasing the timeout values to eliminate the errors
in most normal scenarios, and testing with several different G31/G52 devices
shows 20000 to be a reliable value.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Suggested-by: Steven Price <steven.price@arm.com>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201008141738.13560-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index 689b92893e0e1..dfe4c9151eaf2 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -309,13 +309,13 @@ void panfrost_gpu_power_on(struct panfrost_device *pfdev)
 	/* Just turn on everything for now */
 	gpu_write(pfdev, L2_PWRON_LO, pfdev->features.l2_present);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + L2_READY_LO,
-		val, val == pfdev->features.l2_present, 100, 1000);
+		val, val == pfdev->features.l2_present, 100, 20000);
 	if (ret)
 		dev_err(pfdev->dev, "error powering up gpu L2");
 
 	gpu_write(pfdev, SHADER_PWRON_LO, pfdev->features.shader_present);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + SHADER_READY_LO,
-		val, val == pfdev->features.shader_present, 100, 1000);
+		val, val == pfdev->features.shader_present, 100, 20000);
 	if (ret)
 		dev_err(pfdev->dev, "error powering up gpu shader");
 
-- 
2.25.1



