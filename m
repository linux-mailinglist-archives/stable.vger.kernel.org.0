Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C76D540738
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347588AbiFGRoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347957AbiFGRnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:43:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB7C12DBD5;
        Tue,  7 Jun 2022 10:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 656D4CE23E9;
        Tue,  7 Jun 2022 17:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597BBC385A5;
        Tue,  7 Jun 2022 17:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623260;
        bh=xefLKrafgz1e+ulOs7MaMGAkmrbR2qnND4iwEX0xVRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFS6Sj8ghO0F/uYMQ9gikh2z6KEo7L3ypkUfvO3dRiY4fL9/YuZnWofzT9gTQB0Dj
         qEYCWZGTfNdRHTP8hASJd7pnT6ez+pO2seQASt0qMQ37sFXw0eBshWdJHbwmiifOd1
         btqJ+J9BaIFA9JhBIOCUC4SC5ljQtIlbL8+a+vgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 353/452] iwlwifi: mvm: fix assert 1F04 upon reconfig
Date:   Tue,  7 Jun 2022 19:03:30 +0200
Message-Id: <20220607164919.077862118@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 9d096e3d3061dbf4ee10e2b59fc2c06e05bdb997 upstream.

When we reconfig we must not send the MAC_POWER command that relates to
a MAC that was not yet added to the firmware.

Ignore those in the iterator.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20220517120044.ed2ffc8ce732.If786e19512d0da4334a6382ea6148703422c7d7b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -621,6 +621,9 @@ static void iwl_mvm_power_get_vifs_itera
 	struct iwl_power_vifs *power_iterator = _data;
 	bool active = mvmvif->phy_ctxt && mvmvif->phy_ctxt->id < NUM_PHY_CTX;
 
+	if (!mvmvif->uploaded)
+		return;
+
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;


