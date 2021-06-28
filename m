Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130F43B6000
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhF1OVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhF1OV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 755C361C76;
        Mon, 28 Jun 2021 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889941;
        bh=IOgvidZQzMgo5df7Ci7e10eBB5bc9HzdtFcfIKzNLOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdZzcfdJHneYIpg6pMMHGUiOHvAgKwjQVw1WvTyRgqjr/Z6Xl9/J33v+lgQ6+YZ7q
         IWUH97AhOD+YuJ1eHP8Z4+Q6NBb+AZ5nWepzXpE+JJWwYuymRmB1qXdFKj5udjb9oo
         J8aFxmQlQix18sO9fG5GNEAPmPm/1Jco3e57NbP+ZxyY9y2KfyBVRpTQDxIN1VZkdG
         D5ZoLiR2UNfCIW43sOpq9+DrZ+oG+uweDCyScB1ouuClXndkBckUKZSr0tmBkYo+MG
         9UMNHdzQy0ULXYsmmLV/LZk7aN1XpLdebsIAqqa77N4DkgY9EoAiznZ0aN33YC5FIx
         GcEzbNJ1yAJxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 036/110] net: ethtool: clear heap allocations for ethtool function
Date:   Mon, 28 Jun 2021 10:17:14 -0400
Message-Id: <20210628141828.31757-37-sashal@kernel.org>
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

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 80ec82e3d2c1fab42eeb730aaa7985494a963d3f ]

Several ethtool functions leave heap uncleared (potentially) by
drivers. This will leave the unused portion of heap unchanged and
might copy the full contents back to userspace.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 2603966da904..e910890a868c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1421,7 +1421,7 @@ static int ethtool_get_any_eeprom(struct net_device *dev, void __user *useraddr,
 	if (eeprom.offset + eeprom.len > total_len)
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1486,7 +1486,7 @@ static int ethtool_set_eeprom(struct net_device *dev, void __user *useraddr)
 	if (eeprom.offset + eeprom.len > ops->get_eeprom_len(dev))
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1765,7 +1765,7 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 		return -EFAULT;
 
 	test.len = test_len;
-	data = kmalloc_array(test_len, sizeof(u64), GFP_USER);
+	data = kcalloc(test_len, sizeof(u64), GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -2281,7 +2281,7 @@ static int ethtool_get_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	ret = ops->get_tunable(dev, &tuna, data);
@@ -2473,7 +2473,7 @@ static int get_phy_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_phy_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	if (phy_drv_tunable) {
-- 
2.30.2

