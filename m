Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87C73ED5D9
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhHPNPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237512AbhHPNNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D997360E78;
        Mon, 16 Aug 2021 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119470;
        bh=vTyhIvRqrY6Qbqp33hQldxnTpGxcoeQgKkmxC7w+yxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHFYEJPjVnfq4Fk61h3W5gAOd7L7Dpq54DAeL0NOcT/HPB0dr3ry8Eba9WFpSMHtT
         p8/JmPl0ktJ7nmLiK3QvMJOm5ljEPcjImT11azPTeD8tAeD7e+5XXwP65Vlmpoi0fu
         Qdwi6k2fr/TGTWUnajIL++KttDGI0I2FXCevvP44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 039/151] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
Date:   Mon, 16 Aug 2021 15:01:09 +0200
Message-Id: <20210816125445.369687925@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
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
index ebc976b7fcc2..cae52bfb871e 100644
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



