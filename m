Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213916E648D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjDRMuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjDRMuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD4E16DC3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49D616340B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B62AC433D2;
        Tue, 18 Apr 2023 12:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822211;
        bh=GC1ElIfd4d4yV76Nsn9CGAOKiO3k+cjxG6lcQ4FQguI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOxS/moznO9e9ySpXFz2oiT9hTquty6m9S0w/gtVJiY3uKJz2JqrQ9x5SPcs7uUre
         y0nPfBapQrfYorKNdP4ocaImd7SBuZJo3RxLFHR4aKsDk52ubnVIGFepnfd4KA/E6d
         c67/XwTVvLKjqxQISDKwUV10wp/GFrrsO8cgVVJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Simon Horman <simon.horman@corigine.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 064/139] net: wwan: iosm: Fix error handling path in ipc_pcie_probe()
Date:   Tue, 18 Apr 2023 14:22:09 +0200
Message-Id: <20230418120316.209353878@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit a56ef25619e079bd7d744636cf18d054d1e91982 ]

Smatch reports:
	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
	warn: missing unwind goto?

When dma_set_mask fails it directly returns without disabling pci
device and freeing ipc_pcie. Fix this my calling a correct goto label

As dma_set_mask returns either 0 or -EIO, we can use a goto label, as
it finally returns -EIO.

Add a set_mask_fail goto label which stands consistent with other goto
labels in this function..

Fixes: 035e3befc191 ("net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 5bf5a93937c9c..04517bd3325a2 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -295,7 +295,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 	ret = dma_set_mask(ipc_pcie->dev, DMA_BIT_MASK(64));
 	if (ret) {
 		dev_err(ipc_pcie->dev, "Could not set PCI DMA mask: %d", ret);
-		return ret;
+		goto set_mask_fail;
 	}
 
 	ipc_pcie_config_aspm(ipc_pcie);
@@ -323,6 +323,7 @@ static int ipc_pcie_probe(struct pci_dev *pci,
 imem_init_fail:
 	ipc_pcie_resources_release(ipc_pcie);
 resources_req_fail:
+set_mask_fail:
 	pci_disable_device(pci);
 pci_enable_fail:
 	kfree(ipc_pcie);
-- 
2.39.2



