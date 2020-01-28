Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2014E14B960
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbgA1ObG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:31:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387481AbgA1O2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:28:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7073620716;
        Tue, 28 Jan 2020 14:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221700;
        bh=B2fvCv8i+LxBDIg8WI21HrzwIXyf7tintpgAoAddjm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SN3xr2w81LToGiUjQUsEaiRG8NL3f/QecyYeYRwZhLsbdDXz9XmwzHULZc+qhGjon
         j1XM0v9tvibi+asmthzQXAWmXbYQpMguyitsKf6N7V2EH4ZaNXPF9MijmBvwEMjgVj
         PtfA1rV+W+p4jiY51k6dXU5Trz9zRy5a1xelkWNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 39/92] netfilter: nft_osf: add missing check for DREG attribute
Date:   Tue, 28 Jan 2020 15:08:07 +0100
Message-Id: <20200128135814.094432237@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 7eaecf7963c1c8f62d62c6a8e7c439b0e7f2d365 upstream.

syzbot reports just another NULL deref crash because of missing test
for presence of the attribute.

Reported-by: syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com
Fixes:  b96af92d6eaf9fadd ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_osf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -47,6 +47,9 @@ static int nft_osf_init(const struct nft
 	struct nft_osf *priv = nft_expr_priv(expr);
 	int err;
 
+	if (!tb[NFTA_OSF_DREG])
+		return -EINVAL;
+
 	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
 	err = nft_validate_register_store(ctx, priv->dreg, NULL,
 					  NFT_DATA_VALUE, NFT_OSF_MAXGENRELEN);


