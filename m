Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956FB73926
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389433AbfGXThV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389202AbfGXThU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 082A1229F4;
        Wed, 24 Jul 2019 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997039;
        bh=eafawqtvtT/Z9ZKNJ7ZvmhbWCM0RJA1U0SNZNUhjf7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAjAzfLBYEdg/KNaQdHadNF9BvYYTI2nk7SFR+DoI4wAnXuEJNTA/ZostxpQmELFo
         5LXwypuxUeXLdPAC8Subn4FWlX0bFMOgZGTPHW0TXHU0DRMhAXSO/aU46f9toEkP/B
         PTi64Xy67svJZa48OvwxPzsAAgC9PMcBDwc12vgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.2 261/413] scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
Date:   Wed, 24 Jul 2019 21:19:12 +0200
Message-Id: <20190724191754.767562687@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit 7398cee4c3e6aea1ba07a6449e5533ecd0b92cdd upstream.

Some targets introduce delays when handshaking the response to certain
commands. For example, a disk may send a 96-byte response to an INQUIRY
command (or a 24-byte response to a MODE SENSE command) too slowly.

Apparently the first 12 or 14 bytes are handshaked okay but then the system
bus error timeout is reached while transferring the next word.

Since the scsi bus phase hasn't changed, the driver then sets the target
borken flag to prevent further PDMA transfers. The driver also logs the
warning, "switching to slow handshake".

Raise the PDMA threshold to 512 bytes so that PIO transfers will be used
for these commands. This default is sufficiently low that PDMA will still
be used for READ and WRITE commands.

The existing threshold (16 bytes) was chosen more or less at random.
However, best performance requires the threshold to be as low as possible.
Those systems that don't need the PIO workaround at all may benefit from
mac_scsi.setup_use_pdma=1

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@vger.kernel.org # v4.14+
Fixes: 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mac_scsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -53,7 +53,7 @@ static int setup_cmd_per_lun = -1;
 module_param(setup_cmd_per_lun, int, 0);
 static int setup_sg_tablesize = -1;
 module_param(setup_sg_tablesize, int, 0);
-static int setup_use_pdma = -1;
+static int setup_use_pdma = 512;
 module_param(setup_use_pdma, int, 0);
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
@@ -306,7 +306,7 @@ static int macscsi_dma_xfer_len(struct N
                                 struct scsi_cmnd *cmd)
 {
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
-	    cmd->SCp.this_residual < 16)
+	    cmd->SCp.this_residual < setup_use_pdma)
 		return 0;
 
 	return cmd->SCp.this_residual;


