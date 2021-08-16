Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3ED3ED487
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhHPNDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235519AbhHPNDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A456328A;
        Mon, 16 Aug 2021 13:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629118998;
        bh=0Y+UGSUaIFwszoF8jOH64qXLAOMVYhTCUgH3DslBrkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vs1Z+7BhlIZ0jUT3FYFWOc4T7UUR54iBjWf/QJRzwZxcM+OeweqRyL0w3Ja8M2ekX
         1L5kPxc9XFWezb047DUO+E8QyWye5cwo5KWxt0G26ZU9aWLlV/c7ABynni8y/N7J9A
         G5DEFzgtA4zpqrsIo//LA45ujogq5hfw2dMrxM98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/62] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
Date:   Mon, 16 Aug 2021 15:01:42 +0200
Message-Id: <20210816125428.545891631@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit e9faf53c5a5d01f6f2a09ae28ec63a3bbd6f64fd ]

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE,
MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID and MAC802154_HWSIM_EDGE_ATTR_LQI
must be present to fix GPF.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210705131321.217111-1-mudongliangabcd@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 79d74763cf24..da7f8cc9b181 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -528,14 +528,14 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 	u32 v0, v1;
 	u8 lqi;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
 	if (nla_parse_nested_deprecated(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX, info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE], hwsim_edge_policy, NULL))
 		return -EINVAL;
 
-	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] &&
+	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] ||
 	    !edge_attrs[MAC802154_HWSIM_EDGE_ATTR_LQI])
 		return -EINVAL;
 
-- 
2.30.2



