Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8F139A77A
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhFCRLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231937AbhFCRKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E6666140F;
        Thu,  3 Jun 2021 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740141;
        bh=o4gimoPiJ3bHPHqjEjBBHmZXwQuE/CmhBTkx++jA4UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXONNjLanBra464mQegDga8WhXbW2lYHu4dC/E7wR/ovrHub2na4lXiBV2FKtjIPq
         prFnGjByAjnR3k+5yN+2MmH8g5j99q4KIgY1pRoNILOSLN/NFOlYEu/eRxOkatsqA+
         IqeDxuRZhEvW0nWnRfFoI3u4rdegk5gHuat/GiVmTWSLu4UTjgMfm2I8uD4G28g7+a
         X3/UhmJwmSwpALbGOETRDdUNZlY4QYEuO3NWslmb+Hofcijh8JnCkFLRPaOgGLQW9b
         9190VBOHGV3cEd+9voaPOj7GrYKYHNUyZx8sI8GsAsUo84yeCklUnyFBTRxcJSivHT
         PibyzPX+pZeGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Wang <wwentao@vmware.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/39] scsi: vmw_pvscsi: Set correct residual data length
Date:   Thu,  3 Jun 2021 13:08:16 -0400
Message-Id: <20210603170829.3168708-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Wang <wwentao@vmware.com>

[ Upstream commit e662502b3a782d479e67736a5a1c169a703d853a ]

Some commands (such as INQUIRY) may return less data than the initiator
requested. To avoid conducting useless information, set the right residual
count to make upper layer aware of this.

Before (INQUIRY PAGE 0xB0 with 128B buffer):

$ sg_raw -r 128 /dev/sda 12 01 B0 00 80 00
SCSI Status: Good

Received 128 bytes of data:
 00 00 b0 00 3c 01 00 00 00 00 00 00 00 00 00 00 00 ...<............
 10 00 00 00 00 00 01 00 00 00 00 00 40 00 00 08 00 ...........@....
 20 80 00 00 00 00 00 00 00 00 00 20 00 00 00 00 00 .......... .....
 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 60 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................

After:

$ sg_raw -r 128 /dev/sda 12 01 B0 00 80 00
SCSI Status: Good

Received 64 bytes of data:
00 00 b0 00 3c 01 00 00 00 00 00 00 00 00 00 00 00 ...<............
10 00 00 00 00 00 01 00 00 00 00 00 40 00 00 08 00 ...........@....
20 80 00 00 00 00 00 00 00 00 00 20 00 00 00 00 00 .......... .....
30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................

[mkp: clarified description]

Link: https://lore.kernel.org/r/03C41093-B62E-43A2-913E-CFC92F1C70C3@vmware.com
Signed-off-by: Matt Wang <wwentao@vmware.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/vmw_pvscsi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 081f54ab7d86..1421b1394d81 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -587,7 +587,13 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		case BTSTAT_SUCCESS:
 		case BTSTAT_LINKED_COMMAND_COMPLETED:
 		case BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG:
-			/* If everything went fine, let's move on..  */
+			/*
+			 * Commands like INQUIRY may transfer less data than
+			 * requested by the initiator via bufflen. Set residual
+			 * count to make upper layer aware of the actual amount
+			 * of data returned.
+			 */
+			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
 			cmd->result = (DID_OK << 16);
 			break;
 
-- 
2.30.2

