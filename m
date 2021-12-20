Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209DB47AE6E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhLTPBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbhLTO4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A414C08EC89;
        Mon, 20 Dec 2021 06:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EECD6611A4;
        Mon, 20 Dec 2021 14:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D7BC36AE7;
        Mon, 20 Dec 2021 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011708;
        bh=W8pRiH5lCuoBh0hEQSbQLh/sOwpgt2Yhx+0Nacp9XHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZ4xxq4s0RIFh0Yvw61L34r9YyPGhXcYTorsQfc/C/WNj1kDSbARLbuN1AgehGda7
         TieY0A7M/wyEHjPP9bIqfU68JS+C1UBfUIyVSIwETYED+hgutXwBTQTP/3yKMrCePz
         Vo/d72kjJVsCkPihORQ4jBIVqmoG9+2srrc7lMIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/99] mac80211: fix lookup when adding AddBA extension element
Date:   Mon, 20 Dec 2021 15:34:17 +0100
Message-Id: <20211220143030.866310876@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 511ab0c1dfb260a6b17b8771109e8d63474473a7 ]

We should be doing the HE capabilities lookup based on the full
interface type so if P2P doesn't have HE but client has it doesn't
get confused. Fix that.

Fixes: 2ab45876756f ("mac80211: add support for the ADDBA extension element")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.010fc1d61137.If3a468145f29d670cb00a693bed559d8290ba693@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index cd4cf84a7f99f..6ef8ded4ec764 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 
 /**
@@ -191,7 +191,8 @@ static void ieee80211_add_addbaext(struct ieee80211_sub_if_data *sdata,
 	sband = ieee80211_get_sband(sdata);
 	if (!sband)
 		return;
-	he_cap = ieee80211_get_he_iftype_cap(sband, sdata->vif.type);
+	he_cap = ieee80211_get_he_iftype_cap(sband,
+					     ieee80211_vif_type_p2p(&sdata->vif));
 	if (!he_cap)
 		return;
 
-- 
2.33.0



