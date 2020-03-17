Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BA3189217
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgCQX2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:20 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53786 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCQX2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z3/ijpS8jsF5RS6bi+JPkI+gxR0rDAUufRw3qYh1tVE=;
        b=m8vPPdmqvatYzhX/KoiHUrTYv6THFyqovf9mEyjJK6NwSpxYdgbIILMzJBlTdpAfZB7VvX
        ROpH7I+2GnZlEfzSUgH6e7/hY/g+Z2xQErqGd3SWJBV9mApiYAVxYJxWBR9ozU48InBJ4+
        Riq6ilFLrc/dOtGt+KowPf3FU0C2e3k=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 38/48] batman-adv: Avoid storing non-TT-sync flags on singular entries too
Date:   Wed, 18 Mar 2020 00:27:24 +0100
Message-Id: <20200317232734.6127-39-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

commit 4a519b83da16927fb98fd32b0f598e639d1f1859 upstream.

Since commit 54e22f265e87 ("batman-adv: fix TT sync flag inconsistencies")
TT sync flags and TT non-sync'd flags are supposed to be stored
separately.

The previous patch missed to apply this separation on a TT entry with
only a single TT orig entry.

This is a minor fix because with only a single TT orig entry the DDoS
issue the former patch solves does not apply.

Fixes: 54e22f265e87 ("batman-adv: fix TT sync flag inconsistencies")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/translation-table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index f16d49473a28..4a685cf2439d 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1405,7 +1405,8 @@ static bool batadv_tt_global_add(struct batadv_priv *bat_priv,
 		ether_addr_copy(common->addr, tt_addr);
 		common->vid = vid;
 
-		common->flags = flags;
+		common->flags = flags & (~BATADV_TT_SYNC_MASK);
+
 		tt_global_entry->roam_at = 0;
 		/* node must store current time in case of roaming. This is
 		 * needed to purge this entry out on timeout (if nobody claims
-- 
2.20.1

