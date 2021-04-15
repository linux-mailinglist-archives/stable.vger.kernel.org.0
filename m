Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD04360CB6
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhDOOyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233865AbhDOOwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:52:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8411D613D1;
        Thu, 15 Apr 2021 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498306;
        bh=Qkqd7gRqO6pMQ0q5wAI66aq8qCPd0wKRf6sLy1zklss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atpoDgLGnxw+UJKyBSHNWWmbHNfKajxkWBB+FgmuKZojuDxhvah07jjE9sjqtjvOZ
         ptTEKFmxqEWQazpcK4t2qp0Whqqj/9aGGETwI7tTmdGfLTy4D2dzdFWeN0J9DqWnSM
         bbjNP1bKoihrOh8FtD8amN6YlVEK4qHniuRqZ4d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+368672e0da240db53b5f@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.9 38/47] net: ieee802154: fix nl802154 del llsec devkey
Date:   Thu, 15 Apr 2021 16:47:30 +0200
Message-Id: <20210415144414.676104917@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 27c746869e1a135dffc2f2a80715bb7aa00445b4 upstream.

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVKEY is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+368672e0da240db53b5f@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-4-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1958,7 +1958,8 @@ static int nl802154_del_llsec_devkey(str
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
-	if (nla_parse_nested(attrs, NL802154_DEVKEY_ATTR_MAX,
+	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
+	    nla_parse_nested(attrs, NL802154_DEVKEY_ATTR_MAX,
 			     info->attrs[NL802154_ATTR_SEC_DEVKEY],
 			     nl802154_devkey_policy))
 		return -EINVAL;


