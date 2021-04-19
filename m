Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F958364463
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242306AbhDSN1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240964AbhDSNZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:25:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D0F4613D0;
        Mon, 19 Apr 2021 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838456;
        bh=DH2d+rXdIxqFHtMDc/RFR+G/TO+wsk2hqQDcAwBt9yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSSinn9HJ8MAru88e9+vbvlmg2K6J3r8WyRjBrszbbr9reY4oRVgCBAQJOQO7+PEj
         d9lwitrsBR16yJBVtL90VrU4HA7vm9+/n5mWwDgyfUgZi2L3T2gAiCevBhwUG/OZKy
         JMfDtkNtVCh9JNy7RI7s3dtzFwxUqL4VkYULVcTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/73] net: ieee802154: forbid monitor for add llsec devkey
Date:   Mon, 19 Apr 2021 15:06:22 +0200
Message-Id: <20210419130524.846635044@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit a347b3b394868fef15b16f143719df56184be81d ]

This patch forbids to add llsec devkey for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-11-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 66785e1eb559..65987215dd0c 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1936,6 +1936,9 @@ static int nl802154_add_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack) < 0)
 		return -EINVAL;
-- 
2.30.2



