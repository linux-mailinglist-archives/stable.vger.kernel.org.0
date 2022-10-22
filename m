Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37082608A0F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiJVIqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiJVIpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197032ECF57;
        Sat, 22 Oct 2022 01:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 215D1B82DB2;
        Sat, 22 Oct 2022 07:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3489AC433B5;
        Sat, 22 Oct 2022 07:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424605;
        bh=VpSA4BMhFeKTWyRx8kXmF54tw9u0jbtrAQ4h/xDZpo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz8MJWZikgEqpMsDZ7uj8CG0mYn3DjptpICY9UfwZ96I0NPeT608rXM+A3SdUuDKW
         jNGNSkFIgb6XoHn1suH6cTfc/+HEem8UOq5SkZKnOMNinctDbGsMJgotSfWiAeYoBR
         O1x+YdgyhDIbSpeGXLXw3mOhSvs+SU2PJEDSJEBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hari Chandrakanthan <quic_haric@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 209/717] wifi: mac80211: allow bw change during channel switch in mesh
Date:   Sat, 22 Oct 2022 09:21:28 +0200
Message-Id: <20221022072452.264380904@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 9ca25ae503b0..37484c26259d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3545,9 +3545,6 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
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



