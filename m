Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F48F35C09F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbhDLJPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240986AbhDLJLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CAD0613BB;
        Mon, 12 Apr 2021 09:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218468;
        bh=T7ctZXYqO06OR0cvvrBKZIWHWg1yBFL1L2DKcQQZhAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9Am7hZ8sif1l6ZaGzcN5mAWwLQ7GNY1GVPjnEkRTo4nOLfkYKZ83K6vhyCmAP1HI
         FObeWZRoE9EQ7jS9dJ/qN5kLw/LcowNEd1Ks69g437ruCR8j6gAY9AeAXX+l9Fwj69
         qrMbFHCCBp0RjfQIwz9gRdljveqh4Fi2n/o9C8FQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.11 203/210] net: ieee802154: fix nl802154 del llsec key
Date:   Mon, 12 Apr 2021 10:41:48 +0200
Message-Id: <20210412084022.753947883@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
@@ -1592,7 +1592,8 @@ static int nl802154_del_llsec_key(struct
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (ieee802154_llsec_parse_key_id(attrs[NL802154_KEY_ATTR_ID], &id) < 0)


