Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDC7A914B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389859AbfIDSOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390828AbfIDSOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 882402087E;
        Wed,  4 Sep 2019 18:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620875;
        bh=RO75rEGuI0EXfpa+RFUYzyyXCpPFC+MVgXKPVup4TEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAMZbza8MG1zMVLOrbG6W9XTqFJLzo9EspgLPHr2yQFWDO+NxCK9R9An4PWT6JGEC
         yiToUBmsDcmT8KnSGQxA0fU6Rzsph4D/SNDZ6ilbFAs6P++Xgq9oV9auOATDSiBg4b
         LGMfV8t912aBrK47ykpeX7hpBRqByJ10HoIy0Sw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.2 128/143] mac80211: Correctly set noencrypt for PAE frames
Date:   Wed,  4 Sep 2019 19:54:31 +0200
Message-Id: <20190904175319.414317377@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Kenzior <denkenz@gmail.com>

commit f8b43c5cf4b62a19f2210a0f5367b84e1eff1ab9 upstream.

The noencrypt flag was intended to be set if the "frame was received
unencrypted" according to include/uapi/linux/nl80211.h.  However, the
current behavior is opposite of this.

Cc: stable@vger.kernel.org
Fixes: 018f6fbf540d ("mac80211: Send control port frames over nl80211")
Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Link: https://lore.kernel.org/r/20190827224120.14545-3-denkenz@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2447,7 +2447,7 @@ static void ieee80211_deliver_skb_to_loc
 		      skb->protocol == cpu_to_be16(ETH_P_PREAUTH)) &&
 		     sdata->control_port_over_nl80211)) {
 		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-		bool noencrypt = status->flag & RX_FLAG_DECRYPTED;
+		bool noencrypt = !(status->flag & RX_FLAG_DECRYPTED);
 
 		cfg80211_rx_control_port(dev, skb, noencrypt);
 		dev_kfree_skb(skb);


