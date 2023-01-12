Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D90667515
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjALORv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbjALORL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:17:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5947574E7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:09:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79354B81E6B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4C8C433D2;
        Thu, 12 Jan 2023 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532540;
        bh=Mp1/T7PmqxzoioPX2+0xKJyLik9zZb3UDcFWWdSOBAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7nR2Ait1q5cLdk9zQk3lPJs96KaP/aFd77wud1P0Dzp0soAPOWhJL762GV6kgxQr
         F/8PLurMWFtOhzfUCs5qgC6yPPQQvHte8Assw0pxrjI839/qA4tVtf/AKvmk3UV9TO
         /im+b+xbeWpv/PGNVUXgW9ldhsEZ/HjoD1BV+JGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/783] drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()
Date:   Thu, 12 Jan 2023 14:48:31 +0100
Message-Id: <20230112135533.351757501@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit ca54639c7752edf1304d92ff4d0c049d4efc9ba0 ]

As comment of pci_get_class() says, it returns a pci_device with its
refcount increased and decreased the refcount for the input parameter
@from if it is not NULL.

If we break the loop in amdgpu_atrm_get_bios() with 'pdev' not NULL, we
need to call pci_dev_put() to decrease the refcount. Add the missing
pci_dev_put() to avoid refcount leak.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 6333cada1e09..4b568ee93243 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -313,6 +313,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 
 	if (!found)
 		return false;
+	pci_dev_put(pdev);
 
 	adev->bios = kmalloc(size, GFP_KERNEL);
 	if (!adev->bios) {
-- 
2.35.1



