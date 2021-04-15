Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E530C360CD3
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbhDOOys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234101AbhDOOwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB0E961131;
        Thu, 15 Apr 2021 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498303;
        bh=WLwkVW7ARwuad7wlX3HpAR9iso5njstDWOSAv4yxZac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdQe/ir1copZynptqPJV73X4VifZv80NvZZd8jF7MRNEH5BMDpWw+/xyGeUA/21Nw
         HxjicLiRL0rlKn6Q6rRNd76pS/xC1aq3iVzFTj8+wNpJ3yu56L22EWs19VCmeLB56N
         x1D1Fw63+NJGRtiZbN6HAhyWr7iHXqk+A6Xi93GU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ce4e062c2d51977ddc50@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.9 37/47] net: ieee802154: fix nl802154 add llsec key
Date:   Thu, 15 Apr 2021 16:47:29 +0200
Message-Id: <20210415144414.646084458@linuxfoundation.org>
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
@@ -1577,7 +1577,8 @@ static int nl802154_add_llsec_key(struct
 	struct ieee802154_llsec_key_id id = { };
 	u32 commands[NL802154_CMD_FRAME_NR_IDS / 32] = { };
 
-	if (nla_parse_nested(attrs, NL802154_KEY_ATTR_MAX,
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested(attrs, NL802154_KEY_ATTR_MAX,
 			     info->attrs[NL802154_ATTR_SEC_KEY],
 			     nl802154_key_policy))
 		return -EINVAL;


