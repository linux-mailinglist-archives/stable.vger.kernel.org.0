Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9745136AD36
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhDZHdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232405AbhDZHdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 794906105A;
        Mon, 26 Apr 2021 07:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422339;
        bh=gxt9tlOQ+NPXUkGYP5yl4aUTqDFJin97IC2ylArP0Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1upDSItn1e/WkdMgWaw5tpRSJbPwnRHtPv0dHCx3UGm2IEeudtctGq1Jf4iXDWt4B
         EY+NqhsDotw9SBwTUATYFLimPQPWns/P8PEF7XhMUxk2n2pERcVXOTM3QhVW46GQNB
         5MskJ6TAGXh8eYBaD4cS5MmZcVKUzN98gcKrbar4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/37] net: ieee802154: forbid monitor for add llsec dev
Date:   Mon, 26 Apr 2021 09:29:12 +0200
Message-Id: <20210426072817.636564685@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 5303f956b05a2886ff42890908156afaec0f95ac ]

This patch forbids to add llsec dev for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-8-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 65439c20db7a..c724479a86c9 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1800,6 +1800,9 @@ static int nl802154_add_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
 	struct ieee802154_llsec_device dev_desc;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (ieee802154_llsec_parse_device(info->attrs[NL802154_ATTR_SEC_DEVICE],
 					  &dev_desc) < 0)
 		return -EINVAL;
-- 
2.30.2



