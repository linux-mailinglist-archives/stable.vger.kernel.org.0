Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0A556FDAA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiGKJ7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiGKJ63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E8360536;
        Mon, 11 Jul 2022 02:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2370A61370;
        Mon, 11 Jul 2022 09:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B06C34115;
        Mon, 11 Jul 2022 09:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531642;
        bh=QV3wDxkxr74z3UkBITYTHGpxhZq8sdSdwFhGqaxO/UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNPWStETgrcR/E25nSh3n52DhzKVQiNsDzEwYXEgnZC0VKlDWVhh0xjPL2NFVI2ku
         JU+wfxRJKfhPhqOiuBaYpfL3uiY/SfSDZdSURK7X+0Rg10m2CCuJswcUc66ziv6bNv
         e7ZOejkkCl9a0EStUaLwqHyVmJa1PlxhljUXdhDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Fink <lukas.fink1@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/230] drm/amdgpu: Fix rejecting Tahiti GPUs
Date:   Mon, 11 Jul 2022 11:06:35 +0200
Message-Id: <20220711090608.007049812@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Fink <lukas.fink1@gmail.com>

[ Upstream commit 3993a799fc971bc9b918bd969aa55864447b5dde ]
[ Upstream commit 5f0754ab2751d1935818459e8e71a8fe26f6403c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2009,7 +2009,7 @@ static int amdgpu_pci_probe(struct pci_d
 			return -ENODEV;
 	}
 
-	if (flags == 0) {
+	if (flags == CHIP_IP_DISCOVERY) {
 		DRM_INFO("Unsupported asic.  Remove me when IP discovery init is in place.\n");
 		return -ENODEV;
 	}


