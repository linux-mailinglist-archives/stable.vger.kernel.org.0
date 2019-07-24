Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA8F73FA0
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbfGXUeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbfGXT1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:27:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D76620659;
        Wed, 24 Jul 2019 19:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996431;
        bh=gnOSOLYEj45vkm7VxpJ725rQmdijs34Mxubc2vn+YD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlyUrXvF0kRvt6IDPnb9ZeF3JJLeYR3Ztb6c+iYfegPpDeVi2McMuT1c6qUpGOPRY
         D553UKUQ6dBAcqa+OPc64u+8lkY9cwwJGsF5sFfIdDFHY9E2g55pfp0NAtKwRTDZw4
         Yyh+A//+z3pmw59c+DHqsyg+NJwhUZ5pjULfgLcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 077/413] netfilter: ipset: fix a missing check of nla_parse
Date:   Wed, 24 Jul 2019 21:16:08 +0200
Message-Id: <20190724191740.609212216@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f4f5748bfec94cf418e49bf05f0c81a1b9ebc950 ]

When nla_parse fails, we should not use the results (the first
argument). The fix checks if it fails, and if so, returns its error code
upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3cdf171cd468..16afa0df4004 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1541,10 +1541,14 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
-		nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
-				     nlh->nlmsg_len - min_len,
-				     ip_set_adt_policy, NULL);
+		ret = nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+					   nlh->nlmsg_len - min_len,
+					   ip_set_adt_policy, NULL);
 
+		if (ret) {
+			nlmsg_free(skb2);
+			return ret;
+		}
 		errline = nla_data(cda[IPSET_ATTR_LINENO]);
 
 		*errline = lineno;
-- 
2.20.1



