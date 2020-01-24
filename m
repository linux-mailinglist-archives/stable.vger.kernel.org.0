Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E6147F6D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387953AbgAXLCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:02:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733088AbgAXLCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:02:09 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B662A20838;
        Fri, 24 Jan 2020 11:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863728;
        bh=SJzxxMTqMPGD3zBxUOJbv6XUEQmgF34qgxz4zoDCeKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1eUFNe7wk2sn6IxnuRhpkEpNWhNWCNR3rdLJucX9Da3dRKow5QBTFFEmUlWEAiXP
         Sd+k7AwWmJfewC7nAZddFHRt6YbLkDN8w1Uq3Q91NooS/C7q3GmgXCJq7aMp70Pzsb
         BY6cxBMLuLejw6bKYaxLiX67OZ+Y7+eFTuiCA69k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/639] netfilter: nft_osf: usage from output path is not valid
Date:   Fri, 24 Jan 2020 10:23:39 +0100
Message-Id: <20200124093053.554365367@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 4a3e71b7b7dbaf3562be9d508260935aa13cb48b ]

The nft_osf extension, like xt_osf, is not supported from the output
path.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_osf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index a35fb59ace732..df4e3e0412ed3 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -69,6 +69,15 @@ nla_put_failure:
 	return -1;
 }
 
+static int nft_osf_validate(const struct nft_ctx *ctx,
+			    const struct nft_expr *expr,
+			    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
+						    (1 << NF_INET_PRE_ROUTING) |
+						    (1 << NF_INET_FORWARD));
+}
+
 static struct nft_expr_type nft_osf_type;
 static const struct nft_expr_ops nft_osf_op = {
 	.eval		= nft_osf_eval,
@@ -76,6 +85,7 @@ static const struct nft_expr_ops nft_osf_op = {
 	.init		= nft_osf_init,
 	.dump		= nft_osf_dump,
 	.type		= &nft_osf_type,
+	.validate	= nft_osf_validate,
 };
 
 static struct nft_expr_type nft_osf_type __read_mostly = {
-- 
2.20.1



