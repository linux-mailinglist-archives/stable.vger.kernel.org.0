Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194F318B73A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgCSNRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbgCSNRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:17:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE5F920787;
        Thu, 19 Mar 2020 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623856;
        bh=FbcZCwOBpIKtkGwLCBFpBHjyL2yg+SCnL9LA0x74+K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxRTdX38rufFQ0hGtgK4Uv25QJWXhcvYyRWZhlvdFMu5+P9CquNvb7YjJkZi4z+hj
         JJyp+e/CvpUtg0PRihuiRI9v1HzVlzIQsb2PbfhW9h7h7RGclfHtL/slZPhPlmulxc
         SEKzf6+sM9tD9wAu3qmMRsgeFBTZryFZRIBODk78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 69/99] batman-adv: Fix check of retrieved orig_gw in batadv_v_gw_is_eligible
Date:   Thu, 19 Mar 2020 14:03:47 +0100
Message-Id: <20200319124002.125050165@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -814,7 +814,7 @@ static bool batadv_v_gw_is_eligible(stru
 	}
 
 	orig_gw = batadv_gw_node_get(bat_priv, orig_node);
-	if (!orig_node)
+	if (!orig_gw)
 		goto out;
 
 	if (batadv_v_gw_throughput_get(orig_gw, &orig_throughput) < 0)


