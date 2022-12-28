Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E27165800C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiL1QNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiL1QMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:12:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A5018E06
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:10:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43CCA61580
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D12AC433F0;
        Wed, 28 Dec 2022 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243855;
        bh=1Ebm9EXyzyRrLnk7ex+KcqhioFXHdbAYh5h/mrskiSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b647jqLfaoaRHsLshHXQsGvFgb9y2MK8DCX/iteOu0MH7Y7QamEJRfL1Vj/+bcJKV
         ORrb74iMpIHG3HzNEhbE2X6E39tUY7tUDKxfOjRnRASQE/ZLi+fiaG/xHMPBess1YQ
         MEw0znHGgnaEMN5In0OFPKllG6xx7Bd939vrqYoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0567/1146] octeontx2-af: cn10k: mcs: Fix a resource leak in the probe and remove functions
Date:   Wed, 28 Dec 2022 15:35:06 +0100
Message-Id: <20221228144345.567940757@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 87c978123ef1f346d7385eaccc141022d368166f ]

In mcs_register_interrupts(), a call to request_irq() is not balanced by a
corresponding free_irq(), neither in the error handling path, nor in the
remove function.

Add the missing calls.

Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/69f153db5152a141069f990206e7389f961d41ec.1670693669.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index c0bedf402da9..f68a6a0e3aa4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -1184,10 +1184,13 @@ static int mcs_register_interrupts(struct mcs *mcs)
 	mcs->tx_sa_active = alloc_mem(mcs, mcs->hw->sc_entries);
 	if (!mcs->tx_sa_active) {
 		ret = -ENOMEM;
-		goto exit;
+		goto free_irq;
 	}
 
 	return ret;
+
+free_irq:
+	free_irq(pci_irq_vector(mcs->pdev, MCS_INT_VEC_IP), mcs);
 exit:
 	pci_free_irq_vectors(mcs->pdev);
 	mcs->num_vec = 0;
@@ -1589,6 +1592,7 @@ static void mcs_remove(struct pci_dev *pdev)
 
 	/* Set MCS to external bypass */
 	mcs_set_external_bypass(mcs, true);
+	free_irq(pci_irq_vector(pdev, MCS_INT_VEC_IP), mcs);
 	pci_free_irq_vectors(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
2.35.1



