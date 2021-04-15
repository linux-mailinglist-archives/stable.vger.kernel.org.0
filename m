Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925AE360CDD
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbhDOOzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhDOOx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 940456113B;
        Thu, 15 Apr 2021 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498349;
        bh=adwfwwQMdygbQVB+/u0sDbUshgQoaHvxg2kwUrTHzro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acChM1YBoaEKp2Ee8xqBmKdIZPojrk8Fo5gPDR34xC37AJQfOHAKfXaBXH0XSvxq4
         XrJF0b3uPp30C1li032cG9dIqo4bFAJIGzswjSnE1COfpNsoMvoDuXzRm8qS/NgqFN
         O5nOS9z0x+uvPzWakeRrmKwwH8uGWfK4FQy/Fr58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.9 35/47] net: ieee802154: fix nl802154 del llsec key
Date:   Thu, 15 Apr 2021 16:47:27 +0200
Message-Id: <20210415144414.584873414@linuxfoundation.org>
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

commit 37feaaf5ceb2245e474369312bb7b922ce7bce69 upstream.

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_KEY is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-1-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1627,7 +1627,8 @@ static int nl802154_del_llsec_key(struct
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
-	if (nla_parse_nested(attrs, NL802154_KEY_ATTR_MAX,
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested(attrs, NL802154_KEY_ATTR_MAX,
 			     info->attrs[NL802154_ATTR_SEC_KEY],
 			     nl802154_key_policy))
 		return -EINVAL;


