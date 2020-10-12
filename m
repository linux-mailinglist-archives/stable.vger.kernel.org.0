Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B3B28B9B5
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390173AbgJLOCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731230AbgJLNin (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:38:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F90221FC;
        Mon, 12 Oct 2020 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509895;
        bh=mybcqZkKBdPDpMQJmV2f3zmdIyizClBUs9tou5/HIJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEfIN7b7HRxFO/tY25dwWgc5j21KmUevd9YUvHZXLLwaOsQE77NiFFH2/9QRMpK/s
         jY21P1vLtHNhZDeWWDJNJJ8inwqSORHpPkifHr5gFZP0isAaympbrW+hBoAUdLHTKf
         zxaVWb2FhqQI6XsBsHwcJEmdJOhAnE+j2Tjfa6g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 55/70] xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
Date:   Mon, 12 Oct 2020 15:27:11 +0200
Message-Id: <20201012132632.825158571@linuxfoundation.org>
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
index 190ca59d5ba31..37104258808a8 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1320,6 +1320,30 @@ out:
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
@@ -1376,6 +1400,10 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
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



