Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AA9364459
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242252AbhDSN0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240635AbhDSNZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:25:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9894613D2;
        Mon, 19 Apr 2021 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838444;
        bh=vOJiQuediU3sfss0MR0TKKw3QbQKVUBt6bYRR+0MtLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hG4GGcjxWbL2HGRlhQSN3oSmMFLthBwh8gfuPu5IJ4bBJMDdf3xaAFxhqC/fMLw0K
         GRTbXIULhQMoRS9Qbw976rs9H3UzIVxlAUQPVGtMAb19hsRHg3lD2nAkPRjZEqncp4
         Uf4ULfRZSiaM1dyPYmb8jWyaa9s0sPz7xA4Ed9Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/73] net: ieee802154: stop dump llsec devs for monitors
Date:   Mon, 19 Apr 2021 15:06:18 +0200
Message-Id: <20210419130524.710747014@linuxfoundation.org>
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

[ Upstream commit 5582d641e6740839c9b83efd1fbf9bcd00b6f5fc ]

This patch stops dumping llsec devs for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-7-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 7fdcbaecc4fd..97074180c2e5 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1693,6 +1693,11 @@ nl802154_dump_llsec_dev(struct sk_buff *skb, struct netlink_callback *cb)
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



