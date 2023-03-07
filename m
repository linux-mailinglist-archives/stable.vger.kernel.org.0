Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35E36AECDE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjCGR6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCGR6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:58:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F05A5903
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08A9861523
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00870C433EF;
        Tue,  7 Mar 2023 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211564;
        bh=Z4qy3MFTkul+54Agg3akvYeznF+Z8UQKWOBT2oj1r/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lt3KhLm45PpZ0PO+v/Y6HbGCt0csh42k9CpNxWSailI+IK4POtKqmWhFARd3jEc83
         eFFugqs5KIb1mgemhNGCXdsnV2uOCh+ZYkREzeM+bc5NKUWi1GN/Y2rwfc9EmMlxBi
         G6QXskdkyRfbZ7NeeZ/3qoHsj2wPRUeV4RP0yHiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 0904/1001] wifi: rtl8xxxu: Use a longer retry limit of 48
Date:   Tue,  7 Mar 2023 18:01:16 +0100
Message-Id: <20230307170101.244701312@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 2a86aa9a1892d60ef2e3f310f5b42b8b05546d65 upstream.

The Realtek rate control algorithm goes back and forth a lot between
the highest and the lowest rate it's allowed to use. This is due to
a lot of frames being dropped because the retry limits set by
IEEE80211_CONF_CHANGE_RETRY_LIMITS are too low. (Experimentally, they
are 4 for long frames and 7 for short frames.)

The vendor drivers hardcode the value 48 for both retry limits (for
station mode), which makes dropped frames very rare and thus the rate
control is more stable.

Because most Realtek chips handle the rate control in the firmware,
which can't be modified, ignore the limits set by
IEEE80211_CONF_CHANGE_RETRY_LIMITS and use the value 48 (set during
chip initialisation), same as the vendor drivers.

Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/477d745b-6bac-111d-403c-487fc19aa30d@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5954,7 +5954,6 @@ static int rtl8xxxu_config(struct ieee80
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
-	u16 val16;
 	int ret = 0, channel;
 	bool ht40;
 
@@ -5964,14 +5963,6 @@ static int rtl8xxxu_config(struct ieee80
 			 __func__, hw->conf.chandef.chan->hw_value,
 			 changed, hw->conf.chandef.width);
 
-	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
-		val16 = ((hw->conf.long_frame_max_tx_count <<
-			  RETRY_LIMIT_LONG_SHIFT) & RETRY_LIMIT_LONG_MASK) |
-			((hw->conf.short_frame_max_tx_count <<
-			  RETRY_LIMIT_SHORT_SHIFT) & RETRY_LIMIT_SHORT_MASK);
-		rtl8xxxu_write16(priv, REG_RETRY_LIMIT, val16);
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		switch (hw->conf.chandef.width) {
 		case NL80211_CHAN_WIDTH_20_NOHT:


