Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAC65050F8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbiDRMa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbiDRM2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:28:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FF0220D5;
        Mon, 18 Apr 2022 05:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14AA560FAC;
        Mon, 18 Apr 2022 12:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0826EC385A1;
        Mon, 18 Apr 2022 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284536;
        bh=96MyTFeUkLFFOgfR7cfAs1rXUZMNhiPDiCmVNh0AGgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G041+z82JhWWd3XphFwgdh8l+qaK2CRSgT851RCtOlB2S7kmFucTXMRDorerpVZfw
         +KleFaHCDx329uB2vrCCPGUi5mJ45R00/5Nfg2hvxqKEJJbVUTWtvQ6WHp8c0hl8qd
         j2SrXiM7QXAPidtzGNBlqIoWfm2sXyR7GzV2UoeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 148/219] scsi: lpfc: Fix queue failures when recovering from PCI parity error
Date:   Mon, 18 Apr 2022 14:11:57 +0200
Message-Id: <20220418121211.031290580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit df0101197c4d9596682901631f3ee193ed354873 ]

When recovering from a pci-parity error the driver is failing to re-create
queues, causing recovery to fail. Looking deeper, it was found that the
interrupt vector count allocated on the recovery was fewer than the vectors
originally allocated. This disparity resulted in CPU map entries with stale
information. When the driver tries to re-create the queues, it attempts to
use the stale information which indicates an eq/interrupt vector that was
no longer created.

Fix by clearng the cpup map array before enabling and requesting the IRQs
in the lpfc_sli_reset_slot_s4 routine().

Link: https://lore.kernel.org/r/20220317032737.45308-4-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c8c049cf8d96..9569a7390f9d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -15248,6 +15248,8 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Init cpu_map array */
+	lpfc_cpu_map_array_init(phba);
 	/* Configure and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
-- 
2.35.1



