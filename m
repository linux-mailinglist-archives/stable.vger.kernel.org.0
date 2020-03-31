Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1461F1991E5
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgCaJIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731328AbgCaJIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:08:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B42320787;
        Tue, 31 Mar 2020 09:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645699;
        bh=cK/T867mmCzZ7jlhvqRs6wFLYHZ3QXTaeW+I16G17lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMTtdgO0wPRLxRz5xYt3Zk6/G38onVQPUCyz1u4HXoKMlCYBvpDEcr+Fsu5JhOfIy
         o7gcUkE/bQCefVrpAr4GmslA13CgxgbHi21dadv6QL/efvYuT6fbLdq0+5U2FkFin2
         PoUTPIVp2LkJCWBwtlgmccg0kFNC5tGAllyiBTz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 136/170] netfilter: flowtable: populate addr_type mask
Date:   Tue, 31 Mar 2020 10:59:10 +0200
Message-Id: <20200331085437.985463513@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

commit 15ff197237e76c4dab06b7b518afaa4ebb1c43e0 upstream.

nf_flow_rule_match() sets control.addr_type in key, so needs to also set
 the corresponding mask.  An exact match is wanted, so mask is all ones.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_flow_table_offload.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -87,6 +87,7 @@ static int nf_flow_rule_match(struct nf_
 	default:
 		return -EOPNOTSUPP;
 	}
+	mask->control.addr_type = 0xffff;
 	match->dissector.used_keys |= BIT(key->control.addr_type);
 	mask->basic.n_proto = 0xffff;
 


