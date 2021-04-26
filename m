Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4489A36ACF0
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhDZHbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhDZHbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:31:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5555D610FC;
        Mon, 26 Apr 2021 07:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422248;
        bh=FvKjlavU5MlcMd3lD/KKm2/vARo0gUp5iMGK3EASYTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVsSfaW5YyeQOLm6uWL7JSqL0HyoRlOzGtkeu02ehDfr2xOCj5Rym5GXJFcT5YQ05
         NI2G0li2v8/E3hmG6LzludFbF/iPkNntLiTLSiDTJW8M15aMv9n4wLo6O2lrXcLSuE
         oTKCE/fX6TJ5tTNh+vQnmb03MKOPOEl/WX8CvOK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/32] net: ieee802154: stop dump llsec devs for monitors
Date:   Mon, 26 Apr 2021 09:29:08 +0200
Message-Id: <20210426072816.949047770@linuxfoundation.org>
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
index 78a0edf26854..e4ba6764c4a3 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1658,6 +1658,11 @@ nl802154_dump_llsec_dev(struct sk_buff *skb, struct netlink_callback *cb)
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



