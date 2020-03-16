Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3EC18758F
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732761AbgCPWax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:30:53 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:48900 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732743AbgCPWax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRn0EBccz8FM4yYEicHpvD7vu4QxTigmGGu/npxZy54=;
        b=ZRGpSwPHWSlkFLm3VR/mL2SQfxf6zvfBcu2eh6GGGijg1OFZd5On8xvjWaSCs2EFVKweKX
        ZZBSWaah8AbdzTArR4Idw3fRA/GILmPS8qPQit1qLRu8yjkYhEKzPJ3Zs9GI6oAModzaWl
        GRpch0vMurQ/5LBOKjQk6eSKbvOaLGU=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 03/15] batman-adv: Fix check of retrieved orig_gw in batadv_v_gw_is_eligible
Date:   Mon, 16 Mar 2020 23:30:20 +0100
Message-Id: <20200316223032.6236-4-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223032.6236-1-sven@narfation.org>
References: <20200316223032.6236-1-sven@narfation.org>
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
index f81e67fbb352..eb8cec14b854 100644
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

