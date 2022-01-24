Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A362C4997A8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448999AbiAXVOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:14:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59654 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446321AbiAXVHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AD77B812A4;
        Mon, 24 Jan 2022 21:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD39C340E5;
        Mon, 24 Jan 2022 21:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058470;
        bh=KcnNIjP6Rz+rHunKoXuupK88UPEDoviX5kS4HSHMa6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pyuu7nsxmi7ZJDdcmi4SS2H/UbkpTuCrzfex8B8HZyOkmK9zORobpaDnY/Cz+/Aik
         JDu9O/bEMFIXEvqH7oqrulsMLwsPh9pXerF/ru/4SPsG8ABkSeJzj+IluFN1q49AxP
         fEq7YP+hdfaRHQqZujwNyTwUe3wOnZ6UCoSOz/5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0266/1039] xfrm: fix a small bug in xfrm_sa_len()
Date:   Mon, 24 Jan 2022 19:34:15 +0100
Message-Id: <20220124184134.247461826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 7c36cc1f3d79c..0a2d2bae28316 100644
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



