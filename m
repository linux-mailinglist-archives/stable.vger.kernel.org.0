Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2262B6581DE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiL1QcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbiL1Qbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36571CFEB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:28:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201206157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31847C433EF;
        Wed, 28 Dec 2022 16:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244882;
        bh=P/yqFWzpRP1MUCTMMFFZHoiJC4V0gyYh77CB16B4cZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P90Inyd9olBs3+O4BkLxWRPQo36PpjxcO3L1M1swAVTalbLU3hNpws9j/TvFdaGg9
         53UXbLd/YNa3Es121plQpLZ5NTXSXYqIPFYVX7DPeqM7PC+ss3xQe4Wm4YBF4Sh+9N
         XMbPoYimHb13GMX/dSeRF8ErV+aFE/cIWlSPWqFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0793/1073] iommu/amd: Fix pci device refcount leak in ppr_notifier()
Date:   Wed, 28 Dec 2022 15:39:41 +0100
Message-Id: <20221228144349.549983124@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6cf0981c2233f97d56938d9d61845383d6eb227c ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put(). So call it before returning from ppr_notifier()
to avoid refcount leak.

Fixes: daae2d25a477 ("iommu/amd: Don't copy GCR3 table root pointer")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221118093604.216371-1-yangyingliang@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
index 6a1f02c62dff..9f7fab49a5a9 100644
--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -587,6 +587,7 @@ static int ppr_notifier(struct notifier_block *nb, unsigned long e, void *data)
 	put_device_state(dev_state);
 
 out:
+	pci_dev_put(pdev);
 	return ret;
 }
 
-- 
2.35.1



