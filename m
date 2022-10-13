Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2375FE280
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJMTMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiJMTMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:12:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D23A4AA;
        Thu, 13 Oct 2022 12:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D3C61938;
        Thu, 13 Oct 2022 17:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C16CC433D7;
        Thu, 13 Oct 2022 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683880;
        bh=iSU4oNQTGikY1NG5fAAZBCNpZVckUY3c/pPdJ+jMIKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vyf1yqgZ+LTTc0hge2FYKEgVTJVDWaXcukYQvs01TEkxnlk6iCyAg6m9HpeVP1JYc
         Ma5MH01/L13d62XJVom4TR9kvRnqod3XWjp7xAE8AMIbO1rO0b944CU8a4oU8l8HE4
         0/+KyUL0bz/mv9SoaUmoQ6rJK7q5uRijbwfXBWwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 21/27] wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
Date:   Thu, 13 Oct 2022 19:52:50 +0200
Message-Id: <20221013175144.324918092@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175143.518476113@linuxfoundation.org>
References: <20221013175143.518476113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -3749,6 +3749,8 @@ static int hwsim_cloned_frame_received_n
 
 	rx_status.band = channel->band;
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
+	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
+		goto out;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (void *)skb->data;


