Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A513DD96E
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhHBOAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236054AbhHBN6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:58:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65D7D61057;
        Mon,  2 Aug 2021 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912515;
        bh=y/AA8DFSDyJWtCM/vYw+W485KR8wyONVOF3AFcNnqEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDw+0BlOkaT0b2esiOn6UoZFuegdrbvCNNm3qDsDIc0YFJd/CBmTdOa42rH3BvIw6
         YI2wUxuBaQ0BeYrFIP6b6HjVOLd2yn5f1ZX2F271166SsssTwKtYK3LIL/ndF+1MUy
         ejxvw1JnK93qEOqdUkLKiqCXkPe7XQYXcBQzBVlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vojtech Pavlik <vojtech@ucw.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 028/104] drm/amdgpu: Fix resource leak on probe error path
Date:   Mon,  2 Aug 2021 15:44:25 +0200
Message-Id: <20210802134344.947755986@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
@@ -3412,13 +3412,13 @@ int amdgpu_device_init(struct amdgpu_dev
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
@@ -3644,10 +3644,6 @@ release_ras_con:
 failed:
 	amdgpu_vf_error_trans_all(adev);
 
-failed_unmap:
-	iounmap(adev->rmmio);
-	adev->rmmio = NULL;
-
 	return r;
 }
 


