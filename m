Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1007499B1F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574632AbiAXVuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48590 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377411AbiAXVh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27F16B81249;
        Mon, 24 Jan 2022 21:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BDAC340E7;
        Mon, 24 Jan 2022 21:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060243;
        bh=EGoeGKQZGN4rz6badnfdmxmFtuNPyW71vKWzKsfoxtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OppixS0rpSNcq4UJuvM7PceDP7D+1db425qJU8vErx4cwRnN17wmjbHWAJP3yJEHQ
         46rIxmXFaeemUQ+hp6t3h+t3isbGohsVwuTvztIARO9HZTQGk+mjiA/9S+jw7dDSve
         L9LbRmvGoVq8SuqF6RBys8eXopcRvl9/i453Bu8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Fink <lukas.fink1@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 0868/1039] drm/amdgpu: Fix rejecting Tahiti GPUs
Date:   Mon, 24 Jan 2022 19:44:17 +0100
Message-Id: <20220124184154.481629804@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Fink <lukas.fink1@gmail.com>

commit 3993a799fc971bc9b918bd969aa55864447b5dde upstream.

eb4fd29afd4a ("drm/amdgpu: bind to any 0x1002 PCI diplay class device") added
generic bindings to amdgpu so that that it binds to all display class devices
with VID 0x1002 and then rejects those in amdgpu_pci_probe.

Unfortunately it reuses a driver_data value of 0 to detect those new bindings,
which is already used to denote CHIP_TAHITI ASICs.

The driver_data value given to those new bindings was changed in
dd0761fd24ea1 ("drm/amdgpu: set CHIP_IP_DISCOVERY as the asic type by default")
to CHIP_IP_DISCOVERY (=36), but it seems that the check in amdgpu_pci_probe
was forgotten to be changed. Therefore, it still rejects Tahiti GPUs.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1860
Fixes: eb4fd29afd4a ("drm/amdgpu: bind to any 0x1002 PCI diplay class device")

Cc: stable@vger.kernel.org
Signed-off-by: Lukas Fink <lukas.fink1@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1928,7 +1928,7 @@ static int amdgpu_pci_probe(struct pci_d
 			return -ENODEV;
 	}
 
-	if (flags == 0) {
+	if (flags == CHIP_IP_DISCOVERY) {
 		DRM_INFO("Unsupported asic.  Remove me when IP discovery init is in place.\n");
 		return -ENODEV;
 	}


