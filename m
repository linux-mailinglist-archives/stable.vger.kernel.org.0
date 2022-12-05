Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1249E64339B
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiLETiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbiLEThf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:37:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FDA252B8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3196A61321
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DB7C433D7;
        Mon,  5 Dec 2022 19:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268870;
        bh=MABeFD3g0kmJPSh4vSK8WAaKfRMeUbRfs76WU0r+CWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tae52Nuf3FMd1bxRf11QTwkImbSzZvLVjJZqsstR7tXayW0uYbj1nYTPyuOHdcZfn
         qNTfZmZBqnhMTWU4URKAdzkQ2zfRN0wxKJUZtJBCXm0G4Eu6QkkjqBPl06M86SdI6d
         NnNGG2Da/pLsHf6OllCIBQLfRghWzrDYBWvfewtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/120] can: m_can: pci: add missing m_can_class_free_dev() in probe/remove methods
Date:   Mon,  5 Dec 2022 20:09:41 +0100
Message-Id: <20221205190807.774249515@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 1eca1d4cc21b6d0fc5f9a390339804c0afce9439 ]

In m_can_pci_remove() and error handling path of m_can_pci_probe(),
m_can_class_free_dev() should be called to free resource allocated by
m_can_class_allocate_dev(), otherwise there will be memleak.

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/all/1668168684-6390-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can_pci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 8f184a852a0a..f2219aa2824b 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -120,7 +120,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	ret = pci_alloc_irq_vectors(pci, 1, 1, PCI_IRQ_ALL_TYPES);
 	if (ret < 0)
-		return ret;
+		goto err_free_dev;
 
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
@@ -132,7 +132,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	ret = m_can_class_register(mcan_class);
 	if (ret)
-		goto err;
+		goto err_free_irq;
 
 	/* Enable interrupt control at CAN wrapper IP */
 	writel(0x1, base + CTL_CSR_INT_CTL_OFFSET);
@@ -144,8 +144,10 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	return 0;
 
-err:
+err_free_irq:
 	pci_free_irq_vectors(pci);
+err_free_dev:
+	m_can_class_free_dev(mcan_class->net);
 	return ret;
 }
 
@@ -161,6 +163,7 @@ static void m_can_pci_remove(struct pci_dev *pci)
 	writel(0x0, priv->base + CTL_CSR_INT_CTL_OFFSET);
 
 	m_can_class_unregister(mcan_class);
+	m_can_class_free_dev(mcan_class->net);
 	pci_free_irq_vectors(pci);
 }
 
-- 
2.35.1



