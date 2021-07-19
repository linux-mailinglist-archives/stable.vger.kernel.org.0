Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88AC3CDD89
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244172AbhGSO6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244286AbhGSO5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F1BD613E7;
        Mon, 19 Jul 2021 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708919;
        bh=jnX3ZWyzm0tgA7dP3/G4POhlBmr/gPJJ135MSZMyjDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utlO9muU8HHHhIop5TebNWebJdN2LS6iNj7oWx+6/Bsp5qUQJa7OSrSp7f0Yf3TV2
         XMEafF8qCVbrSvcwoIWPgpyT0yTktHtFHx1Sl/iWos8R2OZ4rVXRZa7TD9f5RsNxxy
         ItOf8SGV9Tos7UJIx0Gjw5yY/7+FvBPIdJIyeIpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        syzbot <syzkaller@googlegroups.com>,
        Alexander Aring <aahringo@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/421] ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
Date:   Mon, 19 Jul 2021 16:49:20 +0200
Message-Id: <20210719144951.641353844@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0303b30375dff5351a79cc2c3c87dfa4fda29bed ]

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
must be present to avoid a crash.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210621180244.882076-1-eric.dumazet@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 6cda4aa4f680..06aadebc2d5b 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -496,7 +496,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	struct hwsim_edge *e;
 	u32 v0, v1;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-- 
2.30.2



