Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919712E663E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbgL1QK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388502AbgL1NXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2169F2076D;
        Mon, 28 Dec 2020 13:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161769;
        bh=kXatvd0LB7r0bOcjSPbIsLV3aBOO4tv3Dav2cq4MBU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9toC3O3egftnu4NllRgH8Al68UHQM7lrfUt/tMdAxv9dkAoHKcAJYUKQL/Ss4swj
         mlQ3UcaHw3qI58gWg0Cyg++R2dQkZX9hqPeS56AGKeyGuKBZi+MmHxYQT1IVF/oN2Y
         W+9NMiiWDyL/3+ciAXqIqWQ2Lq6TS2nM2nrPQApc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/346] scsi: mpt3sas: Increase IOCInit request timeout to 30s
Date:   Mon, 28 Dec 2020 13:46:34 +0100
Message-Id: <20201228124923.424450811@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 85dad327d9b58b4c9ce08189a2707167de392d23 ]

Currently the IOCInit request message timeout is set to 10s. This is not
sufficient in some scenarios such as during HBA FW downgrade operations.

Increase the IOCInit request timeout to 30s.

Link: https://lore.kernel.org/r/20201130082733.26120-1-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9fbe20e38ad07..07959047d4dc4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5771,7 +5771,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 
 	r = _base_handshake_req_reply_wait(ioc,
 	    sizeof(Mpi2IOCInitRequest_t), (u32 *)&mpi_request,
-	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 10);
+	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 30);
 
 	if (r != 0) {
 		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n",
-- 
2.27.0



