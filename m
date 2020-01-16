Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F2D13E07F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgAPQnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgAPQnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:43:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 142C62073A;
        Thu, 16 Jan 2020 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193030;
        bh=ULJTcAxwoARXlpJOWHSH7MmtTYHkEJ913MW2/8esPOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TGtmhZYf3mtIEfF9EkDrifxVcvC9EAera8/l3yrSCHwKugZdt+AECe3uJNfZNezl
         EfLWNvNmmVPrl90lo+uYudyg7TGsoL2wwlQb4lG2PiYJ2IhGkiDWLsI6Y6F9YkxTzd
         brlcx3RyIKfV3m5h9dvWSDSSM2C/BokEzdD0rJns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 010/205] RDMA/siw: Fix port number endianness in a debug message
Date:   Thu, 16 Jan 2020 11:39:45 -0500
Message-Id: <20200116164300.6705-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 050dbddf249eee3e936b5734c30b2e1b427efdc3 ]

sin_port and sin6_port are big endian member variables. Convert these port
numbers into CPU endianness before printing.

Link: https://lore.kernel.org/r/20190930231707.48259-5-bvanassche@acm.org
Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 8c1931a57f4a..0454561718d9 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1867,14 +1867,7 @@ static int siw_listen_address(struct iw_cm_id *id, int backlog,
 	list_add_tail(&cep->listenq, (struct list_head *)id->provider_data);
 	cep->state = SIW_EPSTATE_LISTENING;
 
-	if (addr_family == AF_INET)
-		siw_dbg(id->device, "Listen at laddr %pI4 %u\n",
-			&(((struct sockaddr_in *)laddr)->sin_addr),
-			((struct sockaddr_in *)laddr)->sin_port);
-	else
-		siw_dbg(id->device, "Listen at laddr %pI6 %u\n",
-			&(((struct sockaddr_in6 *)laddr)->sin6_addr),
-			((struct sockaddr_in6 *)laddr)->sin6_port);
+	siw_dbg(id->device, "Listen at laddr %pISp\n", laddr);
 
 	return 0;
 
-- 
2.20.1

