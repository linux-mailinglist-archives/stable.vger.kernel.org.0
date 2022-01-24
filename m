Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D47E49A947
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322408AbiAYDVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47144 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380340AbiAXUVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:21:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FA6D61233;
        Mon, 24 Jan 2022 20:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487A0C340E7;
        Mon, 24 Jan 2022 20:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055667;
        bh=z2Lk3Y7qtlsFod4BlQ5zakyhSX2kYedjVU7vDnFZYew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dH9OS99q+208Ib/6eFcc0GAhxARffYaO1YdwTgpDV2g66I0Ua5scXGf1/ofbFeKYL
         5XkWztbFrOQRb+Um1xD9paG0HJv+kFBdWjrHXPTbOZpW8+SkVfDRYyGm2nQJKe0nR6
         wjuo2sVv93UwvfdjVRx2tUfYVvPJqNqRe74btn7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/846] xfrm: fix a small bug in xfrm_sa_len()
Date:   Mon, 24 Jan 2022 19:35:44 +0100
Message-Id: <20220124184108.752445388@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 3a3cb09eec122..11574314de09f 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3058,7 +3058,7 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
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



