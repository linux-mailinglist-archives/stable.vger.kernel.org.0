Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AF314B6B1
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgA1OHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbgA1OD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94891205F4;
        Tue, 28 Jan 2020 14:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220237;
        bh=4ur1Ix63mEhL4kZuXF7GWGOWcQMmuI6lxxCh9xmTNZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrLCmcr+CZpjnmTMssESJkMe68TYSVDmc+typSR5Acntt0oBaqB1eDqjGbC7vaUO1
         02mtlvrW2uqtg7116YmLoJ0GZm8VUiufz8o8AJfHWRdWECHGThhq+vcjRizYZVw6fi
         67n/FdFdzlAYwLlX/oKKaaiwYwAKGyu1YSHTyS8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 070/104] netfilter: nft_osf: add missing check for DREG attribute
Date:   Tue, 28 Jan 2020 15:00:31 +0100
Message-Id: <20200128135827.019998828@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
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
@@ -61,6 +61,9 @@ static int nft_osf_init(const struct nft
 	int err;
 	u8 ttl;
 
+	if (!tb[NFTA_OSF_DREG])
+		return -EINVAL;
+
 	if (tb[NFTA_OSF_TTL]) {
 		ttl = nla_get_u8(tb[NFTA_OSF_TTL]);
 		if (ttl > 2)


