Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEF23B5FFE
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhF1OVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232583AbhF1OVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09FF961C80;
        Mon, 28 Jun 2021 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889939;
        bh=z8eva5ncGyArZ1Cou+EQgQVkiY6HiDJ2aUxVhQNwkss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGiwjWcm0s1JxKj8nKZsat4wJLPSI/tsRdqIMGFAX7CC/K+MffWrC/GRXYoK5KqtR
         9UcJsjGQxu1kj5fqjuJdA+UV5eHZpnBfCaD/6FM35mgk6JaF1rnMzAC8+b0uAMq6JN
         JBqSL97W7tt9r7QS3Oha31IfsUu2wIpzZlmUZrpgV63ygZXPKhq/vyHf3jzM2uheQA
         0cHbI6cPNqnL6K5d0YcnESfFI5bgf9XVsKDWWF8AVacfyA4ykUv6V9mrqeZp6Np3U2
         2PbJTo2QdaT9lvo7c//PEvbgHSsQRYUBpXS5QKHJDJw5sBmmxPu2kvcYgwQz1W8RBK
         PQhdPmf57OJnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 034/110] net: ipv4: Remove unneed BUG() function
Date:   Mon, 28 Jun 2021 10:17:12 -0400
Message-Id: <20210628141828.31757-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index 2e35f68da40a..1c6429c353a9 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1989,7 +1989,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET_CONF]) {
 		nla_for_each_nested(a, tb[IFLA_INET_CONF], rem)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a9e53f5942fa..eab0a46983c0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5822,7 +5822,7 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla,
 		return -EAFNOSUPPORT;
 
 	if (nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
-		BUG();
+		return -EINVAL;
 
 	if (tb[IFLA_INET6_TOKEN]) {
 		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]),
-- 
2.30.2

