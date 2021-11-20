Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C68457E66
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbhKTMoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237259AbhKTMoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:44:06 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB28C06173E
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637412060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZpdsrkCS3uAi4Z7sRXf+IT4tYwKyqPJtQ31TxLsuk5M=;
        b=KxMMN2uBySDradiGEHSnHkaERoyCS0+E+DpFKFFe9PSZSNtu9xXzm7gp1MFigsiBtk1Mr0
        UuNwV7SXeRXU7MyATS1Qf71qhKyzl2/7NMufXv4bsc1Xlob6a8XHH67jyrsajiUaJRYHhn
        ttBRm/sZYt5fWxrTEhb/NCfG5O4/9ow=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.4 1/3] batman-adv: Consider fragmentation for needed_headroom
Date:   Sat, 20 Nov 2021 13:40:51 +0100
Message-Id: <20211120124053.261156-2-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211120124053.261156-1-sven@narfation.org>
References: <20211120124053.261156-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4ca23e2c2074465bff55ea14221175fecdf63c5f upstream.

If a batman-adv packets has to be fragmented, then the original batman-adv
packet header is not stripped away. Instead, only a new header is added in
front of the packet after it was split.

This size must be considered to avoid cost intensive reallocations during
the transmission through the various device layers.

Fixes: 7bca68c7844b ("batman-adv: Add lower layer needed_(head|tail)room to own ones")
Reported-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/hard-interface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index afb52282d5bd..18e644f3cb30 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -554,6 +554,9 @@ static void batadv_hardif_recalc_extra_skbroom(struct net_device *soft_iface)
 	needed_headroom = lower_headroom + (lower_header_len - ETH_HLEN);
 	needed_headroom += batadv_max_header_len();
 
+	/* fragmentation headers don't strip the unicast/... header */
+	needed_headroom += sizeof(struct batadv_frag_packet);
+
 	soft_iface->needed_headroom = needed_headroom;
 	soft_iface->needed_tailroom = lower_tailroom;
 }
-- 
2.30.2

