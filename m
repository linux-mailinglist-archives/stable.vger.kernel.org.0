Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973706B43DB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjCJOTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjCJOSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:18:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE8011AC90
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:17:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0152CB822BC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F70C433EF;
        Fri, 10 Mar 2023 14:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457833;
        bh=yzUcrVSDuRAfsXkYo9mMNAuQiF80ov9CUQJbQOGRYNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hdddlQP3Gmplcg6gI1uD7jCvz2lFIeE5TI8tuhPObJmqGdus0WiJGSEmhAMhBfvT
         xRImqf85VTFAiKgriPzBrjufYKCf97nI0F4A5sWfNuGdqG2pbr/fYIec5C3NJDk9FH
         PnYsxmaMWoZBqX0zhi7/GW/XT5MoGwaHIBefkzks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lee Jones <lee.jones@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-rockchip@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/252] pinctrl: pinctrl-rockchip: Fix a bunch of kerneldoc misdemeanours
Date:   Fri, 10 Mar 2023 14:37:23 +0100
Message-Id: <20230310133721.031541397@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit e1524ea84af7172acc20827f8dca3fc8f72b8f37 ]

Demote headers which are clearly not kerneldoc, provide titles for
struct definition blocks, fix API slip (bitrot) misspellings and
provide some missing entries.

Fixes the following W=1 kernel build warning(s):

 drivers/pinctrl/pinctrl-rockchip.c:82: warning: cannot understand function prototype: 'struct rockchip_iomux '
 drivers/pinctrl/pinctrl-rockchip.c:97: warning: Enum value 'DRV_TYPE_IO_DEFAULT' not described in enum 'rockchip_pin_drv_type'
 drivers/pinctrl/pinctrl-rockchip.c:97: warning: Enum value 'DRV_TYPE_IO_1V8_OR_3V0' not described in enum 'rockchip_pin_drv_type'
 drivers/pinctrl/pinctrl-rockchip.c:97: warning: Enum value 'DRV_TYPE_IO_1V8_ONLY' not described in enum 'rockchip_pin_drv_type'
 drivers/pinctrl/pinctrl-rockchip.c:97: warning: Enum value 'DRV_TYPE_IO_1V8_3V0_AUTO' not described in enum 'rockchip_pin_drv_type'
 drivers/pinctrl/pinctrl-rockchip.c:97: warning: Enum value 'DRV_TYPE_IO_3V3_ONLY' not described in enum 'rockchip_pin_drv_type'
 drivers/pinctrl/pinctrl-rockchip.c:97: warning: Enum value 'DRV_TYPE_MAX' not described in enum 'rockchip_pin_drv_type'
 drivers/pinctrl/pinctrl-rockchip.c:106: warning: Enum value 'PULL_TYPE_IO_DEFAULT' not described in enum 'rockchip_pin_pull_type'
 drivers/pinctrl/pinctrl-rockchip.c:106: warning: Enum value 'PULL_TYPE_IO_1V8_ONLY' not described in enum 'rockchip_pin_pull_type'
 drivers/pinctrl/pinctrl-rockchip.c:106: warning: Enum value 'PULL_TYPE_MAX' not described in enum 'rockchip_pin_pull_type'
 drivers/pinctrl/pinctrl-rockchip.c:109: warning: Cannot understand  * @drv_type: drive strength variant using rockchip_perpin_drv_type
 on line 109 - I thought it was a doc line
 drivers/pinctrl/pinctrl-rockchip.c:122: warning: Cannot understand  * @reg_base: register base of the gpio bank
 on line 109 - I thought it was a doc line
 drivers/pinctrl/pinctrl-rockchip.c:325: warning: Function parameter or member 'route_location' not described in 'rockchip_mux_route_data'
 drivers/pinctrl/pinctrl-rockchip.c:328: warning: Cannot understand  */
 on line 109 - I thought it was a doc line
 drivers/pinctrl/pinctrl-rockchip.c:375: warning: Function parameter or member 'data' not described in 'rockchip_pin_group'
 drivers/pinctrl/pinctrl-rockchip.c:387: warning: Function parameter or member 'ngroups' not described in 'rockchip_pmx_func'

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-rockchip@lists.infradead.org
Link: https://lore.kernel.org/r/20200713144930.1034632-20-lee.jones@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c818ae563bf9 ("pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index dc405d7aa1b78..d9b9bbb45a630 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -70,7 +70,7 @@ enum rockchip_pinctrl_type {
 	RK3399,
 };
 
-/**
+/*
  * Encode variants of iomux registers into a type variable
  */
 #define IOMUX_GPIO_ONLY		BIT(0)
@@ -80,6 +80,7 @@ enum rockchip_pinctrl_type {
 #define IOMUX_WIDTH_3BIT	BIT(4)
 
 /**
+ * struct rockchip_iomux
  * @type: iomux variant using IOMUX_* constants
  * @offset: if initialized to -1 it will be autocalculated, by specifying
  *	    an initial offset value the relevant source offset can be reset
@@ -90,7 +91,7 @@ struct rockchip_iomux {
 	int				offset;
 };
 
-/**
+/*
  * enum type index corresponding to rockchip_perpin_drv_list arrays index.
  */
 enum rockchip_pin_drv_type {
@@ -102,7 +103,7 @@ enum rockchip_pin_drv_type {
 	DRV_TYPE_MAX
 };
 
-/**
+/*
  * enum type index corresponding to rockchip_pull_list arrays index.
  */
 enum rockchip_pin_pull_type {
@@ -112,6 +113,7 @@ enum rockchip_pin_pull_type {
 };
 
 /**
+ * struct rockchip_drv
  * @drv_type: drive strength variant using rockchip_perpin_drv_type
  * @offset: if initialized to -1 it will be autocalculated, by specifying
  *	    an initial offset value the relevant source offset can be reset
@@ -125,8 +127,9 @@ struct rockchip_drv {
 };
 
 /**
+ * struct rockchip_pin_bank
  * @reg_base: register base of the gpio bank
- * @reg_pull: optional separate register for additional pull settings
+ * @regmap_pull: optional separate register for additional pull settings
  * @clk: clock of the gpio bank
  * @irq: interrupt of the gpio bank
  * @saved_masks: Saved content of GPIO_INTEN at suspend time.
@@ -144,6 +147,8 @@ struct rockchip_drv {
  * @gpio_chip: gpiolib chip
  * @grange: gpio range
  * @slock: spinlock for the gpio bank
+ * @toggle_edge_mode: bit mask to toggle (falling/rising) edge mode
+ * @recalced_mask: bit mask to indicate a need to recalulate the mask
  * @route_mask: bits describing the routing pins of per bank
  */
 struct rockchip_pin_bank {
@@ -312,6 +317,7 @@ struct rockchip_mux_recalced_data {
  * @bank_num: bank number.
  * @pin: index at register or used to calc index.
  * @func: the min pin.
+ * @route_location: the mux route location (same, pmu, grf).
  * @route_offset: the max pin.
  * @route_val: the register offset.
  */
@@ -323,8 +329,6 @@ struct rockchip_mux_route_data {
 	u32 route_val;
 };
 
-/**
- */
 struct rockchip_pin_ctrl {
 	struct rockchip_pin_bank	*pin_banks;
 	u32				nr_banks;
@@ -362,9 +366,7 @@ struct rockchip_pin_config {
  * @name: name of the pin group, used to lookup the group.
  * @pins: the pins included in this group.
  * @npins: number of pins included in this group.
- * @func: the mux function number to be programmed when selected.
- * @configs: the config values to be set for each pin
- * @nconfigs: number of configs for each pin
+ * @data: local pin configuration
  */
 struct rockchip_pin_group {
 	const char			*name;
@@ -377,7 +379,7 @@ struct rockchip_pin_group {
  * struct rockchip_pmx_func: represent a pin function.
  * @name: name of the pin function, used to lookup the function.
  * @groups: one or more names of pin groups that provide this function.
- * @num_groups: number of groups included in @groups.
+ * @ngroups: number of groups included in @groups.
  */
 struct rockchip_pmx_func {
 	const char		*name;
-- 
2.39.2



