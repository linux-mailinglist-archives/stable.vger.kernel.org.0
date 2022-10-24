Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2646860A4C9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiJXMQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiJXMPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:15:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7558052B;
        Mon, 24 Oct 2022 04:56:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1208B6126B;
        Mon, 24 Oct 2022 11:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25222C433C1;
        Mon, 24 Oct 2022 11:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612547;
        bh=kQIWC0ZgBV/lLuQ8oDBM12FE6Kn6eno2vD1KsA9VkqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldUVLxGorLc03Lz+J/5lB0KVih3+Y3d3KedVmHDyYCxSgMNyVTLMmdH359ztOharK
         fhQOD8IxIJ81konEVqX/wB3mSItFUT7WO1K6aygSeAQZSllpP1J+zOFNwUDK4fqH0D
         GnUJ8s0QRnTFj6jPB7P7Wvmi4Q3vxpsHQ8bcyfR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 029/229] wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
Date:   Mon, 24 Oct 2022 13:29:08 +0200
Message-Id: <20221024113000.070441529@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 1833b6f46d7e2830251a063935ab464256defe22 upstream.

If the tool on the other side (e.g. wmediumd) gets confused
about the rate, we hit a warning in mac80211. Silence that
by effectively duplicating the check here and dropping the
frame silently (in mac80211 it's dropped with the warning).

Reported-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Tested-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3270,6 +3270,8 @@ static int hwsim_cloned_frame_received_n
 
 	rx_status.band = data2->channel->band;
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
+	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
+		goto out;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));


