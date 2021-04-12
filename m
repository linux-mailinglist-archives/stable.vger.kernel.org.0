Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DA235BD88
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238468AbhDLIwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238525AbhDLIuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 947716128E;
        Mon, 12 Apr 2021 08:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217374;
        bh=yW0jIMGPGHRw72K+x/b/Kv8xZLB44grlq2YQLitqU4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSp9Yzl0IaQDGAxqbcQoT3FkZSAc1CGymAU4xhJpRHLxAyZFP1mGkpAA5s3zbfuij
         YKCPB/xuryCWls9wI4qvsV4C88pJ2E/aGfClAbos0Dfzjmt0uMMilNvQ/SVroKgSKC
         Qn0y4z5moH/ISFVL/e80Drgycgc+s+n8HOZ7IwUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.4 103/111] net: ieee802154: nl-mac: fix check on panid
Date:   Mon, 12 Apr 2021 10:41:21 +0200
Message-Id: <20210412084007.689265204@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 6f7f657f24405f426212c09260bf7fe8a52cef33 upstream.

This patch fixes a null pointer derefence for panid handle by move the
check for the netlink variable directly before accessing them.

Reported-by: syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210228151817.95700-4-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl-mac.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ieee802154/nl-mac.c
+++ b/net/ieee802154/nl-mac.c
@@ -551,9 +551,7 @@ ieee802154_llsec_parse_key_id(struct gen
 	desc->mode = nla_get_u8(info->attrs[IEEE802154_ATTR_LLSEC_KEY_MODE]);
 
 	if (desc->mode == IEEE802154_SCF_KEY_IMPLICIT) {
-		if (!info->attrs[IEEE802154_ATTR_PAN_ID] &&
-		    !(info->attrs[IEEE802154_ATTR_SHORT_ADDR] ||
-		      info->attrs[IEEE802154_ATTR_HW_ADDR]))
+		if (!info->attrs[IEEE802154_ATTR_PAN_ID])
 			return -EINVAL;
 
 		desc->device_addr.pan_id = nla_get_shortaddr(info->attrs[IEEE802154_ATTR_PAN_ID]);
@@ -562,6 +560,9 @@ ieee802154_llsec_parse_key_id(struct gen
 			desc->device_addr.mode = IEEE802154_ADDR_SHORT;
 			desc->device_addr.short_addr = nla_get_shortaddr(info->attrs[IEEE802154_ATTR_SHORT_ADDR]);
 		} else {
+			if (!info->attrs[IEEE802154_ATTR_HW_ADDR])
+				return -EINVAL;
+
 			desc->device_addr.mode = IEEE802154_ADDR_LONG;
 			desc->device_addr.extended_addr = nla_get_hwaddr(info->attrs[IEEE802154_ATTR_HW_ADDR]);
 		}


