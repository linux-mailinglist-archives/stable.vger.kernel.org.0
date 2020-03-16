Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751881875A7
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732821AbgCPWbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:19 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49130 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732766AbgCPWbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RgsQjk0gzr4zT2GcHYHPwLeu4XzyPJlMoojsGsoKHVQ=;
        b=anSE86xRbHgvns/BqNbXrfrcvJmYGqUZvtFoz3dxpGFfTFfqipw90eEdpEz3R1LEVTaAtQ
        ShGsX/oksnYr1phtCF4rXG7PIaXIBiGL6LRV0GLqqTAkKTnzSxAQi1uUxgqPOUht973Za0
        7XANVfiqMK4pj/5edh9t/UFvpJdKWEI=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 10/24] batman-adv: Fix check of retrieved orig_gw in batadv_v_gw_is_eligible
Date:   Mon, 16 Mar 2020 23:30:51 +0100
Message-Id: <20200316223105.6333-11-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven.eckelmann@openmesh.com>

commit 198a62ddffa4a4ffaeb741f642b7b52f2d91ae9b upstream.

The batadv_v_gw_is_eligible function already assumes that orig_node is not
NULL. But batadv_gw_node_get may have failed to find the originator. It
must therefore be checked whether the batadv_gw_node_get failed and not
whether orig_node is NULL to detect this error.

Fixes: 50164d8f500f ("batman-adv: B.A.T.M.A.N. V - implement GW selection logic")
Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index 2bfb0bb8be0f..18fa602e5fc6 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -814,7 +814,7 @@ static bool batadv_v_gw_is_eligible(struct batadv_priv *bat_priv,
 	}
 
 	orig_gw = batadv_gw_node_get(bat_priv, orig_node);
-	if (!orig_node)
+	if (!orig_gw)
 		goto out;
 
 	if (batadv_v_gw_throughput_get(orig_gw, &orig_throughput) < 0)
-- 
2.20.1

