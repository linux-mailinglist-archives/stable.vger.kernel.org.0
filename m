Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC8D2C0AD5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgKWM3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730059AbgKWM3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:29:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FC3920888;
        Mon, 23 Nov 2020 12:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134559;
        bh=a5VPfCgx+ZvYrOxZ08N88GWvxf4bGUowlK9tjl2ZcCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWHVSio71RJdGOdHYe6UzVcy0IOgmCrvySyJL0SXMQYlre8q2yNpP1miibzQauDEs
         QuEgVqhBaOZXK25Hzi1Z0DLuj7jZ2c6wJW5MCXWH/FL1sF9dAG+S/SvRcAfs7OXK0k
         VVKSLrHbCQhxHeD+WePqwU1Q8I+0rQW+cnrqBP84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 56/60] mac80211: minstrel: fix tx status processing corner case
Date:   Mon, 23 Nov 2020 13:22:38 +0100
Message-Id: <20201123121807.755655510@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
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


