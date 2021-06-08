Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882913A0013
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhFHSkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234821AbhFHShO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:37:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11A65613DF;
        Tue,  8 Jun 2021 18:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177176;
        bh=UtuUwZ6YaJufvVbQdpEWkVaMmtDonz+bzzQcXOf546k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qr82zGnTIqWHvEB5+Xc0/rd51z23WXEg3NlIojJwHooEHOob2SOaEj+1Ie0xJp51A
         F7yVDqu7o+cRlJPH5ftVR4n7RVi1pA1zT7FZ/r2VZtY53BJVmfa1UeMqIYPq1QN17j
         48CH1WRc8aAHf41pyqZ/gQr0nV6mD6r5ga5mgz1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/58] ieee802154: fix error return code in ieee802154_add_iface()
Date:   Tue,  8 Jun 2021 20:26:55 +0200
Message-Id: <20210608175932.757112652@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
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
index b231e40f006a..ca1dd9ff07ab 100644
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



