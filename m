Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15BA3643B5
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbhDSNVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241153AbhDSNUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD0C8613DF;
        Mon, 19 Apr 2021 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838141;
        bh=n/psE5//e7MVSbrLnfMHWjNT60Q7bSFQ4VTxo3FOOvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wr0+98dsgS2RnbL/OkwHUZpBgxuO14yGI7FOSFakZflQGy+h3cnwN+aSuhYDVCdeo
         B2RCA2XNu05OrNQfLgKTzUWAevq9tpkeGHnA7AT9nQePOQBSS/MagXZEeV17hz2WxV
         a48830C/njnYmvVFIqDgR084IPWHJoNytUJLVgYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/103] net: ieee802154: forbid monitor for add llsec seclevel
Date:   Mon, 19 Apr 2021 15:05:51 +0200
Message-Id: <20210419130529.181433733@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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
index 10fc37e45e2b..f0b47d43c9f6 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2120,6 +2120,9 @@ static int nl802154_add_llsec_seclevel(struct sk_buff *skb,
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



