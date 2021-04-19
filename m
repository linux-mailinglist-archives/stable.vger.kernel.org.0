Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFCD364286
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhDSNJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239635AbhDSNJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81276613C1;
        Mon, 19 Apr 2021 13:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837741;
        bh=SLmw5DkvOeGCsvqE0N1/OoGYpkBkvaWML8/+TmvQMpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqCXCk7315N6hVK4rEBvm+h1ieWwWJvgVuTP/eSTxC2dlVACFPXa/w+KD7FSmnjZa
         wWeN7wbHyYXqE8xHHwKX6KbPhLeV0qn74mY9yaW7Wijfyon3ojAlzkEBj8Y1InTEUe
         YA7Azuy2mUvw83gAYtVMiQhjcxVTLVWtH84pViuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 038/122] net: ieee802154: forbid monitor for add llsec key
Date:   Mon, 19 Apr 2021 15:05:18 +0200
Message-Id: <20210419130531.462284523@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 08470c5453339369bd3d590c4cbb0b5961cdcbb6 ]

This patch forbids to add llsec key for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-5-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index a7cb28a78c6f..6036516ddb9e 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1557,6 +1557,9 @@ static int nl802154_add_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct ieee802154_llsec_key_id id = { };
 	u32 commands[NL802154_CMD_FRAME_NR_IDS / 32] = { };
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
-- 
2.30.2



