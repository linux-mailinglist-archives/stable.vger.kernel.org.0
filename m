Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F9528AEA
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387805AbfEWTuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387761AbfEWTKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:10:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FDC02133D;
        Thu, 23 May 2019 19:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638618;
        bh=ZTTP0gwEBPyt/TXYf39wS6QBb+8M2TbhXa5uHJCmQ98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCYqOlFYDbK+0QaW+O4WN23ooMs+wQIAZss3G5mKjzIZnEJ12Pkhz3nkap14pZWoh
         N8Yz18eTXXEqvu4PqzXMg0DwavQjOQkW3PsKtkhGXdTulUcBR2Dt//tfBWAkgjA4vS
         tmEBOhnjXAJBHDP1GkwSM9NWcDiZv6r+dfRKPlbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 46/53] mac80211: Fix kernel panic due to use of txq after free
Date:   Thu, 23 May 2019 21:06:10 +0200
Message-Id: <20190523181718.277434816@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f1267cf3c01b12e0f843fb6a7450a7f0b2efab8a ]

The txq of vif is added to active_txqs list for ATF TXQ scheduling
in the function ieee80211_queue_skb(), but it was not properly removed
before freeing the txq object. It was causing use after free of the txq
objects from the active_txqs list, result was kernel panic
due to invalid memory access.

Fix kernel invalid memory access by properly removing txq object
from active_txqs list before free the object.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5768560cbfc3e..ad03331ee7855 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1937,6 +1937,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
+	if (sdata->vif.txq)
+		ieee80211_txq_purge(sdata->local, to_txq_info(sdata->vif.txq));
+
 	synchronize_rcu();
 
 	if (sdata->dev) {
-- 
2.20.1



