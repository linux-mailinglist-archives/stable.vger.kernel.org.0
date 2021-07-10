Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC93C3162
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhGJClQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235602AbhGJCji (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3186D61402;
        Sat, 10 Jul 2021 02:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884524;
        bh=wmV8iyBEUoYiuZ5xN6avshIW+jVVIrbNhyw4H0BG0V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNrVQ4yGhdBQEw6OKCizpBYmeHYyxo9Y78awap/7rdv7VVbuRKDJAvVk8EgBQLwcI
         2q8fQh+tIQWQgbEbFmvBHhjQWE/LV7yTIQbMeDbWH0SXq2E87yGQu51uBoYPnidJkX
         kdDWDlXhqUmqClOawZjy0tNP6AND5M/LCz+Q9Uz2UtU7zaSytlb55Whz+YpNegq3yB
         FpeAs1R+rOamJ8LOj4n8pIOvWeykx5XWUoPfAsthZqcFRiQI3EMGdWo6UEMm3xJTUU
         aj1MNZsGDQ85B+z3YctpfdVCKHnO2yywbwLyXDbh75A1Als6Gm6dE14eD1djQl5vOF
         768ZbzkoLqJ5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/33] scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs
Date:   Fri,  9 Jul 2021 22:34:49 -0400
Message-Id: <20210710023516.3172075-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023516.3172075-1-sashal@kernel.org>
References: <20210710023516.3172075-1-sashal@kernel.org>
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
index 27578816d852..20deb6715c36 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7032,7 +7032,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_destroy_queue;
+		goto out_free_iocblist;
 	}
 	lpfc_sli4_node_prep(phba);
 
@@ -7157,8 +7157,9 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
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

