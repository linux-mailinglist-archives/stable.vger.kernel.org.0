Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016423ED489
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhHPND5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236276AbhHPNDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAEBF632A1;
        Mon, 16 Aug 2021 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119000;
        bh=EW3jspc19GaMzHHj7ZBULNLWFdHyKZANLS94qxi+9gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SksQIxd33MAFNlbmoCMOTVsCnMPpaJeutyopvpYJqmov68yI6T7VANYdDCty5UhqU
         EU7r67olXhb/cErdn2NEn2IOVxEPAWSmHu7yimIMZIuA384TTGexoGFuKu5n1G60fZ
         A/pMjqlo7+1Pg7L17jhBmVIYrF04owyApJGIpkXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/62] ieee802154: hwsim: fix GPF in hwsim_new_edge_nl
Date:   Mon, 16 Aug 2021 15:01:43 +0200
Message-Id: <20210816125428.575828500@linuxfoundation.org>
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

[ Upstream commit 889d0e7dc68314a273627d89cbb60c09e1cc1c25 ]

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
must be present to fix GPF.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210707155633.1486603-1-mudongliangabcd@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index da7f8cc9b181..2a78084aeaed 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -418,7 +418,7 @@ static int hwsim_new_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	struct hwsim_edge *e;
 	u32 v0, v1;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-- 
2.30.2



