Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148E6364289
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbhDSNJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239657AbhDSNJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 462EF61279;
        Mon, 19 Apr 2021 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837743;
        bh=MOj3lNOt5Eq3DZ1qqW+goNVNwrEAqRWT8Vk7qnMVCI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/csb6tkSDHIQ9GK3yE0c32pYlM/9aogthLzwfOFZe7QlGvz540UXPu4jjnqawVnD
         rBg+HrgwZ2peH8jqrT5kkb/DECDnensZ30s37ipeqRs07FGtWWCBaJ9m6OvKcqifNO
         vLDN6qk+OkIjELbkzldfe4BeI3fiLOu421Q9D8dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 039/122] net: ieee802154: forbid monitor for del llsec key
Date:   Mon, 19 Apr 2021 15:05:19 +0200
Message-Id: <20210419130531.493840956@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit b6e2949544a183f590ae6f3ef2d1aaaa2c44e38a ]

This patch forbids to del llsec key for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-6-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 6036516ddb9e..47c57347ab7f 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1609,6 +1609,9 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
-- 
2.30.2



