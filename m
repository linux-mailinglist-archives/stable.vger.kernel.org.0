Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240B8478B63
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 13:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhLQMcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 07:32:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42562 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbhLQMcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 07:32:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2904EB827D6
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C535C36AE2;
        Fri, 17 Dec 2021 12:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639744364;
        bh=7bAVVZZk8kibdexZ5C5gGIYAig08N8zdW2P4oqrBxRs=;
        h=Subject:To:Cc:From:Date:From;
        b=blB8amWAp0/il2ZnkMmJzxQtosegEMTEzaZBCzw1QGf8xqgz1fZx1VYAd5ysWLNnS
         b7Do/PdB86KQTIkj8NrgQ9OBb1eH/VkCtAFIjRyABD5bFWQng6dWJi7zTZ+OqAU8Y0
         vk/gDnLT6uuSBtgqBUv5jmPMWJE766lLYVsAPh2M=
Subject: FAILED: patch "[PATCH] mac80211: validate extended element ID is present" failed to apply to 4.19-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Dec 2021 13:32:34 +0100
Message-ID: <1639744354206133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 768c0b19b50665e337c96858aa2b7928d6dcf756 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Sat, 11 Dec 2021 20:10:24 +0100
Subject: [PATCH] mac80211: validate extended element ID is present

Before attempting to parse an extended element, verify that
the extended element ID is present.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Reported-by: syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211211201023.f30a1b128c07.I5cacc176da94ba316877c6e10fe3ceec8b4dbd7d@changeid
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 43df2f0c5db9..6c2934854d3c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -943,7 +943,12 @@ static void ieee80211_parse_extension_element(u32 *crc,
 					      struct ieee802_11_elems *elems)
 {
 	const void *data = elem->data + 1;
-	u8 len = elem->datalen - 1;
+	u8 len;
+
+	if (!elem->datalen)
+		return;
+
+	len = elem->datalen - 1;
 
 	switch (elem->data[0]) {
 	case WLAN_EID_EXT_HE_MU_EDCA:

