Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7C5259CF3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgIAPMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728411AbgIAPMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:12:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7EB9206FA;
        Tue,  1 Sep 2020 15:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973125;
        bh=MJQIIuGo12zKiOAl5vQDprxXaOkAu816ET0kSn0Rrqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aniKh8DizM5FadVruJfmwyranWN1Qr+O+3vUM7FOrEvyvuflXZsA4sz28BBYbGLZH
         E/9hESxpXVysXctZBOZ9Gah3LuieKhYh96/VkfG2MG+aGKuRMxp1SxH97Wt0WvCNFj
         Yxgvc/6UvvM64Q5++xORyoPUEbyi+/sKzSsAa4+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/62] scsi: lpfc: Fix shost refcount mismatch when deleting vport
Date:   Tue,  1 Sep 2020 17:10:00 +0200
Message-Id: <20200901150921.604740311@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dick Kennedy <dick.kennedy@broadcom.com>

[ Upstream commit 03dbfe0668e6692917ac278883e0586cd7f7d753 ]

When vports are deleted, it is observed that there is memory/kthread
leakage as the vport isn't fully being released.

There is a shost reference taken in scsi_add_host_dma that is not released
during scsi_remove_host. It was noticed that other drivers resolve this by
doing a scsi_host_put after calling scsi_remove_host.

The vport_delete routine is taking two references one that corresponds to
an access to the scsi_host in the vport_delete routine and another that is
released after the adapter mailbox command completes that destroys the VPI
that corresponds to the vport.

Remove one of the references taken such that the second reference that is
put will complete the missing scsi_add_host_dma reference and the shost
will be terminated.

Link: https://lore.kernel.org/r/20200630215001.70793-8-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_vport.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 861c57bc4520a..72248712949e0 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -615,27 +615,16 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		    vport->port_state < LPFC_VPORT_READY)
 			return -EAGAIN;
 	}
+
 	/*
-	 * This is a bit of a mess.  We want to ensure the shost doesn't get
-	 * torn down until we're done with the embedded lpfc_vport structure.
-	 *
-	 * Beyond holding a reference for this function, we also need a
-	 * reference for outstanding I/O requests we schedule during delete
-	 * processing.  But once we scsi_remove_host() we can no longer obtain
-	 * a reference through scsi_host_get().
-	 *
-	 * So we take two references here.  We release one reference at the
-	 * bottom of the function -- after delinking the vport.  And we
-	 * release the other at the completion of the unreg_vpi that get's
-	 * initiated after we've disposed of all other resources associated
-	 * with the port.
+	 * Take early refcount for outstanding I/O requests we schedule during
+	 * delete processing for unreg_vpi.  Always keep this before
+	 * scsi_remove_host() as we can no longer obtain a reference through
+	 * scsi_host_get() after scsi_host_remove as shost is set to SHOST_DEL.
 	 */
 	if (!scsi_host_get(shost))
 		return VPORT_INVAL;
-	if (!scsi_host_get(shost)) {
-		scsi_host_put(shost);
-		return VPORT_INVAL;
-	}
+
 	lpfc_free_sysfs_attr(vport);
 
 	lpfc_debugfs_terminate(vport);
@@ -783,8 +772,9 @@ skip_logo:
 		if (!(vport->vpi_state & LPFC_VPI_REGISTERED) ||
 				lpfc_mbx_unreg_vpi(vport))
 			scsi_host_put(shost);
-	} else
+	} else {
 		scsi_host_put(shost);
+	}
 
 	lpfc_free_vpi(phba, vport->vpi);
 	vport->work_port_events = 0;
-- 
2.25.1



