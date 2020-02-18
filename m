Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E4B1631D7
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgBRUDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbgBRUDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7793A24673;
        Tue, 18 Feb 2020 20:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056181;
        bh=yaJiDeQSI2EMCSVNMIN7LeAM+k+7UbmGAwh6/ahZFPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RR9vODsdb7AK+qXlZ1t4UCySeshwoO/8a0BZKxGi3PoZdXsLRMqlRHclLFDdjNUkN
         CIMeMNWbS/opxDeevc9qEIlELSqTpnf5jXBmI/C53zS8kf+TwYIyoAQG34DHhYvn2h
         M3Jq7ypeyS3ZgWPfwm8fQSZuBLv86q00rxMyeN7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.5 65/80] mac80211: fix quiet mode activation in action frames
Date:   Tue, 18 Feb 2020 20:55:26 +0100
Message-Id: <20200218190438.225493571@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

commit 2bf973ff9b9aeceb8acda629ae65341820d4b35b upstream.

Previously I intended to ignore quiet mode in probe response, however
I ended up ignoring it instead for action frames. As a matter of fact,
this path isn't invoked for probe responses to start with. Just revert
this patch.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 7976b1e9e3bf ("mac80211: ignore quiet mode in probe")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20200131111300.891737-15-luca@coelho.fi
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -8,7 +8,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2019 Intel Corporation
+ * Copyright (C) 2018 - 2020 Intel Corporation
  */
 
 #include <linux/delay.h>
@@ -1311,7 +1311,7 @@ ieee80211_sta_process_chanswitch(struct
 	if (!res) {
 		ch_switch.timestamp = timestamp;
 		ch_switch.device_timestamp = device_timestamp;
-		ch_switch.block_tx =  beacon ? csa_ie.mode : 0;
+		ch_switch.block_tx = csa_ie.mode;
 		ch_switch.chandef = csa_ie.chandef;
 		ch_switch.count = csa_ie.count;
 		ch_switch.delay = csa_ie.max_switch_time;
@@ -1404,7 +1404,7 @@ ieee80211_sta_process_chanswitch(struct
 
 	sdata->vif.csa_active = true;
 	sdata->csa_chandef = csa_ie.chandef;
-	sdata->csa_block_tx = ch_switch.block_tx;
+	sdata->csa_block_tx = csa_ie.mode;
 	ifmgd->csa_ignored_same_chan = false;
 
 	if (sdata->csa_block_tx)
@@ -1438,7 +1438,7 @@ ieee80211_sta_process_chanswitch(struct
 	 * reset when the disconnection worker runs.
 	 */
 	sdata->vif.csa_active = true;
-	sdata->csa_block_tx = ch_switch.block_tx;
+	sdata->csa_block_tx = csa_ie.mode;
 
 	ieee80211_queue_work(&local->hw, &ifmgd->csa_connection_drop_work);
 	mutex_unlock(&local->chanctx_mtx);


