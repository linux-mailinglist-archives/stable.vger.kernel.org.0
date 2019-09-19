Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2AB875D
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405201AbfISWGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405198AbfISWGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:06:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D91ED21924;
        Thu, 19 Sep 2019 22:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930784;
        bh=Qj6yfDBqKHzLQaT4wcSlVzsU+H4/+9A4VO5md+egf9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzIWJp4GwfZ0zObqTak4gj/9+ERUcWXAlBO740fliXTIa4+/TVMxrFEqLxTpceH3L
         6KcN4w7Z+Pmdg+PnosRZrEZMa6XiibUiUptUKSa8lxCV713vIE7NCu6oZjd+Z804wS
         eZXgmkHJh7D70lJYQIpJ9umqrrjbNQSOv2HtIlt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.2 005/124] netfilter: nf_flow_table: set default timeout after successful insertion
Date:   Fri, 20 Sep 2019 00:01:33 +0200
Message-Id: <20190919214819.390675371@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 110e48725db6262f260f10727d0fb2d3d25895e4 upstream.

Set up the default timeout for this new entry otherwise the garbage
collector might quickly remove it right after the flowtable insertion.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_flow_table_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -218,7 +218,7 @@ int flow_offload_add(struct nf_flowtable
 		return err;
 	}
 
-	flow->timeout = (u32)jiffies;
+	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);


