Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C192639A823
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhFCRNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232620AbhFCRMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC85A61419;
        Thu,  3 Jun 2021 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740218;
        bh=ckN1z2tVaQ1YA+b0uaeb4c69ZdcSbgwlSMC8rFkpyDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYuC7qkbFpzXsU48ud+zONpO5HTDBjx1R/pxgZJKw/13ggHcaGJVm9TuWsAEEfGhd
         ewNfGGxsIgVuRaGEiZOdKZkPosIRHW+VMoOLJR9AEGjkvwM48iKksVzlvhYjTzO94e
         SEglk/nueU5mM1+Fm0IVmTm8nlmF9i+EUHJ/SiUhupr8vMwkQ1in5XeqAx9MzfCu4B
         YNFEHRQbBAq9hXJKQ4oVVnrU6TZ3dqEWAx8NxgBkd/+8fcp6jf5zrXlc46jwAwlDHQ
         4/yF2QBGe1ZAoelk3r3QZ4NEQQ7boWueQ/YQMKsTzvgIWKmAayps/jXGjCc7bWFQGu
         6VeWSa6qr/wkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Wang <wwentao@vmware.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/23] scsi: vmw_pvscsi: Set correct residual data length
Date:   Thu,  3 Jun 2021 13:09:51 -0400
Message-Id: <20210603170959.3169420-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
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
index 64eb8ffb2ddf..2c707b5c7b0b 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -574,7 +574,13 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
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

