Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5539D3A01ED
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbhFHS6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236966AbhFHS4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:56:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2FB561613;
        Tue,  8 Jun 2021 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177711;
        bh=wVUBn/slFIkh572Gg8YlnApQMtz+ZmZ8/aLbSH9pDB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2OcLOaRxGuM/fYr5VvlfZu9iGO5WC+a9FlumqneAwT2+70cBWXMYkyse9fong2Eg
         OFWlZAgHiAwlFMQkMKIBqC9TO26bbyzh9HfQyDy2EyjmC/GoYp235927d4tKsKoqUi
         MAO7fElfQUjF16zZlsR6IgaUyfTqP4FS9xqi9JSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/137] tipc: fix unique bearer names sanity check
Date:   Tue,  8 Jun 2021 20:26:50 +0200
Message-Id: <20210608175944.728135053@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit f20a46c3044c3f75232b3d0e2d09af9b25efaf45 ]

When enabling a bearer by name, we don't sanity check its name with
higher slot in bearer list. This may have the effect that the name
of an already enabled bearer bypasses the check.

To fix the above issue, we just perform an extra checking with all
existing bearers.

Fixes: cb30a63384bc9 ("tipc: refactor function tipc_enable_bearer()")
Cc: stable@vger.kernel.org
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 4d0e11623e5c..12e535b43d88 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -246,6 +246,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	int bearer_id = 0;
 	int res = -EINVAL;
 	char *errstr = "";
+	u32 i;
 
 	if (!bearer_name_validate(name, &b_names)) {
 		errstr = "illegal name";
@@ -270,31 +271,38 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 		prio = m->priority;
 
 	/* Check new bearer vs existing ones and find free bearer id if any */
-	while (bearer_id < MAX_BEARERS) {
-		b = rtnl_dereference(tn->bearer_list[bearer_id]);
-		if (!b)
-			break;
+	bearer_id = MAX_BEARERS;
+	i = MAX_BEARERS;
+	while (i-- != 0) {
+		b = rtnl_dereference(tn->bearer_list[i]);
+		if (!b) {
+			bearer_id = i;
+			continue;
+		}
 		if (!strcmp(name, b->name)) {
 			errstr = "already enabled";
 			NL_SET_ERR_MSG(extack, "Already enabled");
 			goto rejected;
 		}
-		bearer_id++;
-		if (b->priority != prio)
-			continue;
-		if (++with_this_prio <= 2)
-			continue;
-		pr_warn("Bearer <%s>: already 2 bearers with priority %u\n",
-			name, prio);
-		if (prio == TIPC_MIN_LINK_PRI) {
-			errstr = "cannot adjust to lower";
-			NL_SET_ERR_MSG(extack, "Cannot adjust to lower");
-			goto rejected;
+
+		if (b->priority == prio &&
+		    (++with_this_prio > 2)) {
+			pr_warn("Bearer <%s>: already 2 bearers with priority %u\n",
+				name, prio);
+
+			if (prio == TIPC_MIN_LINK_PRI) {
+				errstr = "cannot adjust to lower";
+				NL_SET_ERR_MSG(extack, "Cannot adjust to lower");
+				goto rejected;
+			}
+
+			pr_warn("Bearer <%s>: trying with adjusted priority\n",
+				name);
+			prio--;
+			bearer_id = MAX_BEARERS;
+			i = MAX_BEARERS;
+			with_this_prio = 1;
 		}
-		pr_warn("Bearer <%s>: trying with adjusted priority\n", name);
-		prio--;
-		bearer_id = 0;
-		with_this_prio = 1;
 	}
 
 	if (bearer_id >= MAX_BEARERS) {
-- 
2.30.2



