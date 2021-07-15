Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0F3CA724
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbhGOSwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239668AbhGOSv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73674613D0;
        Thu, 15 Jul 2021 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374940;
        bh=eSycJIMDZXZyrd/1c7nOzr9jCCy03KoTysMTjCZp9IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z022bIHUc3lW+RekxznPtdq5qo72OwQgduZEJgIzfHYwMCXsUNxzSA8OLj2UvnEqG
         4U/zPkjOxMlR/gK5eUBzSEjLYMxe4UDC8E+07tKdPcOPhWvDz/TRQe5Vo3PRoJ1s2K
         LzwyQLaBfCw5Gy5BMfXUYr5gJACR+fVU6OLjBDf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/215] net: sched: fix error return code in tcf_del_walker()
Date:   Thu, 15 Jul 2021 20:37:42 +0200
Message-Id: <20210715182615.279106664@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
index 88e14cfeb5d5..f613299ca7f0 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -333,7 +333,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	}
 	mutex_unlock(&idrinfo->lock);
 
-	if (nla_put_u32(skb, TCA_FCNT, n_i))
+	ret = nla_put_u32(skb, TCA_FCNT, n_i);
+	if (ret)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 
-- 
2.30.2



