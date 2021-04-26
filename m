Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC6E36AD77
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhDZHgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232848AbhDZHgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF24E611CA;
        Mon, 26 Apr 2021 07:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422433;
        bh=I7PYvHwZ4lj3eYf3iAnYbEyuUuDw2XXb15b6wJYl3Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QvcgtGQF6c6Jvwc0AATss0bQEIiz/cC+dbbv04Nbs4ruRHmn6GW/XHrRwo8NgKpO
         BFG4N4YCGbV5iTzYWt3akBYZ+mqxPVqJNK003NMyLY9icnJadP5iu1MrwbilaCAFOV
         i/cKE7+1VFG+ckR89D94CIhDTJvbSSrOlGjhoOUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/49] net: ieee802154: stop dump llsec keys for monitors
Date:   Mon, 26 Apr 2021 09:29:06 +0200
Message-Id: <20210426072820.067379906@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
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
index b10b297e76b7..86bc714a93a8 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1516,6 +1516,11 @@ nl802154_dump_llsec_key(struct sk_buff *skb, struct netlink_callback *cb)
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



