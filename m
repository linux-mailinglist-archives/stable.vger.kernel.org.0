Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8004AA937
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 14:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344849AbiBENzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 08:55:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiBENzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 08:55:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33735B80BD1
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 13:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F129C340E8;
        Sat,  5 Feb 2022 13:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644069315;
        bh=EJlEexKNj7h8VXsWbGEM/nIAX0ce8cTmnCbAohA19xA=;
        h=Subject:To:Cc:From:Date:From;
        b=CU+M9i4R49lZ+2x7eH6dPfRcon55v0FwlmidxMBBuz11tTYtqAxsfm9aWj+acHDZC
         BSNNu+W6871voyKagr/DnvZIhErxL1t8ITjkmJIIpneX6/fn8gJdBnWHxFEWazwZ8t
         rSfc9lhJY4DdusxTNfOXpYAp6PY8ptPIFP+/Ac2s=
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix a potential GPU hang on cyan skillfish" failed to apply to 5.10-stable tree
To:     Lang.Yu@amd.com, alexander.deucher@amd.com, lijo.lazar@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 14:55:11 +0100
Message-ID: <164406931156163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bca52455a3c07922ee976714b00563a13a29ab15 Mon Sep 17 00:00:00 2001
From: Lang Yu <Lang.Yu@amd.com>
Date: Fri, 28 Jan 2022 18:24:53 +0800
Subject: [PATCH] drm/amdgpu: fix a potential GPU hang on cyan skillfish

We observed a GPU hang when querying GMC CG state(i.e.,
cat amdgpu_pm_info) on cyan skillfish. Acctually, cyan
skillfish doesn't support any CG features.

Just prevent it from accessing GMC CG registers.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index 38bb42727715..a2f8ed0e6a64 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -1140,6 +1140,9 @@ static void gmc_v10_0_get_clockgating_state(void *handle, u32 *flags)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(10, 1, 3))
+		return;
+
 	adev->mmhub.funcs->get_clockgating(adev, flags);
 
 	if (adev->ip_versions[ATHUB_HWIP][0] >= IP_VERSION(2, 1, 0))

