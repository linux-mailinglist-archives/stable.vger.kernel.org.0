Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17909364283
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbhDSNJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239441AbhDSNJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C28A161284;
        Mon, 19 Apr 2021 13:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837738;
        bh=uBjCiouy9P3DmNyubrJxBRx3KfFd+SJPhnjwjMShei4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqNGgU4D5NVONtJZF5bE2e+hwTfQq4PkQstiqgXL2Bh2t18Mlv/wiht1Az3G46C09
         Yy7bKOOBszQdm8BLTOOTgbfWGgMvPD0AMcQvov3CVWtGaBSMbwBuZjbio7xfVvngEB
         7BXT/Qp4ECfOTx3sZ/jw8Gs1LWFfn3YxIzRotTGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 037/122] net: ieee802154: stop dump llsec keys for monitors
Date:   Mon, 19 Apr 2021 15:05:17 +0200
Message-Id: <20210419130531.429544851@linuxfoundation.org>
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

[ Upstream commit fb3c5cdf88cd504ef11d59e8d656f4bc896c6922 ]

This patch stops dumping llsec keys for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-4-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index d1b6a9665b17..a7cb28a78c6f 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1498,6 +1498,11 @@ nl802154_dump_llsec_key(struct sk_buff *skb, struct netlink_callback *cb)
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



