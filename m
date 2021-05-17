Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E489F383463
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242860AbhEQPIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241871AbhEQPGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:06:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CFF561C1D;
        Mon, 17 May 2021 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261741;
        bh=cSLuZmPpg+5vAJtit7Stpp4LIrI68gZZNQd21Yd9I6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/UtyFlzYpyndcPbJSqt2Iz3hNpT/7/5mbDm9LIJERoJLvYgbsUk0/4T9AahC6DuP
         r1qtsxCN9mtMz/yyf8IaH7m+f/RMeICGp/fW8DwCi7nyKSK+feyvwiIzT7H4rM/9BR
         AIV39qfUoWq16Ikj7kNFvgNPxeddO3JSrjw77Wfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nucca Chen <nuccachen@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/141] net: fix nla_strcmp to handle more then one trailing null character
Date:   Mon, 17 May 2021 16:02:16 +0200
Message-Id: <20210517140245.610722120@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit 2c16db6c92b0ee4aa61e88366df82169e83c3f7e ]

Android userspace has been using TCA_KIND with a char[IFNAMESIZ]
many-null-terminated buffer containing the string 'bpf'.

This works on 4.19 and ceases to work on 5.10.

I'm not entirely sure what fixes tag to use, but I think the issue
was likely introduced in the below mentioned 5.4 commit.

Reported-by: Nucca Chen <nuccachen@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Fixes: 62794fc4fbf5 ("net_sched: add max len check for TCA_KIND")
Change-Id: I66dc281f165a2858fc29a44869a270a2d698a82b
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/nlattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index cace9b307781..0d84f79cb4b5 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -609,7 +609,7 @@ int nla_strcmp(const struct nlattr *nla, const char *str)
 	int attrlen = nla_len(nla);
 	int d;
 
-	if (attrlen > 0 && buf[attrlen - 1] == '\0')
+	while (attrlen > 0 && buf[attrlen - 1] == '\0')
 		attrlen--;
 
 	d = attrlen - len;
-- 
2.30.2



