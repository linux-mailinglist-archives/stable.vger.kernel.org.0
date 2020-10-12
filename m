Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C28A28B7A2
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbgJLNpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388373AbgJLNnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:43:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E8DA221FE;
        Mon, 12 Oct 2020 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510196;
        bh=UfrYpmMLSfHoSfyBBh1Q85+/udG9IiZNyjLAVN6D9bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJALk0hE1250vV73Ndbb9cRIGdmPVQxXsglWmaZRdp41NJIZXRib/MGGFHJo6cJDw
         IslJVrWOmXZNCKUftmcwBS3ubWXBVBLCprbYDKY4xaghzKre97qwA367mM/G2j6/uP
         kJWCmXGGB1pqybKZsflZku7IPrOzg50cik/XTqU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/85] xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
Date:   Mon, 12 Oct 2020 15:27:14 +0200
Message-Id: <20201012132635.320244639@linuxfoundation.org>
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

[ Upstream commit 7aa05d304785204703a67a6aa7f1db402889a172 ]

XFRMA_SEC_CTX was not cloned from the old to the new.
Migrate this attribute during XFRMA_MSG_MIGRATE

v1->v2:
 - return -ENOMEM on error
v2->v3:
 - fix return type to int

Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 10d30f0338d72..fc1b391ba1554 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1438,6 +1438,30 @@ out:
 EXPORT_SYMBOL(xfrm_state_add);
 
 #ifdef CONFIG_XFRM_MIGRATE
+static inline int clone_security(struct xfrm_state *x, struct xfrm_sec_ctx *security)
+{
+	struct xfrm_user_sec_ctx *uctx;
+	int size = sizeof(*uctx) + security->ctx_len;
+	int err;
+
+	uctx = kmalloc(size, GFP_KERNEL);
+	if (!uctx)
+		return -ENOMEM;
+
+	uctx->exttype = XFRMA_SEC_CTX;
+	uctx->len = size;
+	uctx->ctx_doi = security->ctx_doi;
+	uctx->ctx_alg = security->ctx_alg;
+	uctx->ctx_len = security->ctx_len;
+	memcpy(uctx + 1, security->ctx_str, security->ctx_len);
+	err = security_xfrm_state_alloc(x, uctx);
+	kfree(uctx);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 					   struct xfrm_encap_tmpl *encap)
 {
@@ -1494,6 +1518,10 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 			goto error;
 	}
 
+	if (orig->security)
+		if (clone_security(x, orig->security))
+			goto error;
+
 	if (orig->coaddr) {
 		x->coaddr = kmemdup(orig->coaddr, sizeof(*x->coaddr),
 				    GFP_KERNEL);
-- 
2.25.1



