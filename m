Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52373A0003
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhFHSi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234350AbhFHSg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:36:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 620D6613E1;
        Tue,  8 Jun 2021 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177157;
        bh=5vTC6qkIRrpHNelYHeJL8pniOFg1DPsjjOyVMCGUroQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xU8pfEMmhO53ubkQMVnjvMBPzjBy0IPEi6bX4J1GehJpSB8lPLf3+zZqq3XBpe7Bl
         9UFiDyluPy1QWIqEboOwx6atd8oPG/0vNupxwdPG/NzNi2PFM2ZIa/om/fhOq1dbs3
         55cUQ40QQo6/wPbL1qZ5+w2YQgt+h7eXEtLMEbV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/47] ieee802154: fix error return code in ieee802154_add_iface()
Date:   Tue,  8 Jun 2021 20:26:54 +0200
Message-Id: <20210608175930.849166357@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
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
index dc2960be51e0..6a7fe415d5f4 100644
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



