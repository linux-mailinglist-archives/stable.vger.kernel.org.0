Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28CA47ADF8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbhLTO5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46028 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239125AbhLTOzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:55:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18DC56118D;
        Mon, 20 Dec 2021 14:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EA8C36AE8;
        Mon, 20 Dec 2021 14:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012103;
        bh=zEsLB50+suusVsq8Lt5w5YXZT+o/TsB4eJDgvHuBmS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgZO0UE7X3139c7H4q1VVTVqb142Qgv2x7iyezfbfOTI5hMVM3u++K2WcbYF9HNJd
         vqsr236QfX2htbmt0m+cg8BGLqTgtY7FocK89KzMWrth+vimhtsv8dgjv+t47xYRby
         hDeWWeWgHrFTnGH2qFjOjAon29XJuNh58Yc6Id7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/177] mac80211: fix lookup when adding AddBA extension element
Date:   Mon, 20 Dec 2021 15:33:52 +0100
Message-Id: <20211220143042.861542115@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
index cce28e3b22323..ef729b1e39ea3 100644
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



