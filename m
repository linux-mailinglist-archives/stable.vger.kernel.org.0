Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0470F3A76F
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbfFIQtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731542AbfFIQtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6032081C;
        Sun,  9 Jun 2019 16:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098979;
        bh=eCRaHGJFhY2nzo79UaoF4vUkbqpYqJCKP6GgncYNDBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzwu8p3WQtFySls2AT+WdYlOrt1y/Nvz46Jryq99oMrSRZW2PBK1E5cSwSXYN07Wz
         ZHJtwPsQv4+pXr9+KQ9NNC1fUjL0PlfPttCpt2ingAC70dBtjtq+W4p9cqLPYD469H
         fIVSjSJCCy2smIYk5S/AcyoisD3jvGDp4Qe9DvDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 44/51] drm/amdgpu: remove ATPX_DGPU_REQ_POWER_FOR_DISPLAYS check when hotplug-in
Date:   Sun,  9 Jun 2019 18:42:25 +0200
Message-Id: <20190609164130.293240190@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Liu <aaron.liu@amd.com>

commit bdb1ccb080dafc1b4224873a5b759ff85a7d1c10 upstream.

In amdgpu_atif_handler, when hotplug event received, remove
ATPX_DGPU_REQ_POWER_FOR_DISPLAYS check. This bit's check will cause missing
system resume.

Signed-off-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -416,8 +416,7 @@ static int amdgpu_atif_handler(struct am
 			}
 		}
 		if (req.pending & ATIF_DGPU_DISPLAY_EVENT) {
-			if ((adev->flags & AMD_IS_PX) &&
-			    amdgpu_atpx_dgpu_req_power_for_displays()) {
+			if (adev->flags & AMD_IS_PX) {
 				pm_runtime_get_sync(adev->ddev->dev);
 				/* Just fire off a uevent and let userspace tell us what to do */
 				drm_helper_hpd_irq_event(adev->ddev);


