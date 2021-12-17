Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEFD478BC9
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 13:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbhLQMw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 07:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbhLQMw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 07:52:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4C3C061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 04:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B5CB82737
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B484C36AE1;
        Fri, 17 Dec 2021 12:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639745546;
        bh=DYzZOIE7vYP3bNBmeoNkLvkaau0gOanioJJUv3OrEqA=;
        h=Subject:To:Cc:From:Date:From;
        b=FxQWU65+NZtfgfPgHcniFXRb+h+QtOkP9r/gUHdK+LF/+y09/Rha7dNL3SUyIXqAG
         YN3YVP1cPsaLAU2X79dn/ibjS8RdKsUNqs+O0dhb/+r7V7EgdQ6ZkXggJOHUmJvu/i
         K2+FhCCkHQshra2lu3yEV18fSNQNnj8bID7daUHg=
Subject: FAILED: patch "[PATCH] mac80211: mark TX-during-stop for TX in in_reconfig" failed to apply to 4.9-stable tree
To:     johannes.berg@intel.com, luciano.coelho@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Dec 2021 13:52:15 +0100
Message-ID: <1639745535119246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From db7205af049d230e7e0abf61c1e74c1aab40f390 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Mon, 29 Nov 2021 15:32:39 +0200
Subject: [PATCH] mac80211: mark TX-during-stop for TX in in_reconfig

Mark TXQs as having seen transmit while they were stopped if
we bail out of drv_wake_tx_queue() due to reconfig, so that
the queue wake after this will make them catch up. This is
particularly necessary for when TXQs are used for management
packets since those TXQs won't see a lot of traffic that'd
make them catch up later.

Cc: stable@vger.kernel.org
Fixes: 4856bfd23098 ("mac80211: do not call driver wake_tx_queue op during reconfig")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.4573a221c0e1.I0d1d5daea3089be3fc0dccc92991b0f8c5677f0c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index cd3731cbf6c6..c336267f4599 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1219,8 +1219,11 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
 
-	if (local->in_reconfig)
+	/* In reconfig don't transmit now, but mark for waking later */
+	if (local->in_reconfig) {
+		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txq->flags);
 		return;
+	}
 
 	if (!check_sdata_in_driver(sdata))
 		return;

