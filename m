Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2245B35BEF4
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbhDLJC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239561AbhDLJAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A8186120F;
        Mon, 12 Apr 2021 08:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217898;
        bh=4trjmpS7ibTSaI8FY44gXs6d7APbhSqm82axIYI7A/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFftER5fCCfd1GkIdh1cMPiKK582DmgRkyEddtCLw+WQNU3mFNm31RTlAoG2VYn5E
         qtbljQCeFB7fLFf24DySLQu6gsCAVheKBUhhmNiBUVeLvEVwrDnk5lG2yBWDlViuLF
         UbAhwhk7jEFizuCetVwENm4dbJLX/63WoTzqTpvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.10 187/188] net: ieee802154: stop dump llsec params for monitors
Date:   Mon, 12 Apr 2021 10:41:41 +0200
Message-Id: <20210412084019.833704503@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
@@ -820,8 +820,13 @@ nl802154_send_iface(struct sk_buff *msg,
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


