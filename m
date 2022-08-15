Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B48593630
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiHOTML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240959AbiHOTI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:08:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC18C6443;
        Mon, 15 Aug 2022 11:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88F3961024;
        Mon, 15 Aug 2022 18:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EDAC433D6;
        Mon, 15 Aug 2022 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588552;
        bh=BxLSowCUd+gDlvDoIK2xP9edGBiTg8HchpI/r7K7JdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWrSeIKm1DRs8AQfMPDZFylEMsohmwA/LY7ySUj/qaHtUNyg4FgeU0IPsSkYEP5bF
         +7WoxbP56Fqoby85OK740ehx1Ftu1gIVLbMBSNV9jKiZrVK7YGZKs5+8Ddi9d6Zqyl
         VzvdLHmbTx+TDqTryH0d336pQD7RNqq7Unayl6es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/779] misc: rtsx: Fix an error handling path in rtsx_pci_probe()
Date:   Mon, 15 Aug 2022 20:01:25 +0200
Message-Id: <20220815180356.115558709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 44fd1917314e9d4f53dd95dd65df1c152f503d3a ]

If an error occurs after a successful idr_alloc() call, the corresponding
resource must be released with idr_remove() as already done in the .remove
function.

Update the error handling path to add the missing idr_remove() call.

Fixes: ada8a8a13b13 ("mfd: Add realtek pcie card reader driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/e8dc41716cbf52fb37a12e70d8972848e69df6d6.1655271216.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 5121edb0d9ef..62fdbbd55e74 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1581,7 +1581,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	pcr->remap_addr = ioremap(base, len);
 	if (!pcr->remap_addr) {
 		ret = -ENOMEM;
-		goto free_handle;
+		goto free_idr;
 	}
 
 	pcr->rtsx_resv_buf = dma_alloc_coherent(&(pcidev->dev),
@@ -1651,6 +1651,10 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 			pcr->rtsx_resv_buf, pcr->rtsx_resv_buf_addr);
 unmap:
 	iounmap(pcr->remap_addr);
+free_idr:
+	spin_lock(&rtsx_pci_lock);
+	idr_remove(&rtsx_pci_idr, pcr->id);
+	spin_unlock(&rtsx_pci_lock);
 free_handle:
 	kfree(handle);
 free_pcr:
-- 
2.35.1



