Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152F65053B3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbiDRNBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242416AbiDRM7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:59:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A61126111;
        Mon, 18 Apr 2022 05:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3578960FB6;
        Mon, 18 Apr 2022 12:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E91C385A1;
        Mon, 18 Apr 2022 12:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285672;
        bh=frfWCP/WFjSy1bdWI3vnHvvSGgCADe10jnfJswe0OCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zph4xvoIoWJXwKWBHxAjkTAhaq1ScJiT1KjVziWlVmcCRvU3WpJPX8fNMUyiicomM
         Evp2foBgS614A9/OYa9Dzm/ElmhCrE/NQ9mpNjAP+mEtKIdBBYCqeBaH+sQoV90tx6
         cmzn8aQhsSFyIuKCdMdZdzNvfHSCStFtolDYdRrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/105] scsi: lpfc: Fix queue failures when recovering from PCI parity error
Date:   Mon, 18 Apr 2022 14:12:55 +0200
Message-Id: <20220418121147.989206538@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
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
index 1149bfc42fe6..134e4ee5dc48 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13614,6 +13614,8 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Init cpu_map array */
+	lpfc_cpu_map_array_init(phba);
 	/* Configure and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
-- 
2.35.1



