Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356C63CA5F3
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbhGOSpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235462AbhGOSpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:45:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B78A3613CC;
        Thu, 15 Jul 2021 18:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374551;
        bh=o8/SmWUqbQEyuMyc2gvCsZe1vXGfO6sLcc64P9UU7hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZR3lKVlxlroNdUNAxgGo/g1OD6mPm7gHT03pJ+6QcQGbE9L+KAz2cANGRGyuUhCKk
         3d2w+/SBy87ZNFyJecNj643HDRcN94I5xXUtreQxVUsPrLN1ZmuHoPD15GaTlO4Alk
         n/lFbUzdoXdNxM8+tjZNwUC7d1TphuTlLMz6fR/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/122] net: sched: fix error return code in tcf_del_walker()
Date:   Thu, 15 Jul 2021 20:38:14 +0200
Message-Id: <20210715182500.878480642@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 55d96f72e8ddc0a294e0b9c94016edbb699537e1 ]

When nla_put_u32() fails, 'ret' could be 0, it should
return error code in tcf_del_walker().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 716cad677318..17e5cd9ebd89 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -316,7 +316,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	}
 	mutex_unlock(&idrinfo->lock);
 
-	if (nla_put_u32(skb, TCA_FCNT, n_i))
+	ret = nla_put_u32(skb, TCA_FCNT, n_i);
+	if (ret)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 
-- 
2.30.2



