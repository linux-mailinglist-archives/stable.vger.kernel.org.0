Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147FF4512C6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347361AbhKOTjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245010AbhKOTSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C7E63438;
        Mon, 15 Nov 2021 18:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000817;
        bh=LTGJYa28MS1I9l3cpM5GMtheOIB178jPguO/fGWMZdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCfmq0FDluUNji3D/tJCi9fcGkyScAdapf2/TNFoaNzH1uSuL7aWFxF4dEt925Dx7
         hBEx4gn5Gk3GLiFevTOP5qSJZJiLIImCmU69wp3Fw5gUD/6oxvpU9PfThf+KkIbJ6S
         p8pCQhDIyJEJDLN98IuysgkcbshNJt52lLNht49o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 803/849] net, neigh: Enable state migration between NUD_PERMANENT and NTF_USE
Date:   Mon, 15 Nov 2021 18:04:46 +0100
Message-Id: <20211115165447.398027401@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3dc20f4762c62d3b3f0940644881ed818aa7b2f5 ]

Currently, it is not possible to migrate a neighbor entry between NUD_PERMANENT
state and NTF_USE flag with a dynamic NUD state from a user space control plane.
Similarly, it is not possible to add/remove NTF_EXT_LEARNED flag from an existing
neighbor entry in combination with NTF_USE flag.

This is due to the latter directly calling into neigh_event_send() without any
meta data updates as happening in __neigh_update(). Thus, to enable this use
case, extend the latter with a NEIGH_UPDATE_F_USE flag where we break the
NUD_PERMANENT state in particular so that a latter neigh_event_send() is able
to re-resolve a neighbor entry.

Before fix, NUD_PERMANENT -> NUD_* & NTF_USE:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a PERMANENT
  [...]
  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a PERMANENT
  [...]

As can be seen, despite the admin-triggered replace, the entry remains in the
NUD_PERMANENT state.

After fix, NUD_PERMANENT -> NUD_* & NTF_USE:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a PERMANENT
  [...]
  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a extern_learn REACHABLE
  [...]
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a extern_learn STALE
  [...]
  # ./ip/ip n replace 192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a PERMANENT
  [...]

After the fix, the admin-triggered replace switches to a dynamic state from
the NTF_USE flag which triggered a new neighbor resolution. Likewise, we can
transition back from there, if needed, into NUD_PERMANENT.

Similar before/after behavior can be observed for below transitions:

Before fix, NTF_USE -> NTF_USE | NTF_EXT_LEARNED -> NTF_USE:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a REACHABLE
  [...]
  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a REACHABLE
  [...]

After fix, NTF_USE -> NTF_USE | NTF_EXT_LEARNED -> NTF_USE:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a REACHABLE
  [...]
  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a extern_learn REACHABLE
  [...]
  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a REACHABLE
  [..]

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h |  1 +
 net/core/neighbour.c    | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 990f9b1d17092..d5767e25509cc 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -253,6 +253,7 @@ static inline void *neighbour_priv(const struct neighbour *n)
 #define NEIGH_UPDATE_F_OVERRIDE			0x00000001
 #define NEIGH_UPDATE_F_WEAK_OVERRIDE		0x00000002
 #define NEIGH_UPDATE_F_OVERRIDE_ISROUTER	0x00000004
+#define NEIGH_UPDATE_F_USE			0x10000000
 #define NEIGH_UPDATE_F_EXT_LEARNED		0x20000000
 #define NEIGH_UPDATE_F_ISROUTER			0x40000000
 #define NEIGH_UPDATE_F_ADMIN			0x80000000
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 077883f9f570b..704832723ab87 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1221,7 +1221,7 @@ static void neigh_update_hhs(struct neighbour *neigh)
 				lladdr instead of overriding it
 				if it is different.
 	NEIGH_UPDATE_F_ADMIN	means that the change is administrative.
-
+	NEIGH_UPDATE_F_USE	means that the entry is user triggered.
 	NEIGH_UPDATE_F_OVERRIDE_ISROUTER allows to override existing
 				NTF_ROUTER flag.
 	NEIGH_UPDATE_F_ISROUTER	indicates if the neighbour is known as
@@ -1259,6 +1259,12 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
 		goto out;
 
 	ext_learn_change = neigh_update_ext_learned(neigh, flags, &notify);
+	if (flags & NEIGH_UPDATE_F_USE) {
+		new = old & ~NUD_PERMANENT;
+		neigh->nud_state = new;
+		err = 0;
+		goto out;
+	}
 
 	if (!(new & NUD_VALID)) {
 		neigh_del_timer(neigh);
@@ -1968,22 +1974,20 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (protocol)
 		neigh->protocol = protocol;
-
 	if (ndm->ndm_flags & NTF_EXT_LEARNED)
 		flags |= NEIGH_UPDATE_F_EXT_LEARNED;
-
 	if (ndm->ndm_flags & NTF_ROUTER)
 		flags |= NEIGH_UPDATE_F_ISROUTER;
+	if (ndm->ndm_flags & NTF_USE)
+		flags |= NEIGH_UPDATE_F_USE;
 
-	if (ndm->ndm_flags & NTF_USE) {
+	err = __neigh_update(neigh, lladdr, ndm->ndm_state, flags,
+			     NETLINK_CB(skb).portid, extack);
+	if (!err && ndm->ndm_flags & NTF_USE) {
 		neigh_event_send(neigh, NULL);
 		err = 0;
-	} else
-		err = __neigh_update(neigh, lladdr, ndm->ndm_state, flags,
-				     NETLINK_CB(skb).portid, extack);
-
+	}
 	neigh_release(neigh);
-
 out:
 	return err;
 }
-- 
2.33.0



