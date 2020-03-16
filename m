Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4DC1875A4
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732819AbgCPWbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:18 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49130 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732766AbgCPWbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4PMZZ7ByKkkrx7OHZ4d7PNTAouK50EgTggx6cXWPu0=;
        b=p3YRsLWE4TlGoqeW5yXoNYaiE4Zb2jw6oADEgLuplPp2JGhSf2GoJ6lwXxvoH9ir8xMAzz
        HDw+fZTvXY1390ET73jrmDeVl1Ll4WTZ3EYmBctkskb4bfu70TOszThxBLkpNFdokYYYwp
        +EM6APSnSNc2aPtlDcSZIvHptjw9kyU=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 08/24] batman-adv: Avoid spurious warnings from bat_v neigh_cmp implementation
Date:   Mon, 16 Mar 2020 23:30:49 +0100
Message-Id: <20200316223105.6333-9-sven@narfation.org>
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

commit 6a4bc44b012cbc29c9d824be2c7ab9eac8ee6b6f upstream.

The neighbor compare API implementation for B.A.T.M.A.N. V checks whether
the neigh_ifinfo for this neighbor on a specific interface exists. A
warning is printed when it isn't found.

But it is not called inside a lock which would prevent that this
information is lost right before batadv_neigh_ifinfo_get. It must therefore
be expected that batadv_v_neigh_(cmp|is_sob) might not be able to get the
requested neigh_ifinfo.

A WARN_ON for such a situation seems not to be appropriate because this
will only flood the kernel logs. The warnings must therefore be removed.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index d3702fda7486..2bfb0bb8be0f 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -19,7 +19,6 @@
 #include "main.h"
 
 #include <linux/atomic.h>
-#include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/errno.h>
 #include <linux/if_ether.h>
@@ -623,11 +622,11 @@ static int batadv_v_neigh_cmp(struct batadv_neigh_node *neigh1,
 	int ret = 0;
 
 	ifinfo1 = batadv_neigh_ifinfo_get(neigh1, if_outgoing1);
-	if (WARN_ON(!ifinfo1))
+	if (!ifinfo1)
 		goto err_ifinfo1;
 
 	ifinfo2 = batadv_neigh_ifinfo_get(neigh2, if_outgoing2);
-	if (WARN_ON(!ifinfo2))
+	if (!ifinfo2)
 		goto err_ifinfo2;
 
 	ret = ifinfo1->bat_v.throughput - ifinfo2->bat_v.throughput;
@@ -649,11 +648,11 @@ static bool batadv_v_neigh_is_sob(struct batadv_neigh_node *neigh1,
 	bool ret = false;
 
 	ifinfo1 = batadv_neigh_ifinfo_get(neigh1, if_outgoing1);
-	if (WARN_ON(!ifinfo1))
+	if (!ifinfo1)
 		goto err_ifinfo1;
 
 	ifinfo2 = batadv_neigh_ifinfo_get(neigh2, if_outgoing2);
-	if (WARN_ON(!ifinfo2))
+	if (!ifinfo2)
 		goto err_ifinfo2;
 
 	threshold = ifinfo1->bat_v.throughput / 4;
-- 
2.20.1

