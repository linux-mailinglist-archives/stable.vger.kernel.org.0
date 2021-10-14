Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A71142DD17
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhJNPES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhJNPC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7128A6120F;
        Thu, 14 Oct 2021 14:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223587;
        bh=aGOnUBHLb20hAk4lSyQ9SzgWzY4izXOZWquFtK10FCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6hTilY6OFBvmHujCy6a+6qPTHc/U1/3qMhf0Y459+ggrUi6H56nwCkiuz+Ms7J+x
         WKCifd4hN5vTXZ1Mggcb3mOQVnnROz/RRm8s/HVCNng3rRkgfmo8ak1PGNylXwi+ji
         4Oe9F3TH5nfXFdMikUNCq9Is355c6T9uvlICMWbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, MichelleJin <shjy180909@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/22] mac80211: check return value of rhashtable_init
Date:   Thu, 14 Oct 2021 16:54:20 +0200
Message-Id: <20211014145208.449669879@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: MichelleJin <shjy180909@gmail.com>

[ Upstream commit 111461d573741c17eafad029ac93474fa9adcce0 ]

When rhashtable_init() fails, it returns -EINVAL.
However, since error return value of rhashtable_init is not checked,
it can cause use of uninitialized pointers.
So, fix unhandled errors of rhashtable_init.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
Link: https://lore.kernel.org/r/20210927033457.1020967-4-shjy180909@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 620ecf922408..870c8eafef92 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -60,7 +60,10 @@ static struct mesh_table *mesh_table_alloc(void)
 	atomic_set(&newtbl->entries,  0);
 	spin_lock_init(&newtbl->gates_lock);
 	spin_lock_init(&newtbl->walk_lock);
-	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
+	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params)) {
+		kfree(newtbl);
+		return NULL;
+	}
 
 	return newtbl;
 }
-- 
2.33.0



