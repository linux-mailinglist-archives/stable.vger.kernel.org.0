Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8908E73C5C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392031AbfGXUBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388390AbfGXUBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:01:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA14A2184B;
        Wed, 24 Jul 2019 20:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998495;
        bh=pTFeQv98H46EeA0WHEDxGaJ5kxgDk+Xt4a/9ad8MigU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQ10qvSqueM+dBaZYVyCxS6Lox9EQNCgVrP3IKkovLAwSeepezwPBgwjyeJYEnTaM
         m6DfVXTwtl2KwN0UR6Ig9/dsTsCwZNIapDOK09AC5UXr9h+Jm7V2ogdpPEp5dDbIKJ
         BaeBC3/U4xm0NJHpo1Y7jGRLm0RLU7Sk/9Hpm8Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d454a826e670502484b8@syzkaller.appspotmail.com,
        Jeremy Sowden <jeremy@azazel.net>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/271] batman-adv: fix for leaked TVLV handler.
Date:   Wed, 24 Jul 2019 21:18:03 +0200
Message-Id: <20190724191656.490932753@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 17f78dd1bd624a4dd78ed5db3284a63ee807fcc3 ]

A handler for BATADV_TVLV_ROAM was being registered when the
translation-table was initialized, but not unregistered when the
translation-table was freed.  Unregister it.

Fixes: 122edaa05940 ("batman-adv: tvlv - convert roaming adv packet to use tvlv unicast packets")
Reported-by: syzbot+d454a826e670502484b8@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 359ec1a6e822..9fa5389ea244 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3821,6 +3821,8 @@ static void batadv_tt_purge(struct work_struct *work)
  */
 void batadv_tt_free(struct batadv_priv *bat_priv)
 {
+	batadv_tvlv_handler_unregister(bat_priv, BATADV_TVLV_ROAM, 1);
+
 	batadv_tvlv_container_unregister(bat_priv, BATADV_TVLV_TT, 1);
 	batadv_tvlv_handler_unregister(bat_priv, BATADV_TVLV_TT, 1);
 
-- 
2.20.1



