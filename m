Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B2B1670E7
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgBUHt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729312AbgBUHt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:49:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71528222C4;
        Fri, 21 Feb 2020 07:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271365;
        bh=8uG1pKmllG6vODb9BHuyO83kQ55D5RpViPviNkzTLOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRggCb4JlBR5bZ+U6V6q6EcztkCXqR5suHjwNqZ7KVYzp14/243Y9QYoUCAbzae0v
         vPywCf9r8zYxkpR4BoTCxUiG3urs1Lo8RukZz5qIFd+oyOpzGEQoEHWPIl+3+5kXY5
         fDlbMTDAHCgMSDKg7FWxnoyzXlDv8prTIKMJ2zcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 138/399] Revert "nfp: abm: fix memory leak in nfp_abm_u32_knode_replace"
Date:   Fri, 21 Feb 2020 08:37:43 +0100
Message-Id: <20200221072415.890374003@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 1d1997db870f4058676439ef7014390ba9e24eb2 ]

This reverts commit 78beef629fd9 ("nfp: abm: fix memory leak in
nfp_abm_u32_knode_replace").

The quoted commit does not fix anything and resulted in a bogus
CVE-2019-19076.

If match is NULL then it is known there is no matching entry in
list, hence, calling nfp_abm_u32_knode_delete() is pointless.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/abm/cls.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 9f8a1f69c0c4c..23ebddfb95325 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -176,10 +176,8 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 	u8 mask, val;
 	int err;
 
-	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack)) {
-		err = -EOPNOTSUPP;
+	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
 		goto err_delete;
-	}
 
 	tos_off = proto == htons(ETH_P_IP) ? 16 : 20;
 
@@ -200,18 +198,14 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 		if ((iter->val & cmask) == (val & cmask) &&
 		    iter->band != knode->res->classid) {
 			NL_SET_ERR_MSG_MOD(extack, "conflict with already offloaded filter");
-			err = -EOPNOTSUPP;
 			goto err_delete;
 		}
 	}
 
 	if (!match) {
 		match = kzalloc(sizeof(*match), GFP_KERNEL);
-		if (!match) {
-			err = -ENOMEM;
-			goto err_delete;
-		}
-
+		if (!match)
+			return -ENOMEM;
 		list_add(&match->list, &alink->dscp_map);
 	}
 	match->handle = knode->handle;
@@ -227,7 +221,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 
 err_delete:
 	nfp_abm_u32_knode_delete(alink, knode);
-	return err;
+	return -EOPNOTSUPP;
 }
 
 static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
-- 
2.20.1



