Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3811C27C570
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgI2Lfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729854AbgI2Lff (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D684423D57;
        Tue, 29 Sep 2020 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379002;
        bh=n+IwIyHHJdmdb8M0LwCJ2kFB/kli4THbYdnvtMtaMDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fxwDw5OFvP97OwIZQ4WfHxWL48U1AGA5FHjrCdUGpafGQ1BaaWgkClAkiFZFPioM
         46iJhbBkBISx0muNWAVazfrS0X26+GXHy1RX7Yy/KChUIByC+gTe+mTUsYd/8Rni3Q
         ntJbHzYqNCtabl++VNoUdMkot9v2SnqD9H3/vPQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/245] batman-adv: bla: fix type misuse for backbone_gw hash indexing
Date:   Tue, 29 Sep 2020 13:01:10 +0200
Message-Id: <20200929105957.635736871@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

[ Upstream commit 097930e85f90f252c44dc0d084598265dd44ca48 ]

It seems that due to a copy & paste error the void pointer
in batadv_choose_backbone_gw() is cast to the wrong type.

Fixing this by using "struct batadv_bla_backbone_gw" instead of "struct
batadv_bla_claim" which better matches the caller's side.

For now it seems that we were lucky because the two structs both have
their orig/vid and addr/vid in the beginning. However I stumbled over
this issue when I was trying to add some debug variables in front of
"orig" in batadv_backbone_gw, which caused hash lookups to fail.

Fixes: 07568d0369f9 ("batman-adv: don't rely on positions in struct for hashing")
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 9b8bf06ccb613..e71a35a3950de 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -96,11 +96,12 @@ static inline u32 batadv_choose_claim(const void *data, u32 size)
  */
 static inline u32 batadv_choose_backbone_gw(const void *data, u32 size)
 {
-	const struct batadv_bla_claim *claim = (struct batadv_bla_claim *)data;
+	const struct batadv_bla_backbone_gw *gw;
 	u32 hash = 0;
 
-	hash = jhash(&claim->addr, sizeof(claim->addr), hash);
-	hash = jhash(&claim->vid, sizeof(claim->vid), hash);
+	gw = (struct batadv_bla_backbone_gw *)data;
+	hash = jhash(&gw->orig, sizeof(gw->orig), hash);
+	hash = jhash(&gw->vid, sizeof(gw->vid), hash);
 
 	return hash % size;
 }
-- 
2.25.1



