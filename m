Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B3F64342B
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbiLETmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiLETmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:42:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A2229CB0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53BF5B81205
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40BBC433C1;
        Mon,  5 Dec 2022 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269191;
        bh=WtjVht1LCaMZXuTJpBuOfwzhLSdg72qo4DUoF+asnZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNQ9lOBlBJijuEswad1UzUcvwWDjCZo7qFs3qKGsg0da5XEIgtnmFfPkjra0KiYpZ
         ZyEeI34Bz/OyrBf5Ef/qGekKLmcSRybEaRLW6oOoIJRUQAg1ia6GYBlb0ltX3393fI
         SwZu/yo1ls55Y7h5GVmKMc6sXRpYmM3qILVGj8pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/153] bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()
Date:   Mon,  5 Dec 2022 20:09:21 +0100
Message-Id: <20221205190809.792315834@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

[ Upstream commit 3637a29ccbb6461b7268c5c5db525935d510afc6 ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put(). Call pci_dev_put() before returning from
bnx2x_vf_is_pcie_pending() to avoid refcount leak.

Fixes: b56e9670ffa4 ("bnx2x: Prepare device and initialize VF database")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221119070202.1407648-1-yangyingliang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 4630998d47fd..d920bb8dae77 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -807,16 +807,20 @@ static void bnx2x_vf_enable_traffic(struct bnx2x *bp, struct bnx2x_virtf *vf)
 
 static u8 bnx2x_vf_is_pcie_pending(struct bnx2x *bp, u8 abs_vfid)
 {
-	struct pci_dev *dev;
 	struct bnx2x_virtf *vf = bnx2x_vf_by_abs_fid(bp, abs_vfid);
+	struct pci_dev *dev;
+	bool pending;
 
 	if (!vf)
 		return false;
 
 	dev = pci_get_domain_bus_and_slot(vf->domain, vf->bus, vf->devfn);
-	if (dev)
-		return bnx2x_is_pcie_pending(dev);
-	return false;
+	if (!dev)
+		return false;
+	pending = bnx2x_is_pcie_pending(dev);
+	pci_dev_put(dev);
+
+	return pending;
 }
 
 int bnx2x_vf_flr_clnup_epilog(struct bnx2x *bp, u8 abs_vfid)
-- 
2.35.1



