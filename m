Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B16B622D3
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389467AbfGHP3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389463AbfGHP3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73CBD20645;
        Mon,  8 Jul 2019 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599762;
        bh=ZhZoriRVOKoUzNCa44qcS0t87m2usU1A2Zc/KlAsm/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLuKEMN7FAijYMrVIapVfXz1wsM99ENJcUtFYhuBd6KM8GufbQAUhFtnoZ3mxHXVp
         6Y/M+Ctncv/gzhpP+YVohDENxOgh9sS2lxfG4FsLriq055urykof+D4mn9A+GxrupY
         fRzfn0GXH9zm1Bx1Esx2zRynM4FMb+fv2j0bnFCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 69/90] mac80211: mesh: fix missing unlock on error in table_path_del()
Date:   Mon,  8 Jul 2019 17:13:36 +0200
Message-Id: <20190708150525.831910613@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f2ffff085d287eec499f1fccd682796ad8010303 ]

spin_lock_bh() is used in table_path_del() but rcu_read_unlock()
is used for unlocking. Fix it by using spin_unlock_bh() instead
of rcu_read_unlock() in the error handling case.

Fixes: b4c3fbe63601 ("mac80211: Use linked list instead of rhashtable walk for mesh tables")
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 49a90217622b..ac1f5db52994 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -627,7 +627,7 @@ static int table_path_del(struct mesh_table *tbl,
 	spin_lock_bh(&tbl->walk_lock);
 	mpath = rhashtable_lookup_fast(&tbl->rhead, addr, mesh_rht_params);
 	if (!mpath) {
-		rcu_read_unlock();
+		spin_unlock_bh(&tbl->walk_lock);
 		return -ENXIO;
 	}
 
-- 
2.20.1



