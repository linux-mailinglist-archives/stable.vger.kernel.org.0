Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BAE4FCB41
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240776AbiDLBD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343957AbiDLA5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:57:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47642612C;
        Mon, 11 Apr 2022 17:49:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22EB161800;
        Tue, 12 Apr 2022 00:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5955DC385A9;
        Tue, 12 Apr 2022 00:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724585;
        bh=frfWCP/WFjSy1bdWI3vnHvvSGgCADe10jnfJswe0OCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rbo9ABDom7YgarALGxAcKJrexk5z8rseCIreNiWhe4bNp8oLQcuQUjIe8Vygi1BHF
         dz8IvENHMovgU2mDLCxRiVYAhuMUBgBOfA3PjGR926+dCZu7W6ExjNeFN0GfQauXI0
         qGUfapniqly079/gtZ2rdql2YbH1WrHySuY2o5zhZvqZq1JA8FoYddYqCZf6VNhdSY
         tUUfvkVbczTWPmTDClb2nJfbA6c1uMnwpJ8VvX7NcN/46LxKQPEzjTyjo8+kayGMy3
         GhVLDX/Ici3x1fwdiOwcXS1wDJBuxvzEyAS8RHGkJcBo8cNV+D4vaLIDkkg2f0C0RD
         EP5FSYrU5SKcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/30] scsi: lpfc: Fix queue failures when recovering from PCI parity error
Date:   Mon, 11 Apr 2022 20:48:46 -0400
Message-Id: <20220412004906.350678-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

