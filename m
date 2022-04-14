Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012BA5010F5
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345676AbiDNNyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344914AbiDNNoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C3F56775;
        Thu, 14 Apr 2022 06:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D07A161BA7;
        Thu, 14 Apr 2022 13:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C85C385A1;
        Thu, 14 Apr 2022 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943640;
        bh=jwt4CADUzDZcKMg31hsForQ2DAABZD9u7dOEA4ghXUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LA+x1a1CDTxlMNywmuWLLb/OMqH1QWBbqIGjlX+OAmkZZ98qgvxd1hr9F4qoFpN23
         E+D6HvmPTZjYtwt8KkMl6avJ4xIWSiiOXqqPHGjoJQWY8aUOLH/LVII36i0mcFeOZO
         rYqr9KKQtQC1mruhJffoPlupJqgp3smpkunsEiFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 229/475] misc: alcor_pci: Fix an error handling path
Date:   Thu, 14 Apr 2022 15:10:14 +0200
Message-Id: <20220414110901.529728373@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit 5b3dc949f554379edcb8ef6111aa5ecb78feb798 ]

A successful ida_simple_get() should be balanced by a corresponding
ida_simple_remove().

Add the missing call in the error handling path of the probe.

While at it, switch to ida_alloc()/ida_free() instead to
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Fixes: 4f556bc04e3c ("misc: cardreader: add new Alcor Micro Cardreader PCI driver")
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/918a9875b7f67b7f8f123c4446452603422e8c5e.1644136776.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/alcor_pci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/cardreader/alcor_pci.c b/drivers/misc/cardreader/alcor_pci.c
index 1fadb95b85b0..ba5d5c102b3c 100644
--- a/drivers/misc/cardreader/alcor_pci.c
+++ b/drivers/misc/cardreader/alcor_pci.c
@@ -260,7 +260,7 @@ static int alcor_pci_probe(struct pci_dev *pdev,
 	if (!priv)
 		return -ENOMEM;
 
-	ret = ida_simple_get(&alcor_pci_idr, 0, 0, GFP_KERNEL);
+	ret = ida_alloc(&alcor_pci_idr, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 	priv->id = ret;
@@ -274,7 +274,8 @@ static int alcor_pci_probe(struct pci_dev *pdev,
 	ret = pci_request_regions(pdev, DRV_NAME_ALCOR_PCI);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot request region\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error_free_ida;
 	}
 
 	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
@@ -318,6 +319,8 @@ static int alcor_pci_probe(struct pci_dev *pdev,
 
 error_release_regions:
 	pci_release_regions(pdev);
+error_free_ida:
+	ida_free(&alcor_pci_idr, priv->id);
 	return ret;
 }
 
@@ -331,7 +334,7 @@ static void alcor_pci_remove(struct pci_dev *pdev)
 
 	mfd_remove_devices(&pdev->dev);
 
-	ida_simple_remove(&alcor_pci_idr, priv->id);
+	ida_free(&alcor_pci_idr, priv->id);
 
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
-- 
2.34.1



