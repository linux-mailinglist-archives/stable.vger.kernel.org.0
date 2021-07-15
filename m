Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BFE3CA5E1
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhGOSpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236538AbhGOSpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44CEA61396;
        Thu, 15 Jul 2021 18:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374532;
        bh=2i22KCHVi/5HW7v/5PYOSKt8E72zDw5l4Ce16zyEpSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IR6Ejp+fkWOgBg+AHnTdWK12LgRwHZDiLL+ABAzo+ZMI4hW6gwJmo7wGO0jpEJfkR
         EPBiL5aIaTVc/GgolYyHnxRHcCvmplcGBzulKxCcxoKjnY88hMQAneI6W6QLZXhLNE
         oyHvERlikiaPYUbKtwo8DYZE34MSccXjTpD5czz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Brunner <tobias@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/122] xfrm: Fix error reporting in xfrm_state_construct.
Date:   Thu, 15 Jul 2021 20:38:07 +0200
Message-Id: <20210715182459.106158485@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 6fd06963fa74197103cdbb4b494763127b3f2f34 ]

When memory allocation for XFRMA_ENCAP or XFRMA_COADDR fails,
the error will not be reported because the -ENOMEM assignment
to the err variable is overwritten before. Fix this by moving
these two in front of the function so that memory allocation
failures will be reported.

Reported-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fbb7d9d06478..0cee2d3c6e45 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -580,6 +580,20 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	copy_from_user_state(x, p);
 
+	if (attrs[XFRMA_ENCAP]) {
+		x->encap = kmemdup(nla_data(attrs[XFRMA_ENCAP]),
+				   sizeof(*x->encap), GFP_KERNEL);
+		if (x->encap == NULL)
+			goto error;
+	}
+
+	if (attrs[XFRMA_COADDR]) {
+		x->coaddr = kmemdup(nla_data(attrs[XFRMA_COADDR]),
+				    sizeof(*x->coaddr), GFP_KERNEL);
+		if (x->coaddr == NULL)
+			goto error;
+	}
+
 	if (attrs[XFRMA_SA_EXTRA_FLAGS])
 		x->props.extra_flags = nla_get_u32(attrs[XFRMA_SA_EXTRA_FLAGS]);
 
@@ -600,23 +614,9 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 				   attrs[XFRMA_ALG_COMP])))
 		goto error;
 
-	if (attrs[XFRMA_ENCAP]) {
-		x->encap = kmemdup(nla_data(attrs[XFRMA_ENCAP]),
-				   sizeof(*x->encap), GFP_KERNEL);
-		if (x->encap == NULL)
-			goto error;
-	}
-
 	if (attrs[XFRMA_TFCPAD])
 		x->tfcpad = nla_get_u32(attrs[XFRMA_TFCPAD]);
 
-	if (attrs[XFRMA_COADDR]) {
-		x->coaddr = kmemdup(nla_data(attrs[XFRMA_COADDR]),
-				    sizeof(*x->coaddr), GFP_KERNEL);
-		if (x->coaddr == NULL)
-			goto error;
-	}
-
 	xfrm_mark_get(attrs, &x->mark);
 
 	xfrm_smark_init(attrs, &x->props.smark);
-- 
2.30.2



