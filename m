Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC4035C0A6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhDLJPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241001AbhDLJLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01B1F613B6;
        Mon, 12 Apr 2021 09:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218474;
        bh=Xi9CV/Pr9Z+Uy9JQ5IW4ozpJbxhLGXtsRnMMgblsTio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xv4cyhdV3VH9kvbFc7aXoImHhuGomcucE6xnq30hSTnbMeIdhAhseg4if/wuSxrfm
         v7UgdRFHdLolTsT+gduEK2MS74yHnpld/cE4b/4mn4NKpUC+uY+5bfVCF0UQPiESud
         R6T00eDSHZjHKXMCmfIhCABPohdvhFw0muupnD34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ce4e062c2d51977ddc50@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.11 205/210] net: ieee802154: fix nl802154 add llsec key
Date:   Mon, 12 Apr 2021 10:41:50 +0200
Message-Id: <20210412084022.823738046@linuxfoundation.org>
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

commit 20d5fe2d7103f5c43ad11a3d6d259e9d61165c35 upstream.

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_KEY is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+ce4e062c2d51977ddc50@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-3-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1544,7 +1544,8 @@ static int nl802154_add_llsec_key(struct
 	struct ieee802154_llsec_key_id id = { };
 	u32 commands[NL802154_CMD_FRAME_NR_IDS / 32] = { };
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_KEY_ATTR_USAGE_FRAMES] ||


