Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990E5676F93
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjAVPXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjAVPWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7418B5252
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2F2E60C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1022EC433D2;
        Sun, 22 Jan 2023 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400973;
        bh=sHqqHcirly3vZgANDjlUIzbOjjHGPUFJzc2Hu5ZeVvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rj4UyyC4/1eo937aDHsYgRHBVvo/UBPEqs1RzRRg9GdrHKjzazCT8axEREX2fUOUX
         Q/9xZ7vNquy97Ez6uREpwctXyqoNTs7UIWj1AT++jE9AWzXnULu+M06MJ+MAr8BbVt
         u9ZnCbhZ8dC351t5Cl+4xll1MkLeHIcMHASlqUNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jouni Malinen <j@w1.fi>,
        Aloka Dixit <quic_alokad@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 034/193] wifi: mac80211: reset multiple BSSID options in stop_ap()
Date:   Sun, 22 Jan 2023 16:02:43 +0100
Message-Id: <20230122150247.962817133@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aloka Dixit <quic_alokad@quicinc.com>

commit 0eb38842ada035d71bb06fb9116f26f24ee0f998 upstream.

Reset multiple BSSID options when all AP related configurations are
reset in ieee80211_stop_ap().

Stale values result in HWSIM test failures (e.g. p2p_group_cli_invalid),
if run after 'he_ap_ema'.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
Link: https://lore.kernel.org/r/20221221185616.11514-1-quic_alokad@quicinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -147,6 +147,7 @@ static int ieee80211_set_ap_mbssid_optio
 	link_conf->bssid_index = 0;
 	link_conf->nontransmitted = false;
 	link_conf->ema_ap = false;
+	link_conf->bssid_indicator = 0;
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP || !params.tx_wdev)
 		return -EINVAL;
@@ -1511,6 +1512,12 @@ static int ieee80211_stop_ap(struct wiph
 	kfree(link_conf->ftmr_params);
 	link_conf->ftmr_params = NULL;
 
+	sdata->vif.mbssid_tx_vif = NULL;
+	link_conf->bssid_index = 0;
+	link_conf->nontransmitted = false;
+	link_conf->ema_ap = false;
+	link_conf->bssid_indicator = 0;
+
 	__sta_info_flush(sdata, true);
 	ieee80211_free_keys(sdata, true);
 


