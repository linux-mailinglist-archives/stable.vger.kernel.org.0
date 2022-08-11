Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4A58F93C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 10:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiHKIj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 04:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiHKIj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 04:39:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57B190C4A
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 01:39:55 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w11-20020a17090a380b00b001f73f75a1feso4691241pjb.2
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 01:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:mime-version:user-agent
         :date:message-id:subject:cc:to:from:from:to:cc;
        bh=BhgT832ENodZ0nV5bwzSt4tuRJxZUWDCHZLtDrem5Sw=;
        b=lUg+7yZ49wF1jmBO9sAy6pB2LezGlZ9z4AIj041JsLdOdUZQfEbHbAveaVkY6USp/h
         XfzFkt5FkLJgRWjKf3SEVTR0VkPqnnYJMzeNzBSy0vkE3sZQFxPtWfFe4YMjbfpyNrGn
         6YTb75F/7WNMIg1Ivq0tZelGfUnR+jWsKsNSUt0V2xCzaIWvWw94LdcoNqywVPvYGPAi
         UZ4/L+FAo4ORYayqZgLe3hWdYwmIhirExKWlIUM9W3JsoHrcN15gPGtqOigmx721fiMo
         bbSstMCCcbOkjEIAaGkuzQpPMKBKGqlN4CbVKYAigHUd5CUIK19w74QuQ97dxmyx1nil
         t5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:mime-version:user-agent
         :date:message-id:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=BhgT832ENodZ0nV5bwzSt4tuRJxZUWDCHZLtDrem5Sw=;
        b=37hoybJ7W0cNsaZD+8s/Br9YrHzlN9C6cQWug7/FnqWOcxOxNoadnX2tKyXRaj9Hci
         UUdriR3Vu4PjmcdZ5mMva3EYt1CEGatrU4l/djtptZtYSo52XUehqCbjmOvmmunElOU3
         9TS2J2Cau6IP6UOuEZR7BhRweK1gVFe0kVIw7TKcUE76bo0QK7cR8R0HNBvurAjd1Ujg
         WMP0Jqc0PGlbqOAsVJ86y5hth25XuMgMRxbbRfbXuNbteFTFrTodu6JPGIfs6vbTnkGH
         FHxRNkIfseE30t7juoWXx5+p5l7hERSppwf6nSIxR1UD9zwGPyzoHPGOarRtbcpvi2Fg
         UzpA==
X-Gm-Message-State: ACgBeo2YWpXrZJTNWjNKGXSN1Op5EgyD90P/9Mnt3UYdRaRTcTnSxjis
        jlr+Lsq6VSs34rZ2+2PJXMs=
X-Google-Smtp-Source: AA6agR41e9PMsS4TFXJH6lxZxZlbA74HwfyjNUoS2g8NLWFjXHuq0d43LNxlAyUfewCNcrvnKb/K8g==
X-Received: by 2002:a17:90b:3a8b:b0:1f5:2048:cbab with SMTP id om11-20020a17090b3a8b00b001f52048cbabmr7657843pjb.196.1660207195330;
        Thu, 11 Aug 2022 01:39:55 -0700 (PDT)
Received: from [0.0.0.0] ([205.198.104.55])
        by smtp.gmail.com with ESMTPSA id p9-20020a63fe09000000b00401a9bc0f33sm11102556pgh.85.2022.08.11.01.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 01:39:55 -0700 (PDT)
From:   Linjun Bao <meljbao@gmail.com>
To:     stable@vger.kernel.org
Cc:     meljbao@gmail.com
Subject: [PATCH] igc: Remove _I_PHY_ID checking for i225 devices
Message-ID: <5d499487-2503-f1bd-586c-57ac755e1f41@gmail.com>
Date:   Thu, 11 Aug 2022 16:39:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7c496de538ee ("igc: Remove _I_PHY_ID checking") upstream,
backported to stable kernel 5.4 to support i225 Ethernet adapters.

Signed-off-by: Linjun Bao <meljbao@gmail.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 10 +---------
 drivers/net/ethernet/intel/igc/igc_main.c |  3 +--
 drivers/net/ethernet/intel/igc/igc_phy.c  |  6 ++----
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index db289bcce21d..d66429eb14a5 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -187,15 +187,7 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
 
 	igc_check_for_copper_link(hw);
 
-	/* Verify phy id and set remaining function pointers */
-	switch (phy->id) {
-	case I225_I_PHY_ID:
-		phy->type	= igc_phy_i225;
-		break;
-	default:
-		ret_val = -IGC_ERR_PHY;
-		goto out;
-	}
+	phy->type = igc_phy_i225;
 
 out:
 	return ret_val;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9ba05d9aa8e0..b8297a63a7fd 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2884,8 +2884,7 @@ bool igc_has_link(struct igc_adapter *adapter)
 		break;
 	}
 
-	if (hw->mac.type == igc_i225 &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (hw->mac.type == igc_i225) {
 		if (!netif_carrier_ok(adapter->netdev)) {
 			adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
 		} else if (!(adapter->flags & IGC_FLAG_NEED_LINK_UPDATE)) {
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 6156c76d765f..1be112ce6774 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -235,8 +235,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 			return ret_val;
 	}
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL) {
 		/* Read the MULTI GBT AN Control Register - reg 7.32 */
 		ret_val = phy->ops.read_reg(hw, (STANDARD_AN_REG_MASK <<
 					    MMD_DEVADDR_SHIFT) |
@@ -376,8 +375,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 		ret_val = phy->ops.write_reg(hw, PHY_1000T_CTRL,
 					     mii_1000t_ctrl_reg);
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID)
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL)
 		ret_val = phy->ops.write_reg(hw,
 					     (STANDARD_AN_REG_MASK <<
 					     MMD_DEVADDR_SHIFT) |
-- 
2.25.1
