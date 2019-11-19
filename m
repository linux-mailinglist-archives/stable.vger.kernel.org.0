Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA6D101837
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfKSFeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:34:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbfKSFeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:34:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE652071B;
        Tue, 19 Nov 2019 05:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141645;
        bh=gCCvBVkAILAOcOS7/TzlqJcSoTC8xurVhYWiXU0UjGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXu0aWITzYHSIzQMTIfwVWcwTcBDQJ7XdyzeGnal6j1pQ4uhGD80Wnbt7bt6GdzjL
         l79lmbLjtDKq8HgVCW6Cc3ip/Ndsnb3Nkvr0jF7RNH2sw1ExE1vExlR2y/Pq6NoV0w
         sRTO4vp4ymfgEcHypHYHwWof8jfZ1vUdGoAuv09g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <matthew.wilcox@oracle.com>,
        George Kennedy <george.kennedy@oracle.com>,
        Mark Kanda <mark.kanda@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 181/422] scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()
Date:   Tue, 19 Nov 2019 06:16:18 +0100
Message-Id: <20191119051410.195287118@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 288315e95264b6355e26609e9dec5dc4563d4ab0 ]

sym_int_sir() in sym_hipd.c does not check the command pointer for NULL before
using it in debug message prints.

Suggested-by: Matthew Wilcox <matthew.wilcox@oracle.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
Acked-by: Matthew Wilcox <matthew.wilcox@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index bd3f6e2d68344..0a2a54517b151 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4370,6 +4370,13 @@ static void sym_nego_rejected(struct sym_hcb *np, struct sym_tcb *tp, struct sym
 	OUTB(np, HS_PRT, HS_BUSY);
 }
 
+#define sym_printk(lvl, tp, cp, fmt, v...) do { \
+	if (cp)							\
+		scmd_printk(lvl, cp->cmd, fmt, ##v);		\
+	else							\
+		starget_printk(lvl, tp->starget, fmt, ##v);	\
+} while (0)
+
 /*
  *  chip exception handler for programmed interrupts.
  */
@@ -4415,7 +4422,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  been selected with ATN.  We do not want to handle that.
 	 */
 	case SIR_SEL_ATN_NO_MSG_OUT:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No MSG OUT phase after selection with ATN\n");
 		goto out_stuck;
 	/*
@@ -4423,7 +4430,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  having reselected the initiator.
 	 */
 	case SIR_RESEL_NO_MSG_IN:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No MSG IN phase after reselection\n");
 		goto out_stuck;
 	/*
@@ -4431,7 +4438,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  an IDENTIFY.
 	 */
 	case SIR_RESEL_NO_IDENTIFY:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No IDENTIFY after reselection\n");
 		goto out_stuck;
 	/*
@@ -4460,7 +4467,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	case SIR_RESEL_ABORTED:
 		np->lastmsg = np->msgout[0];
 		np->msgout[0] = M_NOOP;
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 			"message %x sent on bad reselection\n", np->lastmsg);
 		goto out;
 	/*
-- 
2.20.1



