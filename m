Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6443260FDCA
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiJ0Q7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiJ0Q7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5D0B87A2
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1A28B82708
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3D2C433D6;
        Thu, 27 Oct 2022 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889941;
        bh=q/kvSj/JIS0fa//u6GaZO3+8VY5h+4tO3o/tuAVNU+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ma0s9LQvyXK/vZG9HdnGh9FTQewYzX1BFnU6nWSDYcYSs2DNpcz5VSO6xPdtrsp66
         C65BRUYvDtMsPynRxy9vXBW+xIJRIguZiLLEJRb//Sf5iDttzd6M8coKwefMxySizT
         eMWqNcvpr6V8aNOhUVFR2NcEHLCeubeTo2tLj5wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 55/94] scsi: lpfc: Fix memory leak in lpfc_create_port()
Date:   Thu, 27 Oct 2022 18:54:57 +0200
Message-Id: <20221027165059.387860394@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit dc8e483f684a24cc06e1d5fa958b54db58855093 ]

Commit 5e633302ace1 ("scsi: lpfc: vmid: Add support for VMID in mailbox
command") introduced allocations for the VMID resources in
lpfc_create_port() after the call to scsi_host_alloc(). Upon failure on the
VMID allocations, the new code would branch to the 'out' label, which
returns NULL without unwinding anything, thus skipping the call to
scsi_host_put().

Fix the problem by creating a separate label 'out_free_vmid' to unwind the
VMID resources and make the 'out_put_shost' label call only
scsi_host_put(), as was done before the introduction of allocations for
VMID.

Fixes: 5e633302ace1 ("scsi: lpfc: vmid: Add support for VMID in mailbox command")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Link: https://lore.kernel.org/r/20220916035908.712799-1-rafaelmendsr@gmail.com
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1a02134438fc..47e210095315 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4822,7 +4822,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	rc = lpfc_vmid_res_alloc(phba, vport);
 
 	if (rc)
-		goto out;
+		goto out_put_shost;
 
 	/* Initialize all internally managed lists. */
 	INIT_LIST_HEAD(&vport->fc_nodes);
@@ -4840,16 +4840,17 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 
 	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)
-		goto out_put_shost;
+		goto out_free_vmid;
 
 	spin_lock_irq(&phba->port_list_lock);
 	list_add_tail(&vport->listentry, &phba->port_list);
 	spin_unlock_irq(&phba->port_list_lock);
 	return vport;
 
-out_put_shost:
+out_free_vmid:
 	kfree(vport->vmid);
 	bitmap_free(vport->vmid_priority_range);
+out_put_shost:
 	scsi_host_put(shost);
 out:
 	return NULL;
-- 
2.35.1



