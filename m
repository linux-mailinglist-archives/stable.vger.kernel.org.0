Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F46756FDB9
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiGKJ7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiGKJ7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:59:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A882BB62A2;
        Mon, 11 Jul 2022 02:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62F63CE126A;
        Mon, 11 Jul 2022 09:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75798C34115;
        Mon, 11 Jul 2022 09:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531639;
        bh=m/KGAc9SXJsoFefchDyBa6ZxTDVjstgXbewAd/5Yeqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gkL5FJescV9DPqarMa0vQTQu4x/CC0fkcNntjh7xxqsXfuUuJilCm1+ssBJZHHPT
         Ua86/5j4V2JrNkfmkkkGNa0pdLm+URX4xjulv8eLwUQ6r4rjcMTTVbvHfDJaP05JnQ
         x43vS01rzgK/eDTqtZv+frw32P7djUKcSgY7ns9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/230] drm/amdgpu: bind to any 0x1002 PCI diplay class device
Date:   Mon, 11 Jul 2022 11:06:34 +0200
Message-Id: <20220711090607.978575207@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit eb4fd29afd4aa1c98d882800ceeee7d1f5262803 ]

Bind to all 0x1002 GPU devices.

For now we explicitly return -ENODEV for generic bindings.
Remove this check once IP discovery based checking is in place.

v2: rebase (Alex)

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index f65b4b233ffb..c294081022bd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1952,6 +1952,16 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x7424, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 	{0x1002, 0x743F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 
+	{ PCI_DEVICE(0x1002, PCI_ANY_ID),
+	  .class = PCI_CLASS_DISPLAY_VGA << 8,
+	  .class_mask = 0xffffff,
+	  .driver_data = 0 },
+
+	{ PCI_DEVICE(0x1002, PCI_ANY_ID),
+	  .class = PCI_CLASS_DISPLAY_OTHER << 8,
+	  .class_mask = 0xffffff,
+	  .driver_data = 0 },
+
 	{0, 0, 0}
 };
 
@@ -1999,6 +2009,11 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 			return -ENODEV;
 	}
 
+	if (flags == 0) {
+		DRM_INFO("Unsupported asic.  Remove me when IP discovery init is in place.\n");
+		return -ENODEV;
+	}
+
 	if (amdgpu_virtual_display ||
 	    amdgpu_device_asic_has_dc_support(flags & AMD_ASIC_MASK))
 		supports_atomic = true;
-- 
2.35.1



