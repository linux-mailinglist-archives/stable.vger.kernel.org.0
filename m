Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE510457E41
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhKTMmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhKTMmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:42:53 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11521C06173E
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637411987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4maUAAS44X66FxWwAzQabuiiYD7i+Wp6i2zb+oOcTlg=;
        b=lPRpHNnNnRf9/6aY+Y/kI+k7HE3xH3EOkP3uTDMovdz/YQvHnUmC1tAxh77aQ5m6U8iguP
        0IK7r2+TDGdsQNJK2gGRztKs/pNp/snz3cE5J1aUWm1qBsgjF63NCQ9LtPzJOep3iENp+g
        9ze9w2Y6xd1dOItWXLu3xKleXtNxKh4=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 11/11] batman-adv: Avoid WARN_ON timing related checks
Date:   Sat, 20 Nov 2021 13:39:39 +0100
Message-Id: <20211120123939.260723-12-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211120123939.260723-1-sven@narfation.org>
References: <20211120123939.260723-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9f460ae31c4435fd022c443a6029352217a16ac1 upstream.

The soft/batadv interface for a queued OGM can be changed during the time
the OGM was queued for transmission and when the OGM is actually
transmitted by the worker.

But WARN_ON must be used to denote kernel bugs and not to print simple
warnings. A warning can simply be printed using pr_warn.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com
Fixes: ef0a937f7a14 ("batman-adv: consider outgoing interface in OGM sending")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.4 backported: adjust context. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/bat_iv_ogm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index caea5bb38d4b..6f8d2fe114f6 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -526,8 +526,10 @@ static void batadv_iv_ogm_emit(struct batadv_forw_packet *forw_packet)
 	if (WARN_ON(!forw_packet->if_outgoing))
 		goto out;
 
-	if (WARN_ON(forw_packet->if_outgoing->soft_iface != soft_iface))
+	if (forw_packet->if_outgoing->soft_iface != soft_iface) {
+		pr_warn("%s: soft interface switch for queued OGM\n", __func__);
 		goto out;
+	}
 
 	if (forw_packet->if_incoming->if_status != BATADV_IF_ACTIVE)
 		goto out;
-- 
2.30.2

