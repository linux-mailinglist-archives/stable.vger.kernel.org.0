Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F5235BCD1
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbhDLIp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237747AbhDLIpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:45:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EF9961246;
        Mon, 12 Apr 2021 08:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217090;
        bh=LO7YwfIm5hEC50Aj+yN9I5w4WLEye4vQ50dCqVN9Zfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fi9sMRp4Kx8nc98qu8XETFcjdEJ9A8GpEdb+JPmPsX7wl0iLhmYLQ/Vo1mwYTFTYl
         Jooc4IlbTL5e9Z59QtqZ5KhXNhTOD6AcuD+i8gY9Fdj4dC5kx6YAbsifr8ftEybVCU
         nlNLTzSKub4GFBmSewiIReKjl9X4Sgkva4FLOE0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.19 65/66] net: ieee802154: stop dump llsec params for monitors
Date:   Mon, 12 Apr 2021 10:41:11 +0200
Message-Id: <20210412084000.229034468@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 1534efc7bbc1121e92c86c2dabebaf2c9dcece19 upstream.

This patch stops dumping llsec params for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Reported-by: syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-16-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -836,8 +836,13 @@ nl802154_send_iface(struct sk_buff *msg,
 		goto nla_put_failure;
 
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		goto out;
+
 	if (nl802154_get_llsec_params(msg, rdev, wpan_dev) < 0)
 		goto nla_put_failure;
+
+out:
 #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
 
 	genlmsg_end(msg, hdr);


