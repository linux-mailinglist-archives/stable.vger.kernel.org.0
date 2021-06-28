Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936EA3B6114
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhF1Obv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234628AbhF1OaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77A8861CAF;
        Mon, 28 Jun 2021 14:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890398;
        bh=tWHLgKCSspw/p3ROZiuTVcoKpkDiADFWqlPIp8tLqAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWa8rTiyxTf6tJ74Kjpp0O44rEOKiyz/O3nvC/etpgK+ygFBK1aVLsz17q99wL4wD
         KEAe8Zf5LzWC2EggIN03nV50kzJa30QPeSDvzxI9Uf1qXEdF2HAchEFzBnG8WmmdFU
         cwP4xCpiqOBYozEAkdX7mtchE77H2PVdz4QUuowgXdGlCDpVQBPM1aDx6er3qMnKGJ
         VwI78zTJDlDCoh96pHh6y4zoISzzm2X3y3gnuT5VxhC5Fh+8LWsNZ8yqZqLQtMExF4
         NsgP5xX1HeqPcf8DJn0iSERDh+WUOJCVgMasEfVr8lwT2klFFL4jqKuzhisEJxqyZF
         FDVwtcFq6ZuEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/101] net: ipv4: Remove unneed BUG() function
Date:   Mon, 28 Jun 2021 10:24:59 -0400
Message-Id: <20210628142607.32218-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 5ac6b198d7e312bd10ebe7d58c64690dc59cc49a ]

When 'nla_parse_nested_deprecated' failed, it's no need to
BUG() here, return -EINVAL is ok.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c  | 2 +-
 net/ipv6/addrconf.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 123a6d39438f..7c1859777429 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1989,7 +1989,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla)
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET_CONF]) {
 		nla_for_each_nested(a, tb[IFLA_INET_CONF], rem)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4c881f5d9080..884d430e23cb 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5799,7 +5799,7 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET6_TOKEN]) {
 		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]));
-- 
2.30.2

