Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5618412EC20
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgABWPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgABWPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D27022253D;
        Thu,  2 Jan 2020 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003330;
        bh=pVH6vZUHOHmuRy5b9/9ywEGujaMn0AGPx/PiZP3z584=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSxB4ljYcV6B1hfOIJ21Bt/eEpWemR9ce3DvMgdIe70eIyfz5bKZcb25CSCJBA9nU
         /bQuCCgamjKvex7sBuKNLTFvxbbB3reZaOfy7vpGgowfLY2nFVP8RLlfNZMk9H4+6z
         1PrLlnDBYCLgDyxFAA1+bv2xEomUI2m+JpWEdREk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/191] scsi: NCR5380: Add disconnect_mask module parameter
Date:   Thu,  2 Jan 2020 23:06:12 +0100
Message-Id: <20200102215839.589228403@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 0b7a223552d455bcfba6fb9cfc5eef2b5fce1491 ]

Add a module parameter to inhibit disconnect/reselect for individual
targets. This gains compatibility with Aztec PowerMonster SCSI/SATA
adapters with buggy firmware. (No fix is available from the vendor.)

Apparently these adapters pass-through the product/vendor of the attached
SATA device. Since they can't be identified from the response to an INQUIRY
command, a device blacklist flag won't work.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Link: https://lore.kernel.org/r/993b17545990f31f9fa5a98202b51102a68e7594.1573875417.git.fthain@telegraphics.com.au
Reviewed-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 536426f25e86..d4401c768a0c 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -129,6 +129,9 @@
 #define NCR5380_release_dma_irq(x)
 #endif
 
+static unsigned int disconnect_mask = ~0;
+module_param(disconnect_mask, int, 0444);
+
 static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 static void bus_reset_cleanup(struct Scsi_Host *);
@@ -954,7 +957,8 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	int err;
 	bool ret = true;
 	bool can_disconnect = instance->irq != NO_IRQ &&
-			      cmd->cmnd[0] != REQUEST_SENSE;
+			      cmd->cmnd[0] != REQUEST_SENSE &&
+			      (disconnect_mask & BIT(scmd_id(cmd)));
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
-- 
2.20.1



