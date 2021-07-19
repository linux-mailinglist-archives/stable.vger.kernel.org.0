Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C563CE024
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345615AbhGSPOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345370AbhGSPNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:13:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0812360FD7;
        Mon, 19 Jul 2021 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709982;
        bh=XTrAhiCQBgv6zHFyOrAJmGwSLDcsHJ+tJxlfFIqk2VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/GTjhXxUiEldyUplsoQAjvy9IFRAio9cnhg6XGEjfNY6vFFQzx7XaOdme5lJGuc/
         ldiihU9yFmWrU4OqtytuO/8Q+BygQ8xS8lTmsLcqqYjcT+robFGs9RSFEx9HKfLeAA
         ew62bnUgVtDwuoJf4/oSMGn0xOkIAUTLSTFcAnuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ching Huang <ching2048@areca.com.tw>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/243] scsi: arcmsr: Fix the wrong CDB payload report to IOP
Date:   Mon, 19 Jul 2021 16:50:55 +0200
Message-Id: <20210719144941.769904707@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

[ Upstream commit 5b8644968d2ca85abb785e83efec36934974b0c2 ]

This patch fixes the wrong CDB payload report to IOP.

Link: https://lore.kernel.org/r/d2c97df3c817595c6faf582839316209022f70da.camel@areca.com.tw
Signed-off-by: ching Huang <ching2048@areca.com.tw>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e4fdb473b990..4838f790dac7 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1928,8 +1928,12 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 
 		if (ccb->arc_cdb_size <= 0x300)
 			arc_cdb_size = (ccb->arc_cdb_size - 1) >> 6 | 1;
-		else
-			arc_cdb_size = (((ccb->arc_cdb_size + 0xff) >> 8) + 2) << 1 | 1;
+		else {
+			arc_cdb_size = ((ccb->arc_cdb_size + 0xff) >> 8) + 2;
+			if (arc_cdb_size > 0xF)
+				arc_cdb_size = 0xF;
+			arc_cdb_size = (arc_cdb_size << 1) | 1;
+		}
 		ccb_post_stamp = (ccb->smid | arc_cdb_size);
 		writel(0, &pmu->inbound_queueport_high);
 		writel(ccb_post_stamp, &pmu->inbound_queueport_low);
-- 
2.30.2



