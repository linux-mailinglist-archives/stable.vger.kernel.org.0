Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882272E3F0A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504185AbgL1Oc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504356AbgL1ObV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C0382245C;
        Mon, 28 Dec 2020 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165841;
        bh=xni1xbnFKMBXSg0riPo9DOg8dKdcuDT9JL1hPe3zpxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dc33vX19f3DCFMfskJ8VwLf04x3I6fbkNeJXXe0qk6z8mJBs6BHArZNZlDh1nGVxN
         0Fic7eat7UbPuBaQCke+mY68+XdXAen8JF5BK6mrf4t+OkTf2EHBEFgEwJYPMXinbZ
         Y+x20b5flz5AxwPsGJSdqfZlbvmDRasevOB9xDZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 672/717] scsi: lpfc: Re-fix use after free in lpfc_rq_buf_free()
Date:   Mon, 28 Dec 2020 13:51:10 +0100
Message-Id: <20201228125053.178924484@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

commit e5785d3ec32f5f44dd88cd7b398e496742630469 upstream.

Commit 9816ef6ecbc1 ("scsi: lpfc: Use after free in lpfc_rq_buf_free()")
was made to correct a use after free condition in lpfc_rq_buf_free().
Unfortunately, a subsequent patch cut on a tree without the fix
inadvertently reverted the fix.

Put the fix back: Move the freeing of the rqb_entry to after the print
function that references it.

Link: https://lore.kernel.org/r/20201020202719.54726-4-james.smart@broadcom.com
Fixes: 411de511c694 ("scsi: lpfc: Fix RQ empty firmware trap")
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -721,7 +721,6 @@ lpfc_rq_buf_free(struct lpfc_hba *phba,
 	drqe.address_hi = putPaddrHigh(rqb_entry->dbuf.phys);
 	rc = lpfc_sli4_rq_put(rqb_entry->hrq, rqb_entry->drq, &hrqe, &drqe);
 	if (rc < 0) {
-		(rqbp->rqb_free_buffer)(phba, rqb_entry);
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"6409 Cannot post to HRQ %d: %x %x %x "
 				"DRQ %x %x\n",
@@ -731,6 +730,7 @@ lpfc_rq_buf_free(struct lpfc_hba *phba,
 				rqb_entry->hrq->entry_count,
 				rqb_entry->drq->host_index,
 				rqb_entry->drq->hba_index);
+		(rqbp->rqb_free_buffer)(phba, rqb_entry);
 	} else {
 		list_add_tail(&rqb_entry->hbuf.list, &rqbp->rqb_buffer_list);
 		rqbp->buffer_count++;


