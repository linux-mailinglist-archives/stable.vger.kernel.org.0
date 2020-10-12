Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144CD28B777
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbgJLNnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731527AbgJLNmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:42:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E53AE206D9;
        Mon, 12 Oct 2020 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510127;
        bh=Yht/NJAyp77MftgzEDZvxYwOmomqXuL4Byc/Purviyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwgWseb/WtpHii5m50Fh8WTuZm1BiuDaypu5FD/R/kM5Sxh+OywD4TbkmDjSX5BBZ
         27njcPfr4as50IQxsIgek3rUJtuZE5VYAj/201MvPDMLY4eMbg4WaDVz1GtQyk5pWl
         tnDD/gs6IbenWnJHO8nfBgRipJr7C+88V6uV+lq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/85] xfrm: clone whole liftime_cur structure in xfrm_do_migrate
Date:   Mon, 12 Oct 2020 15:27:15 +0200
Message-Id: <20201012132635.369021823@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 8366685b2883e523f91e9816d7be371eb1144749 ]

When we clone state only add_time was cloned. It missed values like
bytes, packets.  Now clone the all members of the structure.

v1->v3:
 - use memcpy to copy the entire structure

Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index fc1b391ba1554..8df460eaac275 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1547,7 +1547,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->tfcpad = orig->tfcpad;
 	x->replay_maxdiff = orig->replay_maxdiff;
 	x->replay_maxage = orig->replay_maxage;
-	x->curlft.add_time = orig->curlft.add_time;
+	memcpy(&x->curlft, &orig->curlft, sizeof(x->curlft));
 	x->km.state = orig->km.state;
 	x->km.seq = orig->km.seq;
 	x->replay = orig->replay;
-- 
2.25.1



