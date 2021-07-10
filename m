Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739313C2EEB
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhGJC3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233996AbhGJC2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB46B61400;
        Sat, 10 Jul 2021 02:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883903;
        bh=Kr0xudVvbrwiz2B7bAj/y6fZJUNZ7Ay/QCc3GFot3sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Emrz5OwFRY1SjZ7F6Z+QdegdlWkRiZiGjCqo4D6mfeqaHm73YsuIcR0m/iRVzW0nY
         C+04xWlt62fzTvuRAtcbkZj6CYBER68i8ebdUSsAYI+lICKf6bvwfQIR06w9+VQzDp
         4a6G8zlGrZ9/wIEE/OZdF2E6k9fzJAjgvaa1A9eF5VQYfJPz3NMjo6xtITHa86SJhA
         5eJaNF3rfTrVNEwTR5MpKY+60ed4dz2eZRNO8OsuXUV6eVEh2kV9UsZrwpHOS+35Ue
         Ro4rqdImEHFDprXacFXfjwC89YcIxYX0XcHzb7PX0DxWv81pGPg6V/0YIrL+p5qhFz
         iMNGAHnzTGvTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/93] scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs
Date:   Fri,  9 Jul 2021 22:23:20 -0400
Message-Id: <20210710022428.3169839-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 5aa615d195f1e142c662cb2253f057c9baec7531 ]

The driver is encountering a crash in lpfc_free_iocb_list() while
performing initial attachment.

Code review found this to be an errant failure path that was taken, jumping
to a tag that then referenced structures that were uninitialized.

Fix the failure path.

Link: https://lore.kernel.org/r/20210514195559.119853-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bf171ef61abd..990b700de689 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7825,7 +7825,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_destroy_queue;
+		goto out_free_iocblist;
 	}
 	lpfc_sli4_node_prep(phba);
 
@@ -7991,8 +7991,9 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 out_unset_queue:
 	/* Unset all the queues set up in this routine when error out */
 	lpfc_sli4_queue_unset(phba);
-out_destroy_queue:
+out_free_iocblist:
 	lpfc_free_iocb_list(phba);
+out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
 out_stop_timers:
 	lpfc_stop_hba_timers(phba);
-- 
2.30.2

