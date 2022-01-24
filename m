Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D65C498C0E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347790AbiAXTTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:19:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42402 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347914AbiAXTRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:17:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A50D3B81232;
        Mon, 24 Jan 2022 19:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE194C340E5;
        Mon, 24 Jan 2022 19:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051829;
        bh=ZpzskAMDsXMc0AdS51AL/fglH6GoxgYxnHsplx/d8gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdPtLMtqs51dOTWw01SqFOXfxozffEuMRpty9oRC/jx5Zw1/wGAOhEMYAk1vFROJ/
         JgMZ+b5veHGPlHiuGAPAx7kziYBE0+DEVVE8vW36X4NsvjSHHQUlSDhso8XN1p4imy
         YaDuVH2+8jPmNrFpe1NrCHkT1LTJPUpnllsppCjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/239] xfrm: fix a small bug in xfrm_sa_len()
Date:   Mon, 24 Jan 2022 19:41:51 +0100
Message-Id: <20220124183945.447070797@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7770a39d7c63faec6c4f33666d49a8cb664d0482 ]

copy_user_offload() will actually push a struct struct xfrm_user_offload,
which is different than (struct xfrm_state *)->xso
(struct xfrm_state_offload)

Fixes: d77e38e612a01 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index f94abe1fdd58f..87932f6ad9d75 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2813,7 +2813,7 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
 	if (x->props.extra_flags)
 		l += nla_total_size(sizeof(x->props.extra_flags));
 	if (x->xso.dev)
-		 l += nla_total_size(sizeof(x->xso));
+		 l += nla_total_size(sizeof(struct xfrm_user_offload));
 	if (x->props.smark.v | x->props.smark.m) {
 		l += nla_total_size(sizeof(x->props.smark.v));
 		l += nla_total_size(sizeof(x->props.smark.m));
-- 
2.34.1



