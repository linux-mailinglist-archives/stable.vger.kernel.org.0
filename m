Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A13642DD5C
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhJNPGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233572AbhJNPEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2C46611C5;
        Thu, 14 Oct 2021 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223661;
        bh=NQKC8Vr4op7XQbJQ+LpubJ+MUbA4cdFLEPqGo2sEVRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzqDJG++zB5of6AHjiRwgKc7WUhS80guluZGpJig5KfwHRZ0l5zk/CmTJu8WIxjl6
         pH11iocsnbj9e1cmDwoQdJQET3YZuowkUVX1KXm6MQYVq+zIqxbhHbJCtIvBpcPoc3
         mCYYSGffR8I2KLPh2HgyEHuyUccH3t7EUr5kqSC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, MichelleJin <shjy180909@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 19/30] mac80211: check return value of rhashtable_init
Date:   Thu, 14 Oct 2021 16:54:24 +0200
Message-Id: <20211014145210.157657252@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
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
index efbefcbac3ac..7cab1cf09bf1 100644
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



