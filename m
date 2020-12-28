Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0CB2E387C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgL1NLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbgL1NKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D138208BA;
        Mon, 28 Dec 2020 13:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161030;
        bh=tAIYs5Fs+P/1M+IOkkbEFCUOHkgLbpdXy4FPgTenYrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrGeOZLKGonQxBnHt2D5+w8jRE6KQPKPIbmDjvxe75XtVQ4Jj4hjqJcwJDoz8YFCN
         +Zj9UPzoTJePemHkp8l2hOvwRiB0qlwElM222taVENykQoCeIkQiyfVF0x29IMT0+V
         LdegXTNVoObxjsYkBuX7murDSYIQEJJKlsdb7D38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/242] scsi: mpt3sas: Increase IOCInit request timeout to 30s
Date:   Mon, 28 Dec 2020 13:47:31 +0100
Message-Id: <20201228124906.946349904@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index 556971c5f0b0e..20bf1fa7f2733 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4575,7 +4575,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 
 	r = _base_handshake_req_reply_wait(ioc,
 	    sizeof(Mpi2IOCInitRequest_t), (u32 *)&mpi_request,
-	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 10);
+	    sizeof(Mpi2IOCInitReply_t), (u16 *)&mpi_reply, 30);
 
 	if (r != 0) {
 		pr_err(MPT3SAS_FMT "%s: handshake failed (r=%d)\n",
-- 
2.27.0



