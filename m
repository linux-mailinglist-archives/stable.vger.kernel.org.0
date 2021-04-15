Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE42360C62
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhDOOuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233788AbhDOOuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 941146137D;
        Thu, 15 Apr 2021 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498195;
        bh=5OkA6JiwflRrDvlnY8MM9WRQeCcCTJQsr90Sya2fHKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujYWL3iVb+BD1jcfYL/wlPZrH6ws0VmVtUarMslPYuRd8NlW5NLg8G83k/bMXogJC
         bgbAxtXr4b4HUzmGvuRKLrYQ2WHOgac104SNnzz3BqduBn+s9RHEqN3a7LJszuvQ28
         4WFNLhB/CoFLmX0bS4A+8PgSPKWW92fg62htXP8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.4 28/38] net: ieee802154: fix nl802154 del llsec key
Date:   Thu, 15 Apr 2021 16:47:22 +0200
Message-Id: <20210415144414.251777565@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
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
@@ -1577,7 +1577,8 @@ static int nl802154_del_llsec_key(struct
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
-	if (nla_parse_nested(attrs, NL802154_KEY_ATTR_MAX,
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested(attrs, NL802154_KEY_ATTR_MAX,
 			     info->attrs[NL802154_ATTR_SEC_KEY],
 			     nl802154_key_policy))
 		return -EINVAL;


