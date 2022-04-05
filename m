Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD994F2BE3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241632AbiDEIeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239455AbiDEIUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969B76C1D5;
        Tue,  5 Apr 2022 01:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B967B81BAF;
        Tue,  5 Apr 2022 08:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F88C385A1;
        Tue,  5 Apr 2022 08:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146418;
        bh=3SyFg1Ox2BVv77hwr5Q+brbLvYJwdOjO6I/B8CTdJ5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f877gaBDJ/tcX5L+0EeGaMrI56dTlIMwwHnmEs3105hPRVT7p+F2JGtaK95WTmoEs
         JZ1XwneC4KDv7n9KHDHV/N1HWr+VypmmSxRo81Gsef6xYYuciNTxrBsKdYdHUDdQFd
         +DE/cJCP2pLhdE9c5hiYDB6+v79sl5RIzhugWtHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0719/1126] misc: alcor_pci: Fix an error handling path
Date:   Tue,  5 Apr 2022 09:24:26 +0200
Message-Id: <20220405070428.697937935@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index de6d44a158bb..3f514d77a843 100644
--- a/drivers/misc/cardreader/alcor_pci.c
+++ b/drivers/misc/cardreader/alcor_pci.c
@@ -266,7 +266,7 @@ static int alcor_pci_probe(struct pci_dev *pdev,
 	if (!priv)
 		return -ENOMEM;
 
-	ret = ida_simple_get(&alcor_pci_idr, 0, 0, GFP_KERNEL);
+	ret = ida_alloc(&alcor_pci_idr, GFP_KERNEL);
 	if (ret < 0)
 		return ret;
 	priv->id = ret;
@@ -280,7 +280,8 @@ static int alcor_pci_probe(struct pci_dev *pdev,
 	ret = pci_request_regions(pdev, DRV_NAME_ALCOR_PCI);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot request region\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error_free_ida;
 	}
 
 	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
@@ -324,6 +325,8 @@ static int alcor_pci_probe(struct pci_dev *pdev,
 
 error_release_regions:
 	pci_release_regions(pdev);
+error_free_ida:
+	ida_free(&alcor_pci_idr, priv->id);
 	return ret;
 }
 
@@ -337,7 +340,7 @@ static void alcor_pci_remove(struct pci_dev *pdev)
 
 	mfd_remove_devices(&pdev->dev);
 
-	ida_simple_remove(&alcor_pci_idr, priv->id);
+	ida_free(&alcor_pci_idr, priv->id);
 
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
-- 
2.34.1



