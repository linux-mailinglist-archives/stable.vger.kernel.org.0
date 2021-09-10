Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7A7406079
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhIJARb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229964AbhIJAR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D941A61179;
        Fri, 10 Sep 2021 00:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232976;
        bh=mhTzWIjNFHq9WQ8Uq09RIMs5tzXeTdefEArQb3VjoLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMUiZtFeGHgjI2qTfu/hG0dGTAGCRicXMk/zBjGK1/abysukGM9w/lQOnSRt6cp6w
         OEHu9soJ5oAGKxDQWElz8MWmVpeKusag38zSKvvl/FO6ndI3Q0xBV1U2H8uvswj5+K
         E/FmS8UTYzUQZKrPLE2yI1zWnVyggJ9/Ym3//gtfJsozQPWf2nT/TkuEtGOLGEYLU4
         Sw/58KTj+ZHtk/t7Lp/q481zG1Ucm81YUsoUO36UU3itmRZ886Xoj4o9ry83LK1F4j
         S63Qpdk4/UhARwFv9bI5rL2NqNCzKqwj0XP2UEAxAPQTsEgIUGmhMklU47zvY7jksx
         3txCgybXIAxlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 13/99] scsi: lpfc: Fix KASAN slab-out-of-bounds in lpfc_unreg_rpi() routine
Date:   Thu,  9 Sep 2021 20:14:32 -0400
Message-Id: <20210910001558.173296-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit affbe24429410fddf4e50ca456c090ed6d8e05bf ]

In lpfc_offline_prep() an RPI is freed and nlp_rpi set to 0xFFFF before
calling lpfc_unreg_rpi().  Unfortunately, lpfc_unreg_rpi() uses nlp_rpi to
index the sli4_hba.rpi_ids[] array.

In lpfc_offline_prep(), unreg rpi before freeing the rpi.

Link: https://lore.kernel.org/r/20210707184351.67872-12-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9a84a0b06ee0..c4235699a123 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3541,6 +3541,8 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 				spin_lock_irq(&ndlp->lock);
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 				spin_unlock_irq(&ndlp->lock);
+
+				lpfc_unreg_rpi(vports[i], ndlp);
 				/*
 				 * Whenever an SLI4 port goes offline, free the
 				 * RPI. Get a new RPI when the adapter port
@@ -3556,7 +3558,6 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
 					ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
 				}
-				lpfc_unreg_rpi(vports[i], ndlp);
 
 				if (ndlp->nlp_type & NLP_FABRIC) {
 					lpfc_disc_state_machine(vports[i], ndlp,
-- 
2.30.2

