Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0D3145195
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgAVJzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729587AbgAVJdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:33:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4652071E;
        Wed, 22 Jan 2020 09:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685599;
        bh=e36sjmPaCPPq1/i9Ltj188SqoWa1clYoefAn7mPbTaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjnoIz3BVOKOucX+wZB0elDz4y1HJTxIQ2qcx/eNo96zMEzZ7xMG5X7UZGXzkSBib
         shX7Y+cybhEQgMZCFWn6vnZ+/ZLAvDwFZ8l+D08XVrPN4MM+ikBDz7v6L0YI8+LcAj
         QTJ2YreURjE/8V5JhKBTRk36Mo4riYiBh/2ws3CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 72/76] scsi: bnx2i: fix potential use after free
Date:   Wed, 22 Jan 2020 10:29:28 +0100
Message-Id: <20200122092802.446948684@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 29d28f2b8d3736ac61c28ef7e20fda63795b74d9 upstream.

The member hba->pcidev may be used after its reference is dropped. Move the
put function to where it is never used to avoid potential use after free
issues.

Fixes: a77171806515 ("[SCSI] bnx2i: Removed the reference to the netdev->base_addr")
Link: https://lore.kernel.org/r/1573043541-19126-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -915,12 +915,12 @@ void bnx2i_free_hba(struct bnx2i_hba *hb
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
 	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
-	pci_dev_put(hba->pcidev);
 
 	if (hba->regview) {
 		pci_iounmap(hba->pcidev, hba->regview);
 		hba->regview = NULL;
 	}
+	pci_dev_put(hba->pcidev);
 	bnx2i_free_mp_bdt(hba);
 	bnx2i_release_free_cid_que(hba);
 	iscsi_host_free(shost);


