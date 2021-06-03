Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE1F39A7B0
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhFCRMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232231AbhFCRL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F603613F1;
        Thu,  3 Jun 2021 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740182;
        bh=UFy/fNZZcXDiSUPifrg7RaZsPbIx8W3OHjSscJM5XlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=il4SVFmUVwrHXf5tnv+NyoIgOplmPLOIwc2ZYWAuqrAVKwPYJFN7/0cI0wj5CLLtV
         9qwie0FruoBT55iGAmCe8InVPORu/jaUxb7nmfF2OeME7m9HIgVXFZcFSctExGtWUH
         J+0LM7plD2OaBtd7qT0q7w6YER3RfCcmnWRruMZImzF9KkJZiurpImvaEmUbZblcr9
         hRa6q93+z3LN6e+/DaAEo8PAMSWUFttLgEOk/RVJVXSma5T93PntN6zDrNLCyw05M3
         ReQ4OTVOPHuMx46GWv9nUenQqu6abR9886g6UIugdF37avRxLsVRQ+9Gfnb83LK3t9
         c3GQwWk8VPCTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/31] scsi: bnx2fc: Return failure if io_req is already in ABTS processing
Date:   Thu,  3 Jun 2021 13:09:06 -0400
Message-Id: <20210603170919.3169112-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
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
index 401743e2b429..a0e776414889 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1219,6 +1219,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
+		rc = FAILED;
 		goto done;
 	}
 
-- 
2.30.2

