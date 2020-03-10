Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E131C17F944
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgCJMzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729464AbgCJMzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E11D2253D;
        Tue, 10 Mar 2020 12:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844908;
        bh=NZ49wwYDeg2PY3gkg8I6UFOUVvSsMiuVd2jD2U2htRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6k5Nlh0U/Ovqqm7Q0ZvCG9A9UuDSoH4Oqjg5xyrVPI+mWu1rxm/ksyVSOUqSreYE
         10K5LYGFH8s8P/XxOsFG/tcA+SgtFczpbNCocmgiGPMOLLkaKIVLI89ggK4id9JkKE
         kebRi4E6Zb4A7BJEXYV8687nK15xELs33Bv+swLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Sun <sherry.sun@nxp.com>,
        Borislav Petkov <bp@suse.de>,
        James Morse <james.morse@arm.com>,
        Manish Narani <manish.narani@xilinx.com>
Subject: [PATCH 5.4 164/168] EDAC/synopsys: Do not print an error with back-to-back snprintf() calls
Date:   Tue, 10 Mar 2020 13:40:10 +0100
Message-Id: <20200310123652.161338683@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

commit dfc6014e3b60713f375d0601d7549eed224c4615 upstream.

handle_error() currently calls snprintf() a couple of times in
succession to output the message for a CE/UE, therefore overwriting each
part of the message which was formatted with the previous snprintf()
call. As a result, only the part of the message from the last snprintf()
call will be printed.

The simplest and most effective way to fix this problem is to combine
the whole string into one which to supply to a single snprintf() call.

 [ bp: Massage. ]

Fixes: b500b4a029d57 ("EDAC, synopsys: Add ECC support for ZynqMP DDR controller")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: James Morse <james.morse@arm.com>
Cc: Manish Narani <manish.narani@xilinx.com>
Link: https://lkml.kernel.org/r/1582792452-32575-1-git-send-email-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/synopsys_edac.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -479,20 +479,14 @@ static void handle_error(struct mem_ctl_
 		pinf = &p->ceinfo;
 		if (!priv->p_data->quirks) {
 			snprintf(priv->message, SYNPS_EDAC_MSG_SIZE,
-				 "DDR ECC error type:%s Row %d Bank %d Col %d ",
-				  "CE", pinf->row, pinf->bank, pinf->col);
-			snprintf(priv->message, SYNPS_EDAC_MSG_SIZE,
-				 "Bit Position: %d Data: 0x%08x\n",
+				 "DDR ECC error type:%s Row %d Bank %d Col %d Bit Position: %d Data: 0x%08x",
+				 "CE", pinf->row, pinf->bank, pinf->col,
 				 pinf->bitpos, pinf->data);
 		} else {
 			snprintf(priv->message, SYNPS_EDAC_MSG_SIZE,
-				 "DDR ECC error type:%s Row %d Bank %d Col %d ",
-				  "CE", pinf->row, pinf->bank, pinf->col);
-			snprintf(priv->message, SYNPS_EDAC_MSG_SIZE,
-				 "BankGroup Number %d Block Number %d ",
-				 pinf->bankgrpnr, pinf->blknr);
-			snprintf(priv->message, SYNPS_EDAC_MSG_SIZE,
-				 "Bit Position: %d Data: 0x%08x\n",
+				 "DDR ECC error type:%s Row %d Bank %d Col %d BankGroup Number %d Block Number %d Bit Position: %d Data: 0x%08x",
+				 "CE", pinf->row, pinf->bank, pinf->col,
+				 pinf->bankgrpnr, pinf->blknr,
 				 pinf->bitpos, pinf->data);
 		}
 
@@ -509,10 +503,8 @@ static void handle_error(struct mem_ctl_
 				"UE", pinf->row, pinf->bank, pinf->col);
 		} else {
 			snprintf(priv->message, SYNPS_EDAC_MSG_SIZE,
-				 "DDR ECC error type :%s Row %d Bank %d Col %d ",
-				 "UE", pinf->row, pinf->bank, pinf->col);
-			snprintf(priv->message, SYNPS_EDAC_MSG_SIZE,
-				 "BankGroup Number %d Block Number %d",
+				 "DDR ECC error type :%s Row %d Bank %d Col %d BankGroup Number %d Block Number %d",
+				 "UE", pinf->row, pinf->bank, pinf->col,
 				 pinf->bankgrpnr, pinf->blknr);
 		}
 


