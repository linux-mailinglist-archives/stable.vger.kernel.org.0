Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17F836AD79
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhDZHgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232531AbhDZHgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7153611CE;
        Mon, 26 Apr 2021 07:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422440;
        bh=xrPLNgO19sbVk5VB2f6faoNOfD7T50fssk/vyzokIVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDQn5d1U8roiEfv/4NbhSotp/9PsuZf4i1HY4efWzq8A5UnW/LnjdvPpaybTIfzkJ
         2+RroT3xKUhaY01Enyt2TM7y2MTCu0PRWXA+hy549FyTtbZkBlOrK6lxN2Zo/e5OId
         XYCup2z/WGFCIFby9UCAUTSfpJqrdR+cb32wrzKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/49] net: ieee802154: stop dump llsec devkeys for monitors
Date:   Mon, 26 Apr 2021 09:29:09 +0200
Message-Id: <20210426072820.174769744@linuxfoundation.org>
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
index d1e309de88b6..6d9fc2947dd8 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1874,6 +1874,11 @@ nl802154_dump_llsec_devkey(struct sk_buff *skb, struct netlink_callback *cb)
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



