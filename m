Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FD12FA9EC
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437026AbhARTRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390447AbhARLiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6782B22C9C;
        Mon, 18 Jan 2021 11:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969828;
        bh=qQJGmy+ozBZJtmb7VQ2AXcvoNE5LRknwbnJaBsdqEu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYuNyOLIMJjL5mPv7CTdjh3ePce9Yp9wJaLHmBIwi+k1dMBjkhLQmkTi3HEVahRTE
         clT+oAMA1SajhnHrYkFp/wOwW0Wl5CWue3f/JyPDETx0rMqOn01UIKnuWurE7JJaLr
         8Resc+K7yHHryJK9MlJ6Ji7l1aZagz4BMutvHqnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 42/43] netfilter: nf_nat: Fix memleak in nf_nat_init
Date:   Mon, 18 Jan 2021 12:35:05 +0100
Message-Id: <20210118113336.971419279@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 869f4fdaf4ca7bb6e0d05caf6fa1108dddc346a7 upstream.

When register_pernet_subsys() fails, nf_nat_bysource
should be freed just like when nf_ct_extend_register()
fails.

Fixes: 1cd472bf036ca ("netfilter: nf_nat: add nat hook register functions to nf_nat")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_nat_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1068,6 +1068,7 @@ static int __init nf_nat_init(void)
 	ret = register_pernet_subsys(&nat_net_ops);
 	if (ret < 0) {
 		nf_ct_extend_unregister(&nat_extend);
+		kvfree(nf_nat_bysource);
 		return ret;
 	}
 


