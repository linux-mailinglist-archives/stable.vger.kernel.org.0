Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E93199192
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgCaJOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgCaJOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:14:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAA1C2137B;
        Tue, 31 Mar 2020 09:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646043;
        bh=JspOp3JCato+Ngd4oQfQrfM4XN3jMP+GM9OQRSWLRW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEk+3Cvnsw3ySzUfv6/LVhZL8+LXM7fOsHA7aNFliurF+DPk4vJO7QcEDnz6BBjrr
         T3A/TTc/WYxHMX20aDauG6p0fI52o0FwZtDQI3zP/5NqL+7CjvQpijPw4M6I0wBo2W
         3siSjlHgG89uhL4dVdXVLauF1n8F74Z+HDQk+oNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 027/155] net/sched: act_ct: Fix leak of ct zone template on replace
Date:   Tue, 31 Mar 2020 10:57:47 +0200
Message-Id: <20200331085421.444017394@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
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
 


