Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFFB2C9B81
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbgLAJJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389371AbgLAJJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:09:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1079B20656;
        Tue,  1 Dec 2020 09:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813727;
        bh=WC8LMLgXIAprLJz4JRRJm5TZQF2svPgBg6+PvfDxZqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+MwggBjGSdAj4HUhMyrkePMOqSxKBIGTecWI2d2POcvniQ6z/bCcdRA8KUDGpLXd
         kxS3znl3643Xk4r4na1Bf+W39MO8k6gEaYN0Q1Z5BZfXFt710cCavnNZOMl3gW1yTq
         BpvSn8a/21N4dJeAB+4njSXYJhZc5lgrtaaa45zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Subject: [PATCH 5.9 038/152] drm/amd/display: Avoid HDCP initialization in devices without output
Date:   Tue,  1 Dec 2020 09:52:33 +0100
Message-Id: <20201201084716.854050941@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit d661155bfca329851a27bb5120fab027db43bd23 upstream.

The HDCP feature requires at least one connector attached to the device;
however, some GPUs do not have a physical output, making the HDCP
initialization irrelevant. This patch disables HDCP initialization when
the graphic card does not have output.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -960,7 +960,7 @@ static int amdgpu_dm_init(struct amdgpu_
 	amdgpu_dm_init_color_mod();
 
 #ifdef CONFIG_DRM_AMD_DC_HDCP
-	if (adev->asic_type >= CHIP_RAVEN) {
+	if (adev->dm.dc->caps.max_links > 0 && adev->asic_type >= CHIP_RAVEN) {
 		adev->dm.hdcp_workqueue = hdcp_create_workqueue(adev, &init_params.cp_psp, adev->dm.dc);
 
 		if (!adev->dm.hdcp_workqueue)


