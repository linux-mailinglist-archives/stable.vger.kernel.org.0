Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E492A5939
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgKCWF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730073AbgKCUmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4A3223AB;
        Tue,  3 Nov 2020 20:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436128;
        bh=Vz7mWas5l7Cj4YtdwXe/OVrmAq1W+gMt/ahKzluJz0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoDr1U7n1ioE2rz9b1Q8iYurGFHNxVuAcqp4KR9UhU7j5velAlw8l1/pzjcChAg25
         7mjpILZOZCmHuWVsAVpFIPrZGNkAsKqU/95vtZj1tbO+czmQkS/CooTEjI669vxW4p
         bxeOTyTSvE8hhBIuHlmreRLw9Od8PvLpfDohA66E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luben Tuikov <luben.tuikov@amd.com>,
        Slava Abramov <slava.abramov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 116/391] drm/amdgpu: No sysfs, not an error condition
Date:   Tue,  3 Nov 2020 21:32:47 +0100
Message-Id: <20201103203354.649857318@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 5aea5327ea2ddf544cbeff096f45fc2319b0714e ]

Not being able to create amdgpu sysfs attributes
is not a fatal error warranting not to continue
to try to bring up the display. Thus, if we get
an error trying to create amdgpu sysfs attrs,
report it and continue on to try to bring up
a display.

Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Acked-by: Slava Abramov <slava.abramov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d0b8d0d341af5..2576c299958c5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3316,10 +3316,8 @@ fence_driver_init:
 		flush_delayed_work(&adev->delayed_init_work);
 
 	r = sysfs_create_files(&adev->dev->kobj, amdgpu_dev_attributes);
-	if (r) {
+	if (r)
 		dev_err(adev->dev, "Could not create amdgpu device attr\n");
-		return r;
-	}
 
 	if (IS_ENABLED(CONFIG_PERF_EVENTS))
 		r = amdgpu_pmu_init(adev);
-- 
2.27.0



