Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238D7478B62
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 13:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbhLQMcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 07:32:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39784 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbhLQMcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 07:32:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D86CE6219D
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2053C36AE9;
        Fri, 17 Dec 2021 12:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639744355;
        bh=9trU7XudT++PSpW1wUqKgeobGbvlpUIOrBG84bXooro=;
        h=Subject:To:Cc:From:Date:From;
        b=LPAPt7RD5Ikvm9hJOPZkjL+VqtuAtn67oMoY6ZSWsXjiUh0RwHGqCbM9s5JPDdRgD
         SmYBq5kbV+YZRFcS2EVpWvM7eVRz/kGDp+X9fsLbc+ca765HNvaBCd2bP/GNlvAYoF
         hUgweFdS46pSJQWGxfkNgXTIMJhSTHKsF9pRS0oY=
Subject: FAILED: patch "[PATCH] mac80211: validate extended element ID is present" failed to apply to 5.4-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Dec 2021 13:32:32 +0100
Message-ID: <1639744352117139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

