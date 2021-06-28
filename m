Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957BC3B61F9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhF1Okj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235189AbhF1Ojc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:39:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5098E61C75;
        Mon, 28 Jun 2021 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890788;
        bh=jJYjTdoHxHUi8n/6g8UQTWTBJcpkxStl1jXbNNZZ7Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujLeGYRss4gqCehv6L4KcCH50jzJJrnRrp9Xcx+kQpjISWukxCePpSiyH5jFWMH0D
         zgdpaCN0ktw0uN6AEU+yFteG+lylBHMlzVAnOF2ehC0j8Lr+y4R/iw53OFPmzbR91p
         cn5OHhoWbfXT2s5ldTAA95KcBQbOcntMkZOZCAMUNxxXGU2KmW6UrRmuq/zbzgqZpD
         rxaPWegzw1YgiW69S6SztkRtnqruk9uN2kVYyOjqvQgaF0p1GwJJz1UubxIJdsWmSm
         0ze6GSHmnjYrdHVDCWXZdkUnS+zx0dvktPKQJah3O2Qk89tQGynyCEwTE35ArebI9z
         oSTSupwxLYbgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/109] net: ieee802154: fix null deref in parse dev addr
Date:   Mon, 28 Jun 2021 10:31:17 -0400
Message-Id: <20210628143305.32978-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Robertson <dan@dlrobertson.com>

[ Upstream commit 9fdd04918a452980631ecc499317881c1d120b70 ]

Fix a logic error that could result in a null deref if the user sets
the mode incorrectly for the given addr type.

Signed-off-by: Dan Robertson <dan@dlrobertson.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210423040214.15438-2-dan@dlrobertson.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index b1c55db73764..6d4c71a52b6b 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1315,19 +1315,20 @@ ieee802154_llsec_parse_dev_addr(struct nlattr *nla,
 				     nl802154_dev_addr_policy, NULL))
 		return -EINVAL;
 
-	if (!attrs[NL802154_DEV_ADDR_ATTR_PAN_ID] ||
-	    !attrs[NL802154_DEV_ADDR_ATTR_MODE] ||
-	    !(attrs[NL802154_DEV_ADDR_ATTR_SHORT] ||
-	      attrs[NL802154_DEV_ADDR_ATTR_EXTENDED]))
+	if (!attrs[NL802154_DEV_ADDR_ATTR_PAN_ID] || !attrs[NL802154_DEV_ADDR_ATTR_MODE])
 		return -EINVAL;
 
 	addr->pan_id = nla_get_le16(attrs[NL802154_DEV_ADDR_ATTR_PAN_ID]);
 	addr->mode = nla_get_u32(attrs[NL802154_DEV_ADDR_ATTR_MODE]);
 	switch (addr->mode) {
 	case NL802154_DEV_ADDR_SHORT:
+		if (!attrs[NL802154_DEV_ADDR_ATTR_SHORT])
+			return -EINVAL;
 		addr->short_addr = nla_get_le16(attrs[NL802154_DEV_ADDR_ATTR_SHORT]);
 		break;
 	case NL802154_DEV_ADDR_EXTENDED:
+		if (!attrs[NL802154_DEV_ADDR_ATTR_EXTENDED])
+			return -EINVAL;
 		addr->extended_addr = nla_get_le64(attrs[NL802154_DEV_ADDR_ATTR_EXTENDED]);
 		break;
 	default:
-- 
2.30.2

