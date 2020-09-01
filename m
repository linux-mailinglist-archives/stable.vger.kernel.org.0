Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03117259332
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgIAPWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729436AbgIAPW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:22:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7FC02078B;
        Tue,  1 Sep 2020 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973748;
        bh=LTpcdGUdrNMBt0bBiTpjmc6wBB+nuNBOZ7692tTaEh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0Han/akQCtphMXFEvnpRKCB1TUS/yxqyoASfj4+a/L8WbyiOlQaPJ+Q6GH9TzJKW
         DUwrpwaU4EqkDHYY6U6TyjiuIY/76695WRacLrU/3iwX9B2v+wHJBQ/E+a0ZcztfH8
         uT/PmJnx2BXLZOqxYu/UXlfgKrXz45mdtIAPGiaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 005/125] net/smc: Prevent kernel-infoleak in __smc_diag_dump()
Date:   Tue,  1 Sep 2020 17:09:20 +0200
Message-Id: <20200901150934.850085928@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit ce51f63e63c52a4e1eee4dd040fb0ba0af3b43ab ]

__smc_diag_dump() is potentially copying uninitialized kernel stack memory
into socket buffers, since the compiler may leave a 4-byte hole near the
beginning of `struct smcd_diag_dmbinfo`. Fix it by initializing `dinfo`
with memset().

Fixes: 4b1b7d3b30a6 ("net/smc: add SMC-D diag support")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_diag.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -169,13 +169,15 @@ static int __smc_diag_dump(struct sock *
 	    (req->diag_ext & (1 << (SMC_DIAG_DMBINFO - 1))) &&
 	    !list_empty(&smc->conn.lgr->list)) {
 		struct smc_connection *conn = &smc->conn;
-		struct smcd_diag_dmbinfo dinfo = {
-			.linkid = *((u32 *)conn->lgr->id),
-			.peer_gid = conn->lgr->peer_gid,
-			.my_gid = conn->lgr->smcd->local_gid,
-			.token = conn->rmb_desc->token,
-			.peer_token = conn->peer_token
-		};
+		struct smcd_diag_dmbinfo dinfo;
+
+		memset(&dinfo, 0, sizeof(dinfo));
+
+		dinfo.linkid = *((u32 *)conn->lgr->id);
+		dinfo.peer_gid = conn->lgr->peer_gid;
+		dinfo.my_gid = conn->lgr->smcd->local_gid;
+		dinfo.token = conn->rmb_desc->token;
+		dinfo.peer_token = conn->peer_token;
 
 		if (nla_put(skb, SMC_DIAG_DMBINFO, sizeof(dinfo), &dinfo) < 0)
 			goto errout;


