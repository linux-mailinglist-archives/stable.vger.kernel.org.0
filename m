Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540591AC335
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898017AbgDPNjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897889AbgDPNju (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E1FF20732;
        Thu, 16 Apr 2020 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044390;
        bh=MkPs644BC6fRZVf3njDdZwqWGc69xsas9A4iun9REXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umKpHyzCFo6s2TtmmIT2+kL1IpsPXmmhYbO5JMpL/Y4wpB7lFKrqVjreePl0Gfxxq
         /V3+33jLwgdOmLBvMPSprd9ACnltmCyZ/k9xV39Dq9obtAEFAq4vO29bCP9pf7UzKo
         P75VyzEnODmSdVbJ+ZZlx6XgxwgZBFht/oErSQtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.5 197/257] scsi: lpfc: Fix lpfc_io_buf resource leak in lpfc_get_scsi_buf_s4 error path
Date:   Thu, 16 Apr 2020 15:24:08 +0200
Message-Id: <20200416131350.797787837@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 0ab384a49c548baf132ccef249f78d9c6c506380 upstream.

If a call to lpfc_get_cmd_rsp_buf_per_hdwq returns NULL (memory allocation
failure), a previously allocated lpfc_io_buf resource is leaked.

Fix by releasing the lpfc_io_buf resource in the failure path.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://lore.kernel.org/r/20200128002312.16346-3-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_scsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -671,8 +671,10 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *ph
 	lpfc_cmd->prot_data_type = 0;
 #endif
 	tmp = lpfc_get_cmd_rsp_buf_per_hdwq(phba, lpfc_cmd);
-	if (!tmp)
+	if (!tmp) {
+		lpfc_release_io_buf(phba, lpfc_cmd, lpfc_cmd->hdwq);
 		return NULL;
+	}
 
 	lpfc_cmd->fcp_cmnd = tmp->fcp_cmnd;
 	lpfc_cmd->fcp_rsp = tmp->fcp_rsp;


