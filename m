Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60182E68E7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441226AbgL1Qm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbgL1M7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A85122B2A;
        Mon, 28 Dec 2020 12:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160316;
        bh=F+YAm5F8ehhJEr6UPnNkkXN2owInqTsH48L2UHh36XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyojWe2klI5Do37uPIulN7kqrTIaq5yyTtWzINLEmYqL0URYKmz5qhK5nGigeuhKH
         G//fBCa9czpdny9QI/9AK4c6Mtgc1sK4J/jzmcjsC492nk/Ht28Zzlws/ehkIhfgtK
         NnzQLz1G/tp16eTDixTHPdU91Z+H6As9bxgTHg8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 010/175] scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"
Date:   Mon, 28 Dec 2020 13:47:43 +0100
Message-Id: <20201228124853.751432261@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit eeaf06af6f87e1dba371fbe42674e6f963220b9c upstream.

My patch caused kernel Oopses and delays in boot.  Revert it.

The problem was that I moved the "mem->dma = paddr;" before the call to
be_fill_queue().  But the first thing that the be_fill_queue() function
does is memset the whole struct to zero which overwrites the assignment.

Link: https://lore.kernel.org/r/X8jXkt6eThjyVP1v@mwanda
Fixes: 38b2db564d9a ("scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()")
Cc: stable <stable@vger.kernel.org>
Reported-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/be2iscsi/be_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3052,7 +3052,6 @@ static int beiscsi_create_eqs(struct bei
 		if (!eq_vaddress)
 			goto create_eq_error;
 
-		mem->dma = paddr;
 		mem->va = eq_vaddress;
 		ret = be_fill_queue(eq, phba->params.num_eq_entries,
 				    sizeof(struct be_eq_entry), eq_vaddress);
@@ -3062,6 +3061,7 @@ static int beiscsi_create_eqs(struct bei
 			goto create_eq_error;
 		}
 
+		mem->dma = paddr;
 		ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
 					    phwi_context->cur_eqd);
 		if (ret) {
@@ -3116,7 +3116,6 @@ static int beiscsi_create_cqs(struct bei
 		if (!cq_vaddress)
 			goto create_cq_error;
 
-		mem->dma = paddr;
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
@@ -3126,6 +3125,7 @@ static int beiscsi_create_cqs(struct bei
 			goto create_cq_error;
 		}
 
+		mem->dma = paddr;
 		ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false,
 					    false, 0);
 		if (ret) {


