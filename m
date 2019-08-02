Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C2E7F201
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405186AbfHBJoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392027AbfHBJnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA37A206A2;
        Fri,  2 Aug 2019 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738997;
        bh=5rFg4wi4Wf+7WlkU5Qd2u3AW6e6MuHvRLSEIxRwV5Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fx8hrWo4sHfzcNpP0dppfGsaa0iXNaW2p8pOtdomeCmAqH3w400hsLAOSUShwM0Wc
         7i2UpXBThDtOZRmRugIYoIDcC6I1Uh1EkDLN8BHiQDxphBCXb8wH03eozlUVYPIKuy
         qEAFaYIm+Kms22Vtz0xyN9+s3Y2MOsU0mUVmDVSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 077/223] scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
Date:   Fri,  2 Aug 2019 11:35:02 +0200
Message-Id: <20190802092243.877465809@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
@@ -54,7 +54,7 @@ static int setup_cmd_per_lun = -1;
 module_param(setup_cmd_per_lun, int, 0);
 static int setup_sg_tablesize = -1;
 module_param(setup_sg_tablesize, int, 0);
-static int setup_use_pdma = -1;
+static int setup_use_pdma = 512;
 module_param(setup_use_pdma, int, 0);
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
@@ -325,7 +325,7 @@ static int macscsi_dma_xfer_len(struct S
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
-	    cmd->SCp.this_residual < 16)
+	    cmd->SCp.this_residual < setup_use_pdma)
 		return 0;
 
 	return cmd->SCp.this_residual;


