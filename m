Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9672736ACF3
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhDZHbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhDZHbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6196105A;
        Mon, 26 Apr 2021 07:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422253;
        bh=4FeshScoE5rjsIeeqF1Oq7dqaostnzgo3Zk8RCt2ys8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PE3QSVPNDq/3YyPyXJ/UHiOUZko2xJS/DrNHM9w2VmulxPvh09gJa4nZMjhSrdX+y
         s89nLkY+vUyPp7SIx455Qv0xcXj9m/o0pMB+rXRAL5L3mLygmGvpiA7BBtxYhZFZhZ
         fbtVzT1oBBuxqLsGEA9g71hD/KE3rC3QTaiuTkqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/32] net: ieee802154: stop dump llsec devkeys for monitors
Date:   Mon, 26 Apr 2021 09:29:10 +0200
Message-Id: <20210426072817.009509484@linuxfoundation.org>
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

[ Upstream commit 080d1a57a94d93e70f84b7a360baa351388c574f ]

This patch stops dumping llsec devkeys for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-10-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index a602fd45e384..19d0d22ff625 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1839,6 +1839,11 @@ nl802154_dump_llsec_devkey(struct sk_buff *skb, struct netlink_callback *cb)
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



