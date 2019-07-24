Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B38273ADC
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404376AbfGXTyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404391AbfGXTyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A8620665;
        Wed, 24 Jul 2019 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998077;
        bh=UuliqgOTkTmntToZ81rjcCYcGZUswTVPwrY3Yz1BCyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s99iBXyYU7W8sojo8Li4zpiEyOJKVSTOMXHjc+F0DC+Wbv3RxXz/QiVP+UhTOxvsm
         8Mh5A2z7XVbhM5bF3cvhNGjApCt+srmHTDWBCsS6REy4L2sroX+6ufU7sx8lzQMlQL
         63PtKIptptRM2OOb19HlYXmz8Z4KSU65ay7IulxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 237/371] scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
Date:   Wed, 24 Jul 2019 21:19:49 +0200
Message-Id: <20190724191742.440000731@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
@@ -52,7 +52,7 @@ static int setup_cmd_per_lun = -1;
 module_param(setup_cmd_per_lun, int, 0);
 static int setup_sg_tablesize = -1;
 module_param(setup_sg_tablesize, int, 0);
-static int setup_use_pdma = -1;
+static int setup_use_pdma = 512;
 module_param(setup_use_pdma, int, 0);
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
@@ -305,7 +305,7 @@ static int macscsi_dma_xfer_len(struct N
                                 struct scsi_cmnd *cmd)
 {
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
-	    cmd->SCp.this_residual < 16)
+	    cmd->SCp.this_residual < setup_use_pdma)
 		return 0;
 
 	return cmd->SCp.this_residual;


