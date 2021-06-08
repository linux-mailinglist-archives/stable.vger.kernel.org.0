Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7BB3A037D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbhFHTRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237376AbhFHTPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5975D613CC;
        Tue,  8 Jun 2021 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178239;
        bh=4bEVfWOBX9Bqwr3rHrdsMVUU1FS/6k6K982NYR/RsDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHbMZCcPyjI+D+4fswxP1ii0dJMFHiQ/u/quAJYvUFz45B1qr5UTJarIiabG/8h2P
         paHhbnFm8cWCS0Q91OajYYKXqTpwO6lo7ySayOewbDkmhxaKgFm9VZ2Nzj2ZO1wxOo
         vrhGHLfvG4+QEvniRrU7SVQeHKxB39OShmDpa1Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.12 129/161] scsi: lpfc: Fix failure to transmit ABTS on FC link
Date:   Tue,  8 Jun 2021 20:27:39 +0200
Message-Id: <20210608175949.808960830@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 696770e72f2b42b92ea0a4a98087fb2ba376417a upstream.

The abort_cmd_ia flag in an abort wqe describes whether an ABTS basic link
service should be transmitted on the FC link or not.  Code added in
lpfc_sli4_issue_abort_iotag() set the abort_cmd_ia flag incorrectly,
surpressing ABTS transmission.

A previous LPFC change to build an abort wqe inverted prior logic that
determined whether an ABTS was to be issued on the FC link.

Revert this logic to its proper state.

Link: https://lore.kernel.org/r/20210528212240.11387-1-jsmart2021@gmail.com
Fixes: db7531d2b377 ("scsi: lpfc: Convert abort handling to SLI-3 and SLI-4 handlers")
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20591,10 +20591,8 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_
 	abtswqe = &abtsiocb->wqe;
 	memset(abtswqe, 0, sizeof(*abtswqe));
 
-	if (lpfc_is_link_up(phba))
+	if (!lpfc_is_link_up(phba))
 		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 1);
-	else
-		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 0);
 	bf_set(abort_cmd_criteria, &abtswqe->abort_cmd, T_XRI_TAG);
 	abtswqe->abort_cmd.rsrvd5 = 0;
 	abtswqe->abort_cmd.wqe_com.abort_tag = xritag;


