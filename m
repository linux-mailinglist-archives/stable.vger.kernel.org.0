Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162DB42DCDC
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhJNPCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232764AbhJNPBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C23C361184;
        Thu, 14 Oct 2021 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223518;
        bh=gEGYKIOMjySowZ5CHtGQ2IJh4exknbxozB6VcYgt9jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmAi6RyszkurvEFbtf76KKbPoz5UlugXA7yE+HOtCC032NsUcYB8fzoziqE8A3yjp
         g6g7ffc6byxWH23l4mZhwJp4ymLyYxVQ22l91/cY3ju7gJPgnIP4nRwbb69r8QF1WI
         csVAXPbTrMrJHtMO2KT3UEJRFa6sPXQmEZg57AJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, MichelleJin <shjy180909@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/12] mac80211: check return value of rhashtable_init
Date:   Thu, 14 Oct 2021 16:54:07 +0200
Message-Id: <20211014145206.797805715@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
References: <20211014145206.566123760@linuxfoundation.org>
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
index 6dc5f93b1e4d..06b44c3c831a 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -63,7 +63,10 @@ static struct mesh_table *mesh_table_alloc(void)
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



