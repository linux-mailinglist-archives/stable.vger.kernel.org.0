Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7128B98D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgJLOBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731137AbgJLNiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B82D20878;
        Mon, 12 Oct 2020 13:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509893;
        bh=uq6qvqO3FjtwUjLOU+NwnGrIC6pZlDYOHE+3f3ensts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLhQwJHbnItwZWGVifiFcTSrpELLtzIxN/+mk+ANu3XXpGy2ESbA2zvcw0QPuGaMo
         oevFgxvsqIWZyLzGlJ2f2xYBxQBToGyZ2edD6/B3KsJxpxUw9O95CJkksAfN+oj+nS
         HCBPY1nVHk9ST/AuCGgGK+/khePZtRYbuxb1wHAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 54/70] xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
Date:   Mon, 12 Oct 2020 15:27:10 +0200
Message-Id: <20201012132632.777777307@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 91a46c6d1b4fcbfa4773df9421b8ad3e58088101 ]

XFRMA_REPLAY_ESN_VAL was not cloned completely from the old to the new.
Migrate this attribute during XFRMA_MSG_MIGRATE

v1->v2:
 - move curleft cloning to a separate patch

Fixes: af2f464e326e ("xfrm: Assign esn pointers when cloning a state")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 57b8b11cf7d42..86ff111574496 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1808,21 +1808,17 @@ static inline int xfrm_replay_state_esn_len(struct xfrm_replay_state_esn *replay
 static inline int xfrm_replay_clone(struct xfrm_state *x,
 				     struct xfrm_state *orig)
 {
-	x->replay_esn = kzalloc(xfrm_replay_state_esn_len(orig->replay_esn),
+
+	x->replay_esn = kmemdup(orig->replay_esn,
+				xfrm_replay_state_esn_len(orig->replay_esn),
 				GFP_KERNEL);
 	if (!x->replay_esn)
 		return -ENOMEM;
-
-	x->replay_esn->bmp_len = orig->replay_esn->bmp_len;
-	x->replay_esn->replay_window = orig->replay_esn->replay_window;
-
-	x->preplay_esn = kmemdup(x->replay_esn,
-				 xfrm_replay_state_esn_len(x->replay_esn),
+	x->preplay_esn = kmemdup(orig->preplay_esn,
+				 xfrm_replay_state_esn_len(orig->preplay_esn),
 				 GFP_KERNEL);
-	if (!x->preplay_esn) {
-		kfree(x->replay_esn);
+	if (!x->preplay_esn)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
-- 
2.25.1



