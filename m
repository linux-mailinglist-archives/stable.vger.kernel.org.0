Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED4F3CDD1C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbhGSO4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231754AbhGSOx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 028336127C;
        Mon, 19 Jul 2021 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708782;
        bh=mJC33RkZqwltTwapSflD8C7OtJZxpdNjnR9cKWEassA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0nmqaF6euZjyvPn0dc2nYmGQrmhes9373Z2MmoaQO+oRTJ2GI0VfyJ/iJFiUZjFU
         DYCLf6WM83adb8On6VhUm4nD5wLrSEYKKc5JRqPWTZ+P+obyrKoeyzwimZsZlFFHqf
         vQAjmu+yYxPZaTQcGIrZHrWoLAITCq7HaOiwEvfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/421] ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
Date:   Mon, 19 Jul 2021 16:48:59 +0200
Message-Id: <20210719144950.970770344@linuxfoundation.org>
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
index be1f1a86bcd6..c66a010650e0 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -734,6 +734,8 @@ static int hwsim_subscribe_all_others(struct hwsim_phy *phy)
 
 	return 0;
 
+sub_fail:
+	hwsim_edge_unsubscribe_me(phy);
 me_fail:
 	rcu_read_lock();
 	list_for_each_entry_rcu(e, &phy->edges, list) {
@@ -741,8 +743,6 @@ me_fail:
 		hwsim_free_edge(e);
 	}
 	rcu_read_unlock();
-sub_fail:
-	hwsim_edge_unsubscribe_me(phy);
 	return -ENOMEM;
 }
 
-- 
2.30.2



