Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A94603E76
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiJSJP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiJSJNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:13:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A038F92F7A;
        Wed, 19 Oct 2022 02:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA1261777;
        Wed, 19 Oct 2022 08:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50037C433C1;
        Wed, 19 Oct 2022 08:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169336;
        bh=PBClYfgcUgCNfOMwp2cjYimZKZ/95lBXgpCYtvQU0AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=an1HmjQEVSr5wpuHMsBes9iBINMD3bnUIe4pvhYJs4bfaI4wr/q0iI86lBdXHc3Ua
         HvDsDS0etkxVeNUj6ltouHkplaSoiyam9sbGm8lmBPGBdz4ZtUrNJNT1xmOa8Aitai
         Q1apVaSEdlZshw9Dt/xw2Ir/bvM1laFnw4NNFppc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaul Triebitz <shaul.triebitz@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 239/862] wifi: cfg80211: get correct AP link chandef
Date:   Wed, 19 Oct 2022 10:25:26 +0200
Message-Id: <20221019083300.593549356@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit bc1857619cc7612117d2ee1ed05b5bfeb638614b ]

When checking for channel regulatory validity, use the
AP link chandef (and not mesh's chandef).

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c7383ede794f..d5c7a5aa6853 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2389,6 +2389,10 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 		switch (iftype) {
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_P2P_GO:
+			if (!wdev->links[link].ap.beacon_interval)
+				continue;
+			chandef = wdev->links[link].ap.chandef;
+			break;
 		case NL80211_IFTYPE_MESH_POINT:
 			if (!wdev->u.mesh.beacon_interval)
 				continue;
-- 
2.35.1



