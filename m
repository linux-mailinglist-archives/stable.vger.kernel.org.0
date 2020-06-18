Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B575B1FE50F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgFRBSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729891AbgFRBSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1385206F1;
        Thu, 18 Jun 2020 01:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443091;
        bh=8nYM76nMA33YbflA8NpPkoeLy8IEh0EayB8T55DpMXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muCOf/+YF1LTLysOO1wqH0e6H0CKkog9P/VHEzPOiWzg9kktOwBuw7noLuoj43lp2
         1Yzx96qORix3kW6tPqbvSmTkZgyUbh6qAS11ZSHvZbU/Ar2l4b1i4KsXjC70PmgY3M
         c/EQrNarvuaHw0+kdOieCYFagSWjA7Mi9ixGyOmE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Alexander Fomichev <fomichev.ru@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 072/266] NTB: ntb_pingpong: Choose doorbells based on port number
Date:   Wed, 17 Jun 2020 21:13:17 -0400
Message-Id: <20200618011631.604574-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit ca93c45755da98302c93abdd788fc09113baf9e0 ]

This commit fixes pingpong support for existing drivers that do not
implement ntb_default_port_number() and ntb_default_peer_port_number().
This is required for hardware (like the crosslink topology of
switchtec) which cannot assign reasonable port numbers to each port due
to its perfect symmetry.

Instead of picking the doorbell to use based on the the index of the
peer, we use the peer's port number. This is a bit clearer and easier
to understand.

Fixes: c7aeb0afdcc2 ("NTB: ntb_pp: Add full multi-port NTB API support")
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Allen Hubbe <allenbh@gmail.com>
Tested-by: Alexander Fomichev <fomichev.ru@gmail.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_pingpong.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ntb/test/ntb_pingpong.c b/drivers/ntb/test/ntb_pingpong.c
index 65865e460ab8..18d00eec7b02 100644
--- a/drivers/ntb/test/ntb_pingpong.c
+++ b/drivers/ntb/test/ntb_pingpong.c
@@ -121,15 +121,14 @@ static int pp_find_next_peer(struct pp_ctx *pp)
 	link = ntb_link_is_up(pp->ntb, NULL, NULL);
 
 	/* Find next available peer */
-	if (link & pp->nmask) {
+	if (link & pp->nmask)
 		pidx = __ffs64(link & pp->nmask);
-		out_db = BIT_ULL(pidx + 1);
-	} else if (link & pp->pmask) {
+	else if (link & pp->pmask)
 		pidx = __ffs64(link & pp->pmask);
-		out_db = BIT_ULL(pidx);
-	} else {
+	else
 		return -ENODEV;
-	}
+
+	out_db = BIT_ULL(ntb_peer_port_number(pp->ntb, pidx));
 
 	spin_lock(&pp->lock);
 	pp->out_pidx = pidx;
@@ -303,7 +302,7 @@ static void pp_init_flds(struct pp_ctx *pp)
 			break;
 	}
 
-	pp->in_db = BIT_ULL(pidx);
+	pp->in_db = BIT_ULL(lport);
 	pp->pmask = GENMASK_ULL(pidx, 0) >> 1;
 	pp->nmask = GENMASK_ULL(pcnt - 1, pidx);
 
@@ -435,4 +434,3 @@ static void __exit pp_exit(void)
 	debugfs_remove_recursive(pp_dbgfs_topdir);
 }
 module_exit(pp_exit);
-
-- 
2.25.1

