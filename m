Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF06E360CDE
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhDOOzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhDOOx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7329C613D7;
        Thu, 15 Apr 2021 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498352;
        bh=2W8o1gYyf2lPNJY4lrbNxni64c6yxSIkHaHfmmrXssw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKSvdldTIq91Q/i1PW+iHk6BByyvC7a2xl+v+qY++erhkz8ARFyndxT3jvP5qYXSI
         gk1IjuQNJUgSx9xqKWxEe1+chUG/gXL75uu4TR6/Plp0hj4aQCfwWeJFlYKVsROaEz
         y29UBh2ozTyWUTKA8M3SZVGt+rQbUztHpuZepM9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.9 36/47] net: ieee802154: fix nl802154 del llsec dev
Date:   Thu, 15 Apr 2021 16:47:28 +0200
Message-Id: <20210415144414.615063660@linuxfoundation.org>
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

commit 3d1eac2f45585690d942cf47fd7fbd04093ebd1b upstream.

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVICE is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-2-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1796,7 +1796,8 @@ static int nl802154_del_llsec_dev(struct
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
-	if (nla_parse_nested(attrs, NL802154_DEV_ATTR_MAX,
+	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
+	    nla_parse_nested(attrs, NL802154_DEV_ATTR_MAX,
 			     info->attrs[NL802154_ATTR_SEC_DEVICE],
 			     nl802154_dev_policy))
 		return -EINVAL;


