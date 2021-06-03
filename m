Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B900739A754
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhFCRLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhFCRKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8EDE61406;
        Thu,  3 Jun 2021 17:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740140;
        bh=d/WeDXI2SiQXWsZKkAp0Kn29WO4HKxpw5LZgqRdHHTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZEpno54BNIhvJPiKQfCSRxcd2yYAa6KAyCX/Qi853XeR9ta9gU9+CsVsLFstqBGO
         4fkAfDtUdHxLUzn0FRv4SNM6WXeAnax1vH4TDX1fSEPa0VV6psNn9RskQvNnecR5tP
         UPvVLh66enVnrpZB5I5Q5pSr+2SgEt4SoMbP/6OiMrSLLhyGoRpHR1IzL/h3mUFg6b
         Wc/FS3IHM8DFvtx/XVkpmtjloOea/AutYAjefBIz7X+zjohByrooP7fg9lhqYbuDeC
         OZvWSz8L4wAJicb8rPw+mXUWqnuZs7Zpn67mDCXAh/5cOBn7zvu0kYL1wSkbxr9k1o
         J4iBxO1gHgICw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/39] scsi: bnx2fc: Return failure if io_req is already in ABTS processing
Date:   Thu,  3 Jun 2021 13:08:15 -0400
Message-Id: <20210603170829.3168708-25-sashal@kernel.org>
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

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 122c81c563b0c1c6b15ff76a9159af5ee1f21563 ]

Return failure from bnx2fc_eh_abort() if io_req is already in ABTS
processing.

Link: https://lore.kernel.org/r/20210519061416.19321-1-jhasan@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 1a0dc18d6915..ed300a279a38 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1220,6 +1220,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
+		rc = FAILED;
 		goto done;
 	}
 
-- 
2.30.2

