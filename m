Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225B73C53B4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348456AbhGLHzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350596AbhGLHvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A757061A36;
        Mon, 12 Jul 2021 07:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076004;
        bh=kJB5SbpgO7mGIgmNq8fsmv/cceyl73T7F2dO1zqfyws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npCX4K4EkdsnlFfcX1WLzCZ8R7JPoYvbtAcEsIeyJx48lYoWFyh60yp71sToj54Zf
         /h8V+aEknQAsr/AtBR8gwXwQjL8eWGpEK4H6rChY9hN8BCZP4wC6pRRG4SM/FLMnFd
         YpQCq1kEK1U+0fxLER3plCh70NkK2VdoSmTYGYe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 456/800] ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
Date:   Mon, 12 Jul 2021 08:07:59 +0200
Message-Id: <20210712061015.691283083@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index da9135231c07..366eaae3550a 100644
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



