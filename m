Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02A364296
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbhDSNKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239669AbhDSNJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A676135F;
        Mon, 19 Apr 2021 13:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837766;
        bh=th2sy2QPFiBQ72aTkzx7P+bfQPfiypMTkB/214gxSkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmWZpNvibyOjxTNIgerXk/lOxzQKYapZmT8BpQYvT9UDe3z0QNQhGRURsJHnUXimh
         L9A/piKrloT5zLdYPL79+LuL5M/2ByoWADMofFA4B6jSG3Nuzm5XrCLFkrUwa3EMRu
         3haHGHm89tHvPOOpn4MIZu0Snyw6DBnBEQ/mcptc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 046/122] net: ieee802154: stop dump llsec seclevels for monitors
Date:   Mon, 19 Apr 2021 15:05:26 +0200
Message-Id: <20210419130531.738936526@linuxfoundation.org>
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
index 87dac717d197..10fc37e45e2b 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2031,6 +2031,11 @@ nl802154_dump_llsec_seclevel(struct sk_buff *skb, struct netlink_callback *cb)
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



