Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A106AE8A4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCGRSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjCGRRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:17:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECA730B3A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3057614E7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46FBC433EF;
        Tue,  7 Mar 2023 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209204;
        bh=QfW+laP1OanIWA4sYqUJnl0brkYrpXlhAxITa+sIqeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+7mX4sG8VA8AKki9fS/r71TmL2hjpp32+5U1EaQ41fp8mY5xj3e4Ut9Th1rj4+M4
         9wYC3YvjejGcabhVwM1SBej1pJJriZGlUWF6FNeJaPs+A8P3IJ8c4f3f1MEBxmURPW
         h8dTfJactII0snYZwPqPAaam/yfziqfaDYlcrMXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0143/1001] wifi: mt76: mt76x0: fix oob access in mt76x0_phy_get_target_power
Date:   Tue,  7 Mar 2023 17:48:35 +0100
Message-Id: <20230307170028.267152681@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6e1abc51c945663bddebfa1beb9590ff5b250eb7 ]

After 'commit ba45841ca5eb ("wifi: mt76: mt76x02: simplify struct
mt76x02_rate_power")', mt76x02 relies on ht[0-7] rate_power data for
vht mcs{0,7}, while it uses vth[0-1] rate_power for vht mcs {8,9}.
Fix a possible out-of-bound access in mt76x0_phy_get_target_power routine.

Fixes: ba45841ca5eb ("wifi: mt76: mt76x02: simplify struct mt76x02_rate_power")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 6c6c8ada7943b..d543ef3de65be 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -642,7 +642,12 @@ mt76x0_phy_get_target_power(struct mt76x02_dev *dev, u8 tx_mode,
 		if (tx_rate > 9)
 			return -EINVAL;
 
-		*target_power = cur_power + dev->rate_power.vht[tx_rate];
+		*target_power = cur_power;
+		if (tx_rate > 7)
+			*target_power += dev->rate_power.vht[tx_rate - 8];
+		else
+			*target_power += dev->rate_power.ht[tx_rate];
+
 		*target_pa_power = mt76x0_phy_get_rf_pa_mode(dev, 1, tx_rate);
 		break;
 	default:
-- 
2.39.2



