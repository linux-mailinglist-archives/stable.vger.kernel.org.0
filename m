Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC31A60B0B6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiJXQHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiJXQFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:05:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72486264BE;
        Mon, 24 Oct 2022 07:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF06B8164B;
        Mon, 24 Oct 2022 12:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63155C433D6;
        Mon, 24 Oct 2022 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614021;
        bh=JTuqz7XI2XwjVG0MMTdnj7U3jbDzFHngQ8w9OjJuMJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7Yym9zaMJtdAqE69NhWf4XMsZh+0EtmfLILz54tdpvrz7JLofO0C2d6t9by3C2Q4
         uEESPq6lPGvdWlFDDeNVDqwBljaiZRGySReHm4mprVzy5xSLJgwHbnvBMygY5cZ3ga
         6zvOYRexv4O+1XgMPvph05y6wpuhL7DDcjTcEz74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hari Chandrakanthan <quic_haric@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/390] wifi: mac80211: allow bw change during channel switch in mesh
Date:   Mon, 24 Oct 2022 13:28:19 +0200
Message-Id: <20221024113027.012358409@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Chandrakanthan <quic_haric@quicinc.com>

[ Upstream commit 6b75f133fe05c36c52d691ff21545d5757fff721 ]

>From 'IEEE Std 802.11-2020 section 11.8.8.4.1':
  The mesh channel switch may be triggered by the need to avoid
  interference to a detected radar signal, or to reassign mesh STA
  channels to ensure the MBSS connectivity.

  A 20/40 MHz MBSS may be changed to a 20 MHz MBSS and a 20 MHz
  MBSS may be changed to a 20/40 MHz MBSS.

Since the standard allows the change of bandwidth during
the channel switch in mesh, remove the bandwidth check present in
ieee80211_set_csa_beacon.

Fixes: c6da674aff94 ("{nl,cfg,mac}80211: enable the triggering of CSA frame in mesh")
Signed-off-by: Hari Chandrakanthan <quic_haric@quicinc.com>
Link: https://lore.kernel.org/r/1658903549-21218-1-git-send-email-quic_haric@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8010967a6874..c6a7f1c99abc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3357,9 +3357,6 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_MESH_POINT: {
 		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-		if (params->chandef.width != sdata->vif.bss_conf.chandef.width)
-			return -EINVAL;
-
 		/* changes into another band are not supported */
 		if (sdata->vif.bss_conf.chandef.chan->band !=
 		    params->chandef.chan->band)
-- 
2.35.1



