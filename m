Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70723A9F2A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhFPPgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234332AbhFPPgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9E886100B;
        Wed, 16 Jun 2021 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857649;
        bh=vqjqIDbMlYZPAfIgI/fP7LY+EVjhIGlykwYrcE7qBug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rz7uY9CzgxaKNIiH25iI/1fhV5MbEgznm1kkW0jb2vOYOfi5qAYru0YL/jyRjX2lB
         1pZ5AS8UV9tZ9OeMf3l3Ketdxu3j15lmAa/E6AkC4PqooIam5fm6F+1QqJy3IqM103
         8OQo4y/CJK5kOFWn1sm54oVvr+HgYO2LTiHNAMWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Robertson <dan@dlrobertson.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/28] net: ieee802154: fix null deref in parse dev addr
Date:   Wed, 16 Jun 2021 17:33:12 +0200
Message-Id: <20210616152834.197328744@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 328bb9f5342e..b2ba1d2556f1 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1314,19 +1314,20 @@ ieee802154_llsec_parse_dev_addr(struct nlattr *nla,
 	if (!nla || nla_parse_nested_deprecated(attrs, NL802154_DEV_ADDR_ATTR_MAX, nla, nl802154_dev_addr_policy, NULL))
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



