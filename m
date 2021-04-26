Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F261936ACFA
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhDZHbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232229AbhDZHbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:31:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3253061041;
        Mon, 26 Apr 2021 07:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422261;
        bh=H77XajsLMRrhBAPqkJLSrTD6QTKk2CwQNIpgM7uDQCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGCI3UBZzp7lNnldjSt/KqkCfDOqDKoY4dL+2di+kfg/amdKcIbxn9NXDpgg4XdUO
         YgOI2ec7ro+bIlShGqz9T3MIZraZNjTeIK+nVg3fCChJJh7L3AkpTrbCfGWzsDJFlu
         cx6fL3x8hz/gBpfDdtZR19+m2x2uUfhMEnfCxdz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/32] net: ieee802154: forbid monitor for add llsec seclevel
Date:   Mon, 26 Apr 2021 09:29:13 +0200
Message-Id: <20210426072817.112832229@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 9ec87e322428d4734ac647d1a8e507434086993d ]

This patch forbids to add llsec seclevel for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-14-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index f07a3027d66c..b2ff2f7329c3 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2103,6 +2103,9 @@ static int nl802154_add_llsec_seclevel(struct sk_buff *skb,
 	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
 	struct ieee802154_llsec_seclevel sl;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (llsec_parse_seclevel(info->attrs[NL802154_ATTR_SEC_LEVEL],
 				 &sl) < 0)
 		return -EINVAL;
-- 
2.30.2



