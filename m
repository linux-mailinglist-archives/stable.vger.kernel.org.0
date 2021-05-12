Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1437CD53
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbhELQyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243789AbhELQmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF6F061943;
        Wed, 12 May 2021 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835624;
        bh=54zE9IuikUUTVEHCmUY9GdUeP1fU1VyQSZNG6C88SMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCVPxiiY8Z47z8YDVdeA+sNmIlR81j/5kzRKGa0VNJwhR/FXhLIzTVm/hAWjUJMOf
         8U3p/FLlSgc0ZhNwOZQO/edkrDfnm63XwCQX0O+5ZZ14xW72MBN9gs/RPWP7T36pqi
         ukRfmuoQ+ny+eKYhqnZs/R3PLmHhW5qsncWZGz8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 420/677] scsi: ibmvfc: Fix invalid state machine BUG_ON()
Date:   Wed, 12 May 2021 16:47:46 +0200
Message-Id: <20210512144851.291474324@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian King <brking@linux.vnet.ibm.com>

[ Upstream commit 15cfef8623a449d40d16541687afd58e78033be3 ]

This fixes an issue hitting the BUG_ON() in ibmvfc_do_work(). When going
through a host action of IBMVFC_HOST_ACTION_RESET, we change the action to
IBMVFC_HOST_ACTION_TGT_DEL, then drop the host lock, and reset the CRQ,
which changes the host state to IBMVFC_NO_CRQ. If, prior to setting the
host state to IBMVFC_NO_CRQ, ibmvfc_init_host() is called, it can then end
up changing the host action to IBMVFC_HOST_ACTION_INIT.  If we then change
the host state to IBMVFC_NO_CRQ, we will then hit the BUG_ON().

Make a couple of changes to avoid this. Leave the host action to be
IBMVFC_HOST_ACTION_RESET or IBMVFC_HOST_ACTION_REENABLE until after we drop
the host lock and reset or reenable the CRQ. Also harden the host state
machine to ensure we cannot leave the reset / reenable state until we've
finished processing the reset or reenable.

Link: https://lore.kernel.org/r/20210413001009.902400-1-tyreld@linux.ibm.com
Fixes: 73ee5d867287 ("[SCSI] ibmvfc: Fix soft lockup on resume")
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
[tyreld: added fixes tag]
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
[mkp: fix comment checkpatch warnings]
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 57 ++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 61831f2fdb30..d6675a25719d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -603,8 +603,17 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 		if (vhost->action == IBMVFC_HOST_ACTION_ALLOC_TGTS)
 			vhost->action = action;
 		break;
+	case IBMVFC_HOST_ACTION_REENABLE:
+	case IBMVFC_HOST_ACTION_RESET:
+		vhost->action = action;
+		break;
 	case IBMVFC_HOST_ACTION_INIT:
 	case IBMVFC_HOST_ACTION_TGT_DEL:
+	case IBMVFC_HOST_ACTION_LOGO:
+	case IBMVFC_HOST_ACTION_QUERY_TGTS:
+	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
+	case IBMVFC_HOST_ACTION_NONE:
+	default:
 		switch (vhost->action) {
 		case IBMVFC_HOST_ACTION_RESET:
 		case IBMVFC_HOST_ACTION_REENABLE:
@@ -614,15 +623,6 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 			break;
 		}
 		break;
-	case IBMVFC_HOST_ACTION_LOGO:
-	case IBMVFC_HOST_ACTION_QUERY_TGTS:
-	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
-	case IBMVFC_HOST_ACTION_NONE:
-	case IBMVFC_HOST_ACTION_RESET:
-	case IBMVFC_HOST_ACTION_REENABLE:
-	default:
-		vhost->action = action;
-		break;
 	}
 }
 
@@ -5373,30 +5373,49 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_INIT_WAIT:
 		break;
 	case IBMVFC_HOST_ACTION_RESET:
-		vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
 		list_splice_init(&vhost->purge, &purge);
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		ibmvfc_complete_purge(&purge);
 		rc = ibmvfc_reset_crq(vhost);
+
 		spin_lock_irqsave(vhost->host->host_lock, flags);
-		if (rc == H_CLOSED)
+		if (!rc || rc == H_CLOSED)
 			vio_enable_interrupts(to_vio_dev(vhost->dev));
-		if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
-		    (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
-			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
-			dev_err(vhost->dev, "Error after reset (rc=%d)\n", rc);
+		if (vhost->action == IBMVFC_HOST_ACTION_RESET) {
+			/*
+			 * The only action we could have changed to would have
+			 * been reenable, in which case, we skip the rest of
+			 * this path and wait until we've done the re-enable
+			 * before sending the crq init.
+			 */
+			vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
+
+			if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
+			    (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
+				ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+				dev_err(vhost->dev, "Error after reset (rc=%d)\n", rc);
+			}
 		}
 		break;
 	case IBMVFC_HOST_ACTION_REENABLE:
-		vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
 		list_splice_init(&vhost->purge, &purge);
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		ibmvfc_complete_purge(&purge);
 		rc = ibmvfc_reenable_crq_queue(vhost);
+
 		spin_lock_irqsave(vhost->host->host_lock, flags);
-		if (rc || (rc = ibmvfc_send_crq_init(vhost))) {
-			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
-			dev_err(vhost->dev, "Error after enable (rc=%d)\n", rc);
+		if (vhost->action == IBMVFC_HOST_ACTION_REENABLE) {
+			/*
+			 * The only action we could have changed to would have
+			 * been reset, in which case, we skip the rest of this
+			 * path and wait until we've done the reset before
+			 * sending the crq init.
+			 */
+			vhost->action = IBMVFC_HOST_ACTION_TGT_DEL;
+			if (rc || (rc = ibmvfc_send_crq_init(vhost))) {
+				ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+				dev_err(vhost->dev, "Error after enable (rc=%d)\n", rc);
+			}
 		}
 		break;
 	case IBMVFC_HOST_ACTION_LOGO:
-- 
2.30.2



