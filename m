Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA236ACF8
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhDZHbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232216AbhDZHbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 858D261006;
        Mon, 26 Apr 2021 07:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422259;
        bh=wBHzP7ippDZ5TEjuEukfRt7IGycj9w2ySWUjjv0Fqbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aABHgS2akdAOI3XZs1Y9g3JqLM+ATR/XPGeVOMxDNet7S5b8X0xF8SY046L3yP/q8
         /nl/sW4N2quuqmEVmCP8ZQSYybXU9GFEBjAzYp+DU3icEy3UrKGwgJ4EEIkaFDUq1U
         c6myxhdOuDgKLWmKgZzW7A01CKyVZ75WOTF5lIJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/32] net: ieee802154: stop dump llsec seclevels for monitors
Date:   Mon, 26 Apr 2021 09:29:12 +0200
Message-Id: <20210426072817.073119190@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 4c9b4f55ad1f5a4b6206ac4ea58f273126d21925 ]

This patch stops dumping llsec seclevels for monitors which we don't
support yet. Otherwise we will access llsec mib which isn't initialized
for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-13-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 4ee080f3a41d..f07a3027d66c 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2013,6 +2013,11 @@ nl802154_dump_llsec_seclevel(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err)
 		return err;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR) {
+		err = skb->len;
+		goto out_err;
+	}
+
 	if (!wpan_dev->netdev) {
 		err = -EINVAL;
 		goto out_err;
-- 
2.30.2



