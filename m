Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63C3DD912
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbhHBN47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235365AbhHBNz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E99611C2;
        Mon,  2 Aug 2021 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912435;
        bh=wRvpam9wRRmddnFA/h83MnJHXmly/iKG/iGbSVRRF2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cXFaK57n2FYJP+TWBWMOVDwJzncPDMXN0mrkBq/+W9y2A5qfD0uFCUtFS8bLzBK6
         C3UajVq4UlQfZW8QTJQiJhkGY3Bz+fzKO9LMDc3LxS9WDvDE4gtb249ghF06mZiRIi
         NyU1dbsc3i9oLN4A0OFIryi6EHLFVun7AKTl+gpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vojtech Pavlik <vojtech@ucw.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 24/67] drm/amdgpu: Fix resource leak on probe error path
Date:   Mon,  2 Aug 2021 15:44:47 +0200
Message-Id: <20210802134339.842433681@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit d47255d3f87338164762ac56df1f28d751e27246 upstream.

This reverts commit 4192f7b5768912ceda82be2f83c87ea7181f9980.

It is not true (as stated in the reverted commit changelog) that we never
unmap the BAR on failure; it actually does happen properly on
amdgpu_driver_load_kms() -> amdgpu_driver_unload_kms() ->
amdgpu_device_fini() error path.

What's worse, this commit actually completely breaks resource freeing on
probe failure (like e.g. failure to load microcode), as
amdgpu_driver_unload_kms() notices adev->rmmio being NULL and bails too
early, leaving all the resources that'd normally be freed in
amdgpu_acpi_fini() and amdgpu_device_fini() still hanging around, leading
to all sorts of oopses when someone tries to, for example, access the
sysfs and procfs resources which are still around while the driver is
gone.

Fixes: 4192f7b57689 ("drm/amdgpu: unmap register bar on device init failure")
Reported-by: Vojtech Pavlik <vojtech@ucw.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3322,13 +3322,13 @@ int amdgpu_device_init(struct amdgpu_dev
 	r = amdgpu_device_get_job_timeout_settings(adev);
 	if (r) {
 		dev_err(adev->dev, "invalid lockup_timeout parameter syntax\n");
-		goto failed_unmap;
+		return r;
 	}
 
 	/* early init functions */
 	r = amdgpu_device_ip_early_init(adev);
 	if (r)
-		goto failed_unmap;
+		return r;
 
 	/* doorbell bar mapping and doorbell index init*/
 	amdgpu_device_doorbell_init(adev);
@@ -3532,10 +3532,6 @@ failed:
 	if (boco)
 		vga_switcheroo_fini_domain_pm_ops(adev->dev);
 
-failed_unmap:
-	iounmap(adev->rmmio);
-	adev->rmmio = NULL;
-
 	return r;
 }
 


