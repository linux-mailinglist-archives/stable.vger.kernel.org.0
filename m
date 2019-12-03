Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8783111E82
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbfLCWx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730212AbfLCWxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D891820674;
        Tue,  3 Dec 2019 22:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413634;
        bh=IiqYBFz+atwV5nFvmuzK7M6djh/sadmEpH84Yi6I5dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5PaXPtc/ZDnuNCgqrnZiU1D0htM0OaNCl3dZLssDIS8T8VIvG8rEpVODpxAmGAo+
         fg+8YXBftJrYBd0p44FDHSUSvgcTqEdlTUPWEfqSHGyIfZVELLSxgzkgO40QtJN0HY
         FoEbaJ/5KU8ZdzePZCUMa5WS3de4n96w5dEpP+P4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/321] netfilter: nf_tables: fix a missing check of nla_put_failure
Date:   Tue,  3 Dec 2019 23:34:28 +0100
Message-Id: <20191203223437.631822664@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit eb8950861c1bfd3eecc8f6faad213e3bca0dc395 ]

If nla_nest_start() may fail. The fix checks its return value and goes
to nla_put_failure if it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 289d079008ee8..ec0f8b5bde0aa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5737,6 +5737,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
+	if (!nest)
+		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_NUM, htonl(flowtable->hooknum)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(flowtable->priority)))
 		goto nla_put_failure;
-- 
2.20.1



