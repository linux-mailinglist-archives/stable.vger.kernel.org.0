Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B7F60484B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiJSNxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiJSNwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:52:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D836A1960AA;
        Wed, 19 Oct 2022 06:36:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B40EB82316;
        Wed, 19 Oct 2022 08:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B70C433D6;
        Wed, 19 Oct 2022 08:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169339;
        bh=qcIfLVy8NdhyzguIZ1nO/PoYtpJQB81Qs76YDchO8XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyFqr05e+eoopmBTag7Xf2atGLn7ehS3lQ2foOSMiGksVYTjH1l1G/BEOgQq3JRgf
         BqgHVcooGXXpmakWyOBOkJyDDcz1GQIuIdEKM/eZXO+B2LtvgBCDwII8mz0KB9oIuh
         7pJtX+/n7U1JujIl9WR+0TfvT6s3rVDZ+/sGdhlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 240/862] wifi: mac80211: fix use-after-free
Date:   Wed, 19 Oct 2022 10:25:27 +0200
Message-Id: <20221019083300.643211248@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 40fb87129049ec5876dabf4a4d4aed6642b31f1a ]

We've already freed the assoc_data at this point, so need
to use another copy of the AP (MLD) address instead.

Fixes: 81151ce462e5 ("wifi: mac80211: support MLO authentication/association with one link")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fc764984d687..1e9cb4be6ed3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5122,7 +5122,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	resp.req_ies = ifmgd->assoc_req_ies;
 	resp.req_ies_len = ifmgd->assoc_req_ies_len;
 	if (sdata->vif.valid_links)
-		resp.ap_mld_addr = assoc_data->ap_addr;
+		resp.ap_mld_addr = sdata->vif.cfg.ap_addr;
 	cfg80211_rx_assoc_resp(sdata->dev, &resp);
 notify_driver:
 	drv_mgd_complete_tx(sdata->local, sdata, &info);
-- 
2.35.1



