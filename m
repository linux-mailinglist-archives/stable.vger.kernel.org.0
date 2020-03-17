Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B878C1891F5
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCQX1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:49 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53532 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgCQX1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LJgA7zVMs5yAz0EbldumNZydFlNUPN7/bAjfN6gyukI=;
        b=zoRWvkU9eejmk4nH1SiMZiGXuIMUDgXI+C2os1+X2zNUHvq/46RQY9+RYbMPxmuzd+TzX1
        9gJjWxNWC4mVXOzSxlOzRZgTCPcFjZjmwnnkA8Q397nGaesG+RaZVaSUHlXWMxEckBQo9/
        GaplZ0p8pR8i9xiIPb8mT9AbOL/dFOA=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven.eckelmann@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 06/48] batman-adv: Fix integer overflow in batadv_iv_ogm_calc_tq
Date:   Wed, 18 Mar 2020 00:26:52 +0100
Message-Id: <20200317232734.6127-7-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven.eckelmann@open-mesh.com>

commit d285f52cc0f23564fd61976d43fd5b991b4828f6 upstream.

The undefined behavior sanatizer detected an signed integer overflow in a
setup with near perfect link quality

    UBSAN: Undefined behaviour in net/batman-adv/bat_iv_ogm.c:1246:25
    signed integer overflow:
    8713350 * 255 cannot be represented in type 'int'

The problems happens because the calculation of mixed unsigned and signed
integers resulted in an integer multiplication.

      batadv_ogm_packet::tq (u8 255)
    * tq_own (u8 255)
    * tq_asym_penalty (int 134; max 255)
    * tq_iface_penalty (int 255; max 255)

The tq_iface_penalty, tq_asym_penalty and inv_asym_penalty can just be
changed to unsigned int because they are not expected to become negative.

Fixes: c039876892e3 ("batman-adv: add WiFi penalty")
Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/bat_iv_ogm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index cea4e321f588..749b9157fe11 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1140,9 +1140,10 @@ static int batadv_iv_ogm_calc_tq(struct batadv_orig_node *orig_node,
 	u8 total_count;
 	u8 orig_eq_count, neigh_rq_count, neigh_rq_inv, tq_own;
 	unsigned int neigh_rq_inv_cube, neigh_rq_max_cube;
-	int tq_asym_penalty, inv_asym_penalty, if_num, ret = 0;
+	int if_num, ret = 0;
+	unsigned int tq_asym_penalty, inv_asym_penalty;
 	unsigned int combined_tq;
-	int tq_iface_penalty;
+	unsigned int tq_iface_penalty;
 
 	/* find corresponding one hop neighbor */
 	rcu_read_lock();
-- 
2.20.1

