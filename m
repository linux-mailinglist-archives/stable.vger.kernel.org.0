Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D418A2C06A8
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgKWMdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731170AbgKWMdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:33:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D0652065E;
        Mon, 23 Nov 2020 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134791;
        bh=a5VPfCgx+ZvYrOxZ08N88GWvxf4bGUowlK9tjl2ZcCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tGckBqwmtUXMqJ8txrzlvXGICr3RLZoaKBwmorhjgpfg6KDFrtE6nfjJbXR9+3M6
         K8BuTM1b3kgVx/iOXx1HEptS8MSH2m+mIB6VL3Bz/XWrscLYFM2hSl3m5cvuPiUab7
         K1qmG2KP6NS1Yx1tFunQP36yMpIozHg6nbTFlxWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 84/91] mac80211: minstrel: fix tx status processing corner case
Date:   Mon, 23 Nov 2020 13:22:44 +0100
Message-Id: <20201123121813.406089581@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit b2911a84396f72149dce310a3b64d8948212c1b3 upstream.

Some drivers fill the status rate list without setting the rate index after
the final rate to -1. minstrel_ht already deals with this, but minstrel
doesn't, which causes it to get stuck at the lowest rate on these drivers.

Fix this by checking the count as well.

Cc: stable@vger.kernel.org
Fixes: cccf129f820e ("mac80211: add the 'minstrel' rate control algorithm")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20201111183359.43528-3-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rc80211_minstrel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -276,7 +276,7 @@ minstrel_tx_status(void *priv, struct ie
 	success = !!(info->flags & IEEE80211_TX_STAT_ACK);
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
-		if (ar[i].idx < 0)
+		if (ar[i].idx < 0 || !ar[i].count)
 			break;
 
 		ndx = rix_to_ndx(mi, ar[i].idx);


