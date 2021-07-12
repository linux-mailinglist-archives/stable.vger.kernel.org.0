Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3DAC3C49F7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhGLGrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238219AbhGLGrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6DF4611C0;
        Mon, 12 Jul 2021 06:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072175;
        bh=vlj4DZ8UXho2XR4TAWSFisRLYxoBrQ5SoICUSbkZ6TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuWsiUjrU9+qvw7cr3ZDWKYcc9QBWfm0shoKU4ntLsf5xFvL9tRN2Mn734+yGhrld
         3X5jSiRxXJddznfRcQ8NTMdcsIM8IOZ6gvK43VA7wuF/NdLgoPxRAmhwDFrnx+CEwA
         3RLUNQ+49vK+2tI0pRSXRqhqGvQ7syczM79ZL81Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 343/593] ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
Date:   Mon, 12 Jul 2021 08:08:23 +0200
Message-Id: <20210712060923.776029625@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit ab372c2293f5d0b279f31c8d768566ea37602dc9 ]

In hwsim_subscribe_all_others, the error handling code performs
incorrectly if the second hwsim_alloc_edge fails. When this issue occurs,
it goes to sub_fail, without cleaning the edges allocated before.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210611015812.1626999-1-mudongliangabcd@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index c0bf7d78276e..7a168170224a 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -715,6 +715,8 @@ static int hwsim_subscribe_all_others(struct hwsim_phy *phy)
 
 	return 0;
 
+sub_fail:
+	hwsim_edge_unsubscribe_me(phy);
 me_fail:
 	rcu_read_lock();
 	list_for_each_entry_rcu(e, &phy->edges, list) {
@@ -722,8 +724,6 @@ me_fail:
 		hwsim_free_edge(e);
 	}
 	rcu_read_unlock();
-sub_fail:
-	hwsim_edge_unsubscribe_me(phy);
 	return -ENOMEM;
 }
 
-- 
2.30.2



