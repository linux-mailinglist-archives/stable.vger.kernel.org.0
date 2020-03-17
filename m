Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E974D1891EF
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgCQX1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:44 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53422 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgCQX1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CW/iZSS78nZ29CwQP1bUzebhn0aS8W8vbiKa/d4t4xA=;
        b=xtJEUPY6WpZMfyROZsSHtM8y0PsokLthoG1F0R8FvAXbdKXzPCKcXTMYUZ2Sqk80y8Ufzt
        6pUXero3R+/oSbIp7bwfUcTKXR0iqInp/eDz9xhiBpvEP2NBE2qXgWxv3/Prsn5FjtEex/
        L6HSmKhn379dAuoM2X2tDNL1DS1qInA=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 01/48] batman-adv: Fix invalid read while copying bat_iv.bcast_own
Date:   Wed, 18 Mar 2020 00:26:47 +0100
Message-Id: <20200317232734.6127-2-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 13bbdd370f67aef3351ad7bbc2fb624e3c23f905 upstream.

batadv_iv_ogm_orig_del_if removes a part of the bcast_own which previously
belonged to the now removed interface. This is done by copying all data
which comes before the removed interface and then appending all the data
which comes after the removed interface.

The address calculation for the position of the data which comes after the
removed interface assumed that the bat_iv.bcast_own is a pointer to a
single byte datatype. But it is a pointer to unsigned long and thus the
calculated position was wrong off factor sizeof(unsigned long).

Fixes: 83a8342678a0 ("more basic routing code added (forwarding packets / bitarray added)")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/bat_iv_ogm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 912d9c36fb1c..aa94b4ec766a 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -185,7 +185,8 @@ unlock:
 static int batadv_iv_ogm_orig_del_if(struct batadv_orig_node *orig_node,
 				     int max_if_num, int del_if_num)
 {
-	int chunk_size,  ret = -ENOMEM, if_offset;
+	int ret = -ENOMEM;
+	size_t chunk_size, if_offset;
 	void *data_ptr = NULL;
 
 	spin_lock_bh(&orig_node->bat_iv.ogm_cnt_lock);
@@ -203,8 +204,9 @@ static int batadv_iv_ogm_orig_del_if(struct batadv_orig_node *orig_node,
 	memcpy(data_ptr, orig_node->bat_iv.bcast_own, del_if_num * chunk_size);
 
 	/* copy second part */
+	if_offset = (del_if_num + 1) * chunk_size;
 	memcpy((char *)data_ptr + del_if_num * chunk_size,
-	       orig_node->bat_iv.bcast_own + ((del_if_num + 1) * chunk_size),
+	       (uint8_t *)orig_node->bat_iv.bcast_own + if_offset,
 	       (max_if_num - del_if_num) * chunk_size);
 
 free_bcast_own:
-- 
2.20.1

