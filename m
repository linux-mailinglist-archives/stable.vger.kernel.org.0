Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC9ABF475A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390240AbfKHLtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387417AbfKHLr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8FC422459;
        Fri,  8 Nov 2019 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213678;
        bh=YWaFJwHRcxWDbhkR+hZxM1T/r643o/UQYp0ATZ5LpZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKPCLvRAg5Wnkfe0+eEsLHruh+n1jR+kdPBiNyaq4iICIacjJvoPVE0xoK4f6zzz+
         W1yp7YuejDOJ0wpo0urt4uVcuaLHPxzD9Kuu6ibPaIoNVwtyjdF/wlyWi5gAX39ok+
         DDLz1eutQyIRVIB26OzIpvh1r7an8Tf5Yue0paf4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Matthew Wilcox <matthew.wilcox@oracle.com>,
        Mark Kanda <mark.kanda@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 28/44] scsi: sym53c8xx: fix NULL pointer dereference panic in sym_int_sir()
Date:   Fri,  8 Nov 2019 06:47:04 -0500
Message-Id: <20191108114721.15944-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c6425e3df5a04..f1c7714377524 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4371,6 +4371,13 @@ static void sym_nego_rejected(struct sym_hcb *np, struct sym_tcb *tp, struct sym
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
@@ -4416,7 +4423,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  been selected with ATN.  We do not want to handle that.
 	 */
 	case SIR_SEL_ATN_NO_MSG_OUT:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No MSG OUT phase after selection with ATN\n");
 		goto out_stuck;
 	/*
@@ -4424,7 +4431,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  having reselected the initiator.
 	 */
 	case SIR_RESEL_NO_MSG_IN:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No MSG IN phase after reselection\n");
 		goto out_stuck;
 	/*
@@ -4432,7 +4439,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  an IDENTIFY.
 	 */
 	case SIR_RESEL_NO_IDENTIFY:
-		scmd_printk(KERN_WARNING, cp->cmd,
+		sym_printk(KERN_WARNING, tp, cp,
 				"No IDENTIFY after reselection\n");
 		goto out_stuck;
 	/*
@@ -4461,7 +4468,7 @@ static void sym_int_sir(struct sym_hcb *np)
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

