Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0930D66CA3C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbjAPRAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjAPRAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3D75864A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:42:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54F2361042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEE7C433EF;
        Mon, 16 Jan 2023 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887378;
        bh=5/GArmfaHd10/ZDnLWrknc7eIRqWyvHAnVjxPsoHOfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCfgmuBn7XUDdR0Q8cjJQL9Ce6MOQMLcQJDo5SPS/zUzQhEztkwpSPOZS+pzqEtiW
         HccO8orE+pNBJsYmWyrcmd1DYHhBuXWu+uSP5n2Fm+z8zr0c6RTnNhbxdQm3W/OkEC
         R5f/jqVqw36+mDJnUjfvFLoMbvrS1lXsZs9egjk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 126/521] drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()
Date:   Mon, 16 Jan 2023 16:46:28 +0100
Message-Id: <20230116154852.907842183@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 6cf3dd5edffd..c1e2e9912bf0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -312,6 +312,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 
 	if (!found)
 		return false;
+	pci_dev_put(pdev);
 
 	adev->bios = kmalloc(size, GFP_KERNEL);
 	if (!adev->bios) {
-- 
2.35.1



