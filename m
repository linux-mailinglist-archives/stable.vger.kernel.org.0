Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FBE4FCB29
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347315AbiDLBDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349197AbiDLA7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:59:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A5937A21;
        Mon, 11 Apr 2022 17:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E419E60A66;
        Tue, 12 Apr 2022 00:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C00C385A3;
        Tue, 12 Apr 2022 00:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724773;
        bh=igqZQIT4dt6yyEHS1xHvpSxQkICWs0nH6DyFCSsxjAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdtDNRXGkKfAvSpKuUV0kmtsf3zcMzFumayY2nx/WCjJbnlzrkKpSC1NISnoU13y1
         HhT5PleIJzePl3jtR3zq6HlGq9bfTe6MlfQmfd6jinujZ0A87MNlwH+kA5n9yL8IMF
         v7ib42K+FfDO/H8iLynLpdSITGlHPo3XVbGDY4GZM1Dry+AZmrCQrwBBTycA8uYrYI
         5oF95tAvR11G6Z/xbHuWlmESg0ajBxBUchS41yKcvnj1OdVWJO8DjVpbmBuXE6FB+C
         LKae1HoygsfVLA8kDkv4Jby+jkfQNnhSYj4jLcYufBdS2znjIt/ZB7O9wfN3QlJpec
         rIljsBXtRtOSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/7] scsi: lpfc: Fix queue failures when recovering from PCI parity error
Date:   Mon, 11 Apr 2022 20:52:43 -0400
Message-Id: <20220412005248.351701-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005248.351701-1-sashal@kernel.org>
References: <20220412005248.351701-1-sashal@kernel.org>
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
index 8c640bcf107b..985f733719d7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10921,6 +10921,8 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Init cpu_map array */
+	lpfc_cpu_map_array_init(phba);
 	/* Configure and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
-- 
2.35.1

