Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E440657E02
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiL1PtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiL1PtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:49:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A913418391
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:49:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61BFEB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA224C433F2;
        Wed, 28 Dec 2022 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242544;
        bh=i+rZrYsQF5L/j/g4JaaIbpwtUzmf4qv55bP3vVOFMHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AT7GtYF/BZMyFgIHKP1xtVWp9hWJppdc5MpwB28T67mo1j9mVynDXRe6VoEPshjGT
         WaE0nbUDaqgNo2gPaj2ICzvWfPGpgpynpnY3L9Jn2kqyKbfrcb+XYRNEQLdKFk3vmi
         QdmzPJV102W6tjUInNl4efiXzz0tK/8c+X0mtI2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0422/1073] drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()
Date:   Wed, 28 Dec 2022 15:33:30 +0100
Message-Id: <20221228144339.484974998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 725a521a18734f65de05b8d353b5bd0d3ca4c37a ]

As comment of pci_get_class() says, it returns a pci_device with its
refcount increased and decreased the refcount for the input parameter
@from if it is not NULL.

If we break the loop in radeon_atrm_get_bios() with 'pdev' not NULL, we
need to call pci_dev_put() to decrease the refcount. Add the missing
pci_dev_put() to avoid refcount leak.

Fixes: d8ade3526b2a ("drm/radeon: handle non-VGA class pci devices with ATRM")
Fixes: c61e2775873f ("drm/radeon: split ATRM support out from the ATPX handler (v3)")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_bios.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 1d99c9a2b56e..63bdc9f6fc24 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -227,6 +227,7 @@ static bool radeon_atrm_get_bios(struct radeon_device *rdev)
 
 	if (!found)
 		return false;
+	pci_dev_put(pdev);
 
 	rdev->bios = kmalloc(size, GFP_KERNEL);
 	if (!rdev->bios) {
-- 
2.35.1



