Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4EB39FF69
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhFHSc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234342AbhFHScL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E82A613CA;
        Tue,  8 Jun 2021 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177018;
        bh=cq+BDAlz6yVWbPDX5SFSPBUVhukvOyz3I7Ra/jMwicA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2rZuXdjrWZuWTGEUOZ12XpVvIyWodtZMpIo3WAIw3vKDE2yK41JygYkZTeTcoIFn
         XlZWk1sF0GlXYomY1QvL8Yg4AE9Yq/naKswSB2kRgrQQikWl1cLN3LOn/LRk+Yf1x5
         yLOsmQD/3yUn7KVdH1zQsbJzWQknPhcSGUx/jPMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/29] ieee802154: fix error return code in ieee802154_add_iface()
Date:   Tue,  8 Jun 2021 20:27:05 +0200
Message-Id: <20210608175928.184179568@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 79c6b8ed30e54b401c873dbad2511f2a1c525fd5 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: be51da0f3e34 ("ieee802154: Stop using NLA_PUT*().")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210508062517.2574-1-thunder.leizhen@huawei.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl-phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
index 77d73014bde3..11f53dc0c1c0 100644
--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -249,8 +249,10 @@ int ieee802154_add_iface(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (nla_put_string(msg, IEEE802154_ATTR_PHY_NAME, wpan_phy_name(phy)) ||
-	    nla_put_string(msg, IEEE802154_ATTR_DEV_NAME, dev->name))
+	    nla_put_string(msg, IEEE802154_ATTR_DEV_NAME, dev->name)) {
+		rc = -EMSGSIZE;
 		goto nla_put_failure;
+	}
 	dev_put(dev);
 
 	wpan_phy_put(phy);
-- 
2.30.2



