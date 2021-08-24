Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422F03F6400
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbhHXRAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238709AbhHXQ6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12AEE61503;
        Tue, 24 Aug 2021 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824244;
        bh=iLV9+TYkAZlo6dIemTw4D2PVHafrNUoadYokXndKSwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQ6h6MIxiYysAETI6lP+rU95sYoFR2Ru7rko3lYWr6jY+cq7cP+Jr6BajYEapBA+/
         slJQ4MBpooZsQOzmYmhAO+eiibYrGnL+d+/6fPPjhbqqFVyIVzK72JR6HYSmAPR807
         b9o7LfQxmwmP0yVweBkBH1VqN76y4d6qE+vyfGJv5pu/t7anejUThyArXKTayT7fMg
         ZZuluYkiLle9zJXco2GbaLf+LzcoPZ9DBWpSrlvLreP9G6zcclYN1yXsxEHHvaLScs
         iMBJyIjdr8a86kHvkb6LH2iX6fvOW8nHrFCEkba/JLop7TPqe5/YY+l4iWAS89Tmjn
         QdDup3PYG443w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 077/127] mptcp: full fully established support after ADD_ADDR
Date:   Tue, 24 Aug 2021 12:55:17 -0400
Message-Id: <20210824165607.709387-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 67b12f792d5eaeb8b4fca3b2053e6b819eb3bf0f ]

If directly after an MP_CAPABLE 3WHS, the client receives an ADD_ADDR
with HMAC from the server, it is enough to switch to a "fully
established" mode because it has received more MPTCP options.

It was then OK to enable the "fully_established" flag on the MPTCP
socket. Still, best to check if the ADD_ADDR looks valid by looking if
it contains an HMAC (no 'echo' bit). If an ADD_ADDR echo is received
while we are not in "fully established" mode, it is strange and then
we should not switch to this mode now.

But that is not enough. On one hand, the path-manager has be notified
the state has changed. On the other hand, the "fully_established" flag
on the subflow socket should be turned on as well not to re-send the
MP_CAPABLE 3rd ACK content with the next ACK.

Fixes: 84dfe3677a6f ("mptcp: send out dedicated ADD_ADDR packet")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 4f08e04e1ab7..f3ec85779733 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -843,20 +843,16 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		return subflow->mp_capable;
 	}
 
-	if (mp_opt->dss && mp_opt->use_ack) {
+	if ((mp_opt->dss && mp_opt->use_ack) ||
+	    (mp_opt->add_addr && !mp_opt->echo)) {
 		/* subflows are fully established as soon as we get any
-		 * additional ack.
+		 * additional ack, including ADD_ADDR.
 		 */
 		subflow->fully_established = 1;
 		WRITE_ONCE(msk->fully_established, true);
 		goto fully_established;
 	}
 
-	if (mp_opt->add_addr) {
-		WRITE_ONCE(msk->fully_established, true);
-		return true;
-	}
-
 	/* If the first established packet does not contain MP_CAPABLE + data
 	 * then fallback to TCP. Fallback scenarios requires a reset for
 	 * MP_JOIN subflows.
-- 
2.30.2

