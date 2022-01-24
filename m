Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101C349A3DA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368959AbiAYAAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846611AbiAXXQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAB5C08EE6E;
        Mon, 24 Jan 2022 11:48:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08A07B811F3;
        Mon, 24 Jan 2022 19:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7A0C340E7;
        Mon, 24 Jan 2022 19:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053698;
        bh=0sWFuJFbcEAODzI6BQVR4P305YINCtGmvnWNLVcfTuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BJvAY89w82OS4HdaXKBSdsd5mFHQYZYSt1SML5IQOdvok+FwgfPCbi26qtgjTUhk
         2jLRp7FHRk6kLBQa7ehMRgLdaVcYIftuIQOwYXa8jC2lv8G3mtxd+0Ga8KVGn3MaoS
         5VET+1wX/x8BqgxaNygcm2iolxFUIgnpbSEZlLds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/563] xfrm: fix a small bug in xfrm_sa_len()
Date:   Mon, 24 Jan 2022 19:38:34 +0100
Message-Id: <20220124184029.559356236@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 6f97665b632ed..97f7ebf5324e7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2898,7 +2898,7 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
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



