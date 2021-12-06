Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F91C469EC8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355787AbhLFPoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389912AbhLFPlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:41:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE461C0698C2;
        Mon,  6 Dec 2021 07:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58D0F6130D;
        Mon,  6 Dec 2021 15:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4D2C34901;
        Mon,  6 Dec 2021 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804327;
        bh=O5wlqANaYG7YsUrtQsPqSbHvWTC9EtfJhH5Q2iHyJRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gk0Y/oPxrV+4+4n8rWETAB/dPTnYxxpWJUp+ldikw6Id+19NDbOALMv+G9B8It4oV
         QLjj2mv3CKKSBETyNNT4BePgEpKt9YOnC/l723UckzFfxuXwMn70N7L85VbNjQWAD9
         NccfLYKga61YniIJdBI7z13RJV7LU7SeTfIt09KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Ely <paul.ely@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 065/207] scsi: lpfc: Fix non-recovery of remote ports following an unsolicited LOGO
Date:   Mon,  6 Dec 2021 15:55:19 +0100
Message-Id: <20211206145612.489419621@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 0956ba63bd94355bf38cd40f7eb9104577739ab8 upstream.

A commit introduced formal regstration of all Fabric nodes to the SCSI
transport as well as REG/UNREG RPI mailbox requests. The commit introduced
the NLP_RELEASE_RPI flag for rports set in the lpfc_cmpl_els_logo_acc()
routine to help clean up the RPIs. This new code caused the driver to
release the RPI value used for the remote port and marked the RPI invalid.
When the driver later attempted to re-login, it would use the invalid RPI
and the adapter rejected the PLOGI request.  As no login occurred, the
devloss timer on the rport expired and connectivity was lost.

This patch corrects the code by removing the snippet that requests the rpi
to be unregistered. This change only occurs on a node that is already
marked to be rediscovered. This puts the code back to its original
behavior, preserving the already-assigned rpi value (registered or not)
which can be used on the re-login attempts.

Link: https://lore.kernel.org/r/20211123165646.62740-1-jsmart2021@gmail.com
Fixes: fe83e3b9b422 ("scsi: lpfc: Fix node handling for Fabric Controller and Domain Controller")
Cc: <stable@vger.kernel.org> # v5.14+
Co-developed-by: Paul Ely <paul.ely@broadcom.com>
Signed-off-by: Paul Ely <paul.ely@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_els.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5075,14 +5075,9 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 		/* NPort Recovery mode or node is just allocated */
 		if (!lpfc_nlp_not_used(ndlp)) {
 			/* A LOGO is completing and the node is in NPR state.
-			 * If this a fabric node that cleared its transport
-			 * registration, release the rpi.
+			 * Just unregister the RPI because the node is still
+			 * required.
 			 */
-			spin_lock_irq(&ndlp->lock);
-			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
-			if (phba->sli_rev == LPFC_SLI_REV4)
-				ndlp->nlp_flag |= NLP_RELEASE_RPI;
-			spin_unlock_irq(&ndlp->lock);
 			lpfc_unreg_rpi(vport, ndlp);
 		} else {
 			/* Indicate the node has already released, should


