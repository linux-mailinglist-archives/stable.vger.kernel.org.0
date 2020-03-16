Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E6A186C68
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 14:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbgCPNpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 09:45:17 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:36839 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731128AbgCPNpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 09:45:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 49ED750C;
        Mon, 16 Mar 2020 09:45:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 09:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FoOY+I
        OpTMLcMqjvRZTbmEVUiFoICV5IPnS8h1UdmLg=; b=Vz+cwVI/jY40oOtKAyTXTK
        yLfCE8VGJFPVUqq3ugEswIZnsGl1uKoE8wYzO+HyOs2YrnkXdq60houRyLw9eIHe
        8D4ePDFMPbYLotAXHk9bgE93zQeygUyrTRxQEtcm+aTvXMF99q9iqWy/bc75DkpM
        rJRw6XPHITiOzUxTz48xhg8d42edeUCI4W6oZ5aBVO3WOctJpPwCfKtQshSKpwvw
        ZvPpw+gDE594rUVcVPQ+UPJJl3C4PMLJk0P//TXZpFabt4eUEmAeJjOeYgxf8fHq
        XaVuUzMw4cbjRgIxizGCgItXPo9ra1+N6h5Qivy/T/zCafxA7qTve30iLhwKW9zw
        ==
X-ME-Sender: <xms:6oJvXjxXDni6NOogZqmDdoOydz2jGzd2bKtBAUJuvSUL2Xvjy5CBsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6oJvXtvGE6i3_E-aE5-vOlP6_mUZ5-Etm_tRNhiY_bYa5PGYVAo4Kw>
    <xmx:6oJvXtgynbBRKkhVdNgDxjcGnGE3LQDDxd3QGojaS48JNu0RPVeKJg>
    <xmx:6oJvXlBn8yz0NpIBfdUXla3kiGGlho3NEl5PRzkHae-VWBAB6oBM-A>
    <xmx:64JvXjmmw-QvWp6cTeIV8_Tt1wLvquMA1HxmmxjyGetTZdlajwx0Jw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D0233061CB6;
        Mon, 16 Mar 2020 09:45:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] batman-adv: Don't schedule OGM for disabled interface" failed to apply to 4.4-stable tree
To:     sven@narfation.org, hdanton@sina.com, sw@simonwunderlich.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 14:45:12 +0100
Message-ID: <158436631216439@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8e8ce08198de193e3d21d42e96945216e3d9ac7f Mon Sep 17 00:00:00 2001
From: Sven Eckelmann <sven@narfation.org>
Date: Sun, 16 Feb 2020 13:02:06 +0100
Subject: [PATCH] batman-adv: Don't schedule OGM for disabled interface

A transmission scheduling for an interface which is currently dropped by
batadv_iv_ogm_iface_disable could still be in progress. The B.A.T.M.A.N. V
is simply cancelling the workqueue item in an synchronous way but this is
not possible with B.A.T.M.A.N. IV because the OGM submissions are
intertwined.

Instead it has to stop submitting the OGM when it detect that the buffer
pointer is set to NULL.

Reported-by: syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com
Reported-by: syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index f0209505e41a..a7c8dd7ae513 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -789,6 +789,10 @@ static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 
 	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
 
+	/* interface already disabled by batadv_iv_ogm_iface_disable */
+	if (!*ogm_buff)
+		return;
+
 	/* the interface gets activated here to avoid race conditions between
 	 * the moment of activating the interface in
 	 * hardif_activate_interface() where the originator mac is set and

