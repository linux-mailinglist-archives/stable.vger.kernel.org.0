Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4DB6B4953
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbjCJPLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbjCJPKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:10:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198A21F5C0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:03:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91553B82341
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D399BC433EF;
        Fri, 10 Mar 2023 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460590;
        bh=mGOTvhT10kr3HBdlWc4oVYr5iFFuzh9c95yCZ4R8I04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vblJGRpB9FfOiNBYCo5aGFuFk8ICjSw3XFkhZDA30kcSTzdoYJMAaQv8OpZxH21vF
         O8XvHOZk+xiZ+eY2D+J+KpJhYWLVdtZZ0mDA1QSMKL3JwkYLyPn2yrjURAcZa4zvXk
         frCheiJnBajs2V8bn3TRq0ed8FW9tXUaMBbAYQbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 386/529] wifi: rtl8xxxu: Use a longer retry limit of 48
Date:   Fri, 10 Mar 2023 14:38:49 +0100
Message-Id: <20230310133822.900150816@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
@@ -5908,7 +5908,6 @@ static int rtl8xxxu_config(struct ieee80
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
-	u16 val16;
 	int ret = 0, channel;
 	bool ht40;
 
@@ -5918,14 +5917,6 @@ static int rtl8xxxu_config(struct ieee80
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


