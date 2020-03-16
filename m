Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62BD1875AE
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732828AbgCPWb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:27 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49378 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbgCPWb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ed6eKVXLOnh+aiqtZTszepKOkAAPp3x3KHW9nohPnB4=;
        b=iOaPMJ42krP0T2/bSuO6wp/H7f5viZyHbl4/Pi1Si7kjeHrmUINKRZsj6L21SdlolbW5hC
        VLzUg+Mpo2bPXxtPgOnN5b99IVHT7zuuFceFyRWRW4CE+8n5jaF/VwGCa7CV2CnGDF+WvS
        9syLHhj7YFCgG7HaIRucIrI+8ixMOMg=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 18/24] batman-adv: Avoid storing non-TT-sync flags on singular entries too
Date:   Mon, 16 Mar 2020 23:30:59 +0100
Message-Id: <20200316223105.6333-19-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
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
---
 net/batman-adv/translation-table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 7323b50535ad..6300454a4014 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1708,7 +1708,8 @@ static bool batadv_tt_global_add(struct batadv_priv *bat_priv,
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

