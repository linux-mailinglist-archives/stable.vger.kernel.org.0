Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A503198F74
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbgCaJDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730834AbgCaJDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C7D820787;
        Tue, 31 Mar 2020 09:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645412;
        bh=JspOp3JCato+Ngd4oQfQrfM4XN3jMP+GM9OQRSWLRW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W17CFuEIa0l2m2Zo0EYYtQL03G54w6MM2IIrBD9z4bthJC6gvx8n9DKqSBE/6C/Rk
         j0u3+Jrh21V3PnVt3dd+TtpIFWZ6Loi80IQcHZ60CQeMPNU/4Tv4BvcaYB7ZN7kHn0
         W/fb+2A+QASaktY1b+0lPdxP5b6gyH0deYVzmg9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 028/170] net/sched: act_ct: Fix leak of ct zone template on replace
Date:   Tue, 31 Mar 2020 10:57:22 +0200
Message-Id: <20200331085427.087743003@linuxfoundation.org>
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

From: Paul Blakey <paulb@mellanox.com>

[ Upstream commit dd2af10402684cb5840a127caec9e7cdcff6d167 ]

Currently, on replace, the previous action instance params
is swapped with a newly allocated params. The old params is
only freed (via kfree_rcu), without releasing the allocated
ct zone template related to it.

Call tcf_ct_params_free (via call_rcu) for the old params,
so it will release it.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -739,7 +739,7 @@ static int tcf_ct_init(struct net *net,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 	if (params)
-		kfree_rcu(params, rcu);
+		call_rcu(&params->rcu, tcf_ct_params_free);
 	if (res == ACT_P_CREATED)
 		tcf_idr_insert(tn, *a);
 


