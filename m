Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D51F12F010
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgABWYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:24:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgABWYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:24:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1BF22525;
        Thu,  2 Jan 2020 22:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003882;
        bh=rQyn/dukZa52J32/ZHdpEc/Ep4F9wGgPq1o6z9Vhpgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jH03mk0HZKUzK1CjOAzc68ch8TXUOw2XsWP8+Vzs8TEtfDhgfUAX6DRaaZ9SrpdW3
         j9pjWDb+yyZSHIaQ3dPD62Rtq9XP83bJAnlyRLnbdwVHnG5qPI5JBO4aP536i1EDLI
         OoVf6Eh6dCHrb56+5Ua5eNE48q5mqAsW1WEoubBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/91] scsi: NCR5380: Add disconnect_mask module parameter
Date:   Thu,  2 Jan 2020 23:07:21 +0100
Message-Id: <20200102220433.555468797@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
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
index 21377ac71168..79b0b4eece19 100644
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
@@ -946,7 +949,8 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
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



