Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1660AB48
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiJXNsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbiJXNrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:47:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E388A7E1;
        Mon, 24 Oct 2022 05:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B882612CD;
        Mon, 24 Oct 2022 12:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CE4C433C1;
        Mon, 24 Oct 2022 12:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615187;
        bh=aFZVx0qNoHvv83aQCSjijt5iplhC1BoYST8RD11BKGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlSwrUlVptu/xtIadcMs2Z/WiIhj1g3P1j2hqF0XLm616+n+Gxo5NOKz0VZiddKGM
         Ga6tL9vVIC9dDj2QtTee7rHWovZc+JB3rakBIXRngdSLM9030CEwX5FcGZjWxDAIeO
         S7aCp3dW84XbS5x5UD1ksNBZKrFMw9gD0WorTbfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hari Chandrakanthan <quic_haric@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/530] wifi: mac80211: allow bw change during channel switch in mesh
Date:   Mon, 24 Oct 2022 13:28:19 +0200
Message-Id: <20221024113052.083924803@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 3f625e836a03..4fa216a108ae 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3384,9 +3384,6 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
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



