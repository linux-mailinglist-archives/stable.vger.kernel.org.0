Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB46F6C8
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbfD3Lvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731431AbfD3Lvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:51:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20D182054F;
        Tue, 30 Apr 2019 11:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625100;
        bh=IHeIEEDvmtHD80dmJEzDhiS1z4BpgEo5YUhqc93a+AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFDTNw2gaOBgOu3AcCwfnkl553ohoysiTe/60pJHlRLRVmaCXm/g6CVZBe9qwksct
         af6kFANoLoN6hr3sQzb/EozVa1vBBfpOSQ+4WAKWlAckbt/YJ7r+kWr8gKSpQOMFsd
         qDziOycDm9tJrSmL1KfniXjeai6a62n4sQwe44JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8f91bd563bbff230d0ee@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.0 55/89] mac80211_hwsim: calculate if_combination.max_interfaces
Date:   Tue, 30 Apr 2019 13:38:46 +0200
Message-Id: <20190430113612.254757196@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 45fcef8b727b6f171bc5443e8153181a367d7a15 upstream.

If we just set this to 2048, and have multiple limits you
can select from, the total number might run over and cause
a warning in cfg80211. This doesn't make sense, so we just
calculate the total max_interfaces now.

Reported-by: syzbot+8f91bd563bbff230d0ee@syzkaller.appspotmail.com
Fixes: 99e3a44bac37 ("mac80211_hwsim: allow setting iftype support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mac80211_hwsim.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2642,7 +2642,7 @@ static int mac80211_hwsim_new_radio(stru
 	enum nl80211_band band;
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
 	struct net *net;
-	int idx;
+	int idx, i;
 	int n_limits = 0;
 
 	if (WARN_ON(param->channels > 1 && !param->use_chanctx))
@@ -2766,12 +2766,23 @@ static int mac80211_hwsim_new_radio(stru
 		goto failed_hw;
 	}
 
+	data->if_combination.max_interfaces = 0;
+	for (i = 0; i < n_limits; i++)
+		data->if_combination.max_interfaces +=
+			data->if_limits[i].max;
+
 	data->if_combination.n_limits = n_limits;
-	data->if_combination.max_interfaces = 2048;
 	data->if_combination.limits = data->if_limits;
 
-	hw->wiphy->iface_combinations = &data->if_combination;
-	hw->wiphy->n_iface_combinations = 1;
+	/*
+	 * If we actually were asked to support combinations,
+	 * advertise them - if there's only a single thing like
+	 * only IBSS then don't advertise it as combinations.
+	 */
+	if (data->if_combination.max_interfaces > 1) {
+		hw->wiphy->iface_combinations = &data->if_combination;
+		hw->wiphy->n_iface_combinations = 1;
+	}
 
 	if (param->ciphers) {
 		memcpy(data->ciphers, param->ciphers,


