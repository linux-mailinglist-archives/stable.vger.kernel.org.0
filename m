Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1ED1EAC49
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbgFASSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731363AbgFASSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:18:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF5BF206E2;
        Mon,  1 Jun 2020 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035489;
        bh=seTGqVHM+PzsNvV/G5PEpXA8TcvoqEYo/jYqnVIjpww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/i1jz75MGTveODwEdbRB1Ltn2VHiSv1tJKMn9dBYD39RD09SmYB8Mndt26aNE6Jr
         WkTdNXdk4rjQ3ulWIy4XiElZmptNA/AcbwR+irBfV0ilcyfibQ3Dj48bCNGDVEQhcJ
         YugX+mVb178EqAIAm8HsSi+OzqfbxwccdQhcNVIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.6 175/177] netfilter: conntrack: comparison of unsigned in cthelper confirmation
Date:   Mon,  1 Jun 2020 19:55:13 +0200
Message-Id: <20200601174102.625366555@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 94945ad2b330207cded0fd8d4abebde43a776dfb upstream.

net/netfilter/nf_conntrack_core.c: In function nf_confirm_cthelper:
net/netfilter/nf_conntrack_core.c:2117:15: warning: comparison of unsigned expression in < 0 is always false [-Wtype-limits]
 2117 |   if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
      |               ^

ipv6_skip_exthdr() returns a signed integer.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: 703acd70f249 ("netfilter: nfnetlink_cthelper: unbreak userspace helper support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2090,7 +2090,7 @@ static int nf_confirm_cthelper(struct sk
 {
 	const struct nf_conntrack_helper *helper;
 	const struct nf_conn_help *help;
-	unsigned int protoff;
+	int protoff;
 
 	help = nfct_help(ct);
 	if (!help)


