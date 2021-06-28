Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F423B619E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhF1OhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235317AbhF1OfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 223A661C96;
        Mon, 28 Jun 2021 14:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890626;
        bh=mgXBEowT5e3mMtfgwzguw5gUbGsyEEO5SLKXkbKh3QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkL28e1qVZMpyl/ptLkMtSAh3WcqsNjCIru4qAyE9ixwSRalQO8Nhbm0nIViE8EC6
         SgXRu8gA4kR7enzCHmZvExB2FhZg8La6ev0HSCndsHSSGj9VoEFHvU4CAg/uca0dQo
         kl2ijAhRC+Q3VisZ3nGSu04zavGPqOk1EncvMrI+Pj5XDReOHrt3GEDuOTYYBW9vfo
         vddoUkYv1Y9IzhqfQvr1UiooviIS/+O4Fqh8TyCq5mAnZK471qwqbuj40f5HrGSetm
         HsBKS4xRDntyF60NHDYb1bgCYHuw31njgrNmOeBAhH52AIop3FnSiln7pW/jMfQnSr
         gqaL8w3uQZJNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/71] net: ethtool: clear heap allocations for ethtool function
Date:   Mon, 28 Jun 2021 10:29:16 -0400
Message-Id: <20210628143004.32596-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 80ec82e3d2c1fab42eeb730aaa7985494a963d3f ]

Several ethtool functions leave heap uncleared (potentially) by
drivers. This will leave the unused portion of heap unchanged and
might copy the full contents back to userspace.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/ethtool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 76506975d59a..cbd1885f2459 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1508,7 +1508,7 @@ static int ethtool_get_any_eeprom(struct net_device *dev, void __user *useraddr,
 	if (eeprom.offset + eeprom.len > total_len)
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1573,7 +1573,7 @@ static int ethtool_set_eeprom(struct net_device *dev, void __user *useraddr)
 	if (eeprom.offset + eeprom.len > ops->get_eeprom_len(dev))
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1764,7 +1764,7 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 		return -EFAULT;
 
 	test.len = test_len;
-	data = kmalloc_array(test_len, sizeof(u64), GFP_USER);
+	data = kcalloc(test_len, sizeof(u64), GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -2295,7 +2295,7 @@ static int ethtool_get_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	ret = ops->get_tunable(dev, &tuna, data);
@@ -2481,7 +2481,7 @@ static int get_phy_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_phy_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	mutex_lock(&phydev->lock);
-- 
2.30.2

