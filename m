Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB4B69CECC
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbjBTOCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbjBTOCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:02:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545071EFFC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E0DEB80D4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072D9C433D2;
        Mon, 20 Feb 2023 14:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901712;
        bh=g/f6NHbYkEwX10UaZMVsEuFIrY5AM9iwEsKQfm98TBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLBKduQxTONNApoaEbuQs3vg0QEkoDxkbYmqJsR2bnhqfQoSHr28n12KhKPWwfCgv
         cVDTHzt9oLf2AXMTH0ax7b7AuKVgPF8H+3oVB46dm963XkCsphZjpV7cJEBLtMwqPx
         n5+P0lknsuazmZteTOR0SB/ObDdcXCTG+4nwqebE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Jamie Bainbridge <jbainbri@redhat.com>,
        Corinna Vinschen <vinschen@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 100/118] igb: conditionalize I2C bit banging on external thermal sensor support
Date:   Mon, 20 Feb 2023 14:36:56 +0100
Message-Id: <20230220133604.404557420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Corinna Vinschen <vinschen@redhat.com>

commit 5d54cb1767e06025819daa6769e0f18dcbc60936 upstream.

Commit a97f8783a937 ("igb: unbreak I2C bit-banging on i350") introduced
code to change I2C settings to bit banging unconditionally.

However, this patch introduced a regression:  On an Intel S2600CWR
Server Board with three NICs:

- 1x dual-port copper
  Intel I350 Gigabit Network Connection [8086:1521] (rev 01)
  fw 1.63, 0x80000dda

- 2x quad-port SFP+ with copper SFP Avago ABCU-5700RZ
  Intel I350 Gigabit Fiber Network Connection [8086:1522] (rev 01)
  fw 1.52.0

the SFP NICs no longer get link at all.  Reverting commit a97f8783a937
or switching to the Intel out-of-tree driver both fix the problem.

Per the igb out-of-tree driver, I2C bit banging on i350 depends on
support for an external thermal sensor (ETS).  However, commit
a97f8783a937 added bit banging unconditionally.  Additionally, the
out-of-tree driver always calls init_thermal_sensor_thresh on probe,
while our driver only calls init_thermal_sensor_thresh only in
igb_reset(), and only if an ETS is present, ignoring the internal
thermal sensor.  The affected SFPs don't provide an ETS.  Per Intel,
the behaviour is a result of i350 firmware requirements.

This patch fixes the problem by aligning the behaviour to the
out-of-tree driver:

- split igb_init_i2c() into two functions:
  - igb_init_i2c() only performs the basic I2C initialization.
  - igb_set_i2c_bb() makes sure that E1000_CTRL_I2C_ENA is set
    and enables bit-banging.

- igb_probe() only calls igb_set_i2c_bb() if an ETS is present.

- igb_probe() calls init_thermal_sensor_thresh() unconditionally.

- igb_reset() aligns its behaviour to igb_probe(), i. e., call
  igb_set_i2c_bb() if an ETS is present and call
  init_thermal_sensor_thresh() unconditionally.

Fixes: a97f8783a937 ("igb: unbreak I2C bit-banging on i350")
Tested-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Co-developed-by: Jamie Bainbridge <jbainbri@redhat.com>
Signed-off-by: Jamie Bainbridge <jbainbri@redhat.com>
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20230214185549.1306522-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 42 +++++++++++++++++------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d8e3048b93dd..b5b443883da9 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2256,6 +2256,30 @@ static void igb_enable_mas(struct igb_adapter *adapter)
 	}
 }
 
+#ifdef CONFIG_IGB_HWMON
+/**
+ *  igb_set_i2c_bb - Init I2C interface
+ *  @hw: pointer to hardware structure
+ **/
+static void igb_set_i2c_bb(struct e1000_hw *hw)
+{
+	u32 ctrl_ext;
+	s32 i2cctl;
+
+	ctrl_ext = rd32(E1000_CTRL_EXT);
+	ctrl_ext |= E1000_CTRL_I2C_ENA;
+	wr32(E1000_CTRL_EXT, ctrl_ext);
+	wrfl();
+
+	i2cctl = rd32(E1000_I2CPARAMS);
+	i2cctl |= E1000_I2CBB_EN
+		| E1000_I2C_CLK_OE_N
+		| E1000_I2C_DATA_OE_N;
+	wr32(E1000_I2CPARAMS, i2cctl);
+	wrfl();
+}
+#endif
+
 void igb_reset(struct igb_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
@@ -2400,7 +2424,8 @@ void igb_reset(struct igb_adapter *adapter)
 			 * interface.
 			 */
 			if (adapter->ets)
-				mac->ops.init_thermal_sensor_thresh(hw);
+				igb_set_i2c_bb(hw);
+			mac->ops.init_thermal_sensor_thresh(hw);
 		}
 	}
 #endif
@@ -3117,21 +3142,12 @@ static void igb_init_mas(struct igb_adapter *adapter)
  **/
 static s32 igb_init_i2c(struct igb_adapter *adapter)
 {
-	struct e1000_hw *hw = &adapter->hw;
 	s32 status = 0;
-	s32 i2cctl;
 
 	/* I2C interface supported on i350 devices */
 	if (adapter->hw.mac.type != e1000_i350)
 		return 0;
 
-	i2cctl = rd32(E1000_I2CPARAMS);
-	i2cctl |= E1000_I2CBB_EN
-		| E1000_I2C_CLK_OUT | E1000_I2C_CLK_OE_N
-		| E1000_I2C_DATA_OUT | E1000_I2C_DATA_OE_N;
-	wr32(E1000_I2CPARAMS, i2cctl);
-	wrfl();
-
 	/* Initialize the i2c bus which is controlled by the registers.
 	 * This bus will use the i2c_algo_bit structure that implements
 	 * the protocol through toggling of the 4 bits in the register.
@@ -3521,6 +3537,12 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			adapter->ets = true;
 		else
 			adapter->ets = false;
+		/* Only enable I2C bit banging if an external thermal
+		 * sensor is supported.
+		 */
+		if (adapter->ets)
+			igb_set_i2c_bb(hw);
+		hw->mac.ops.init_thermal_sensor_thresh(hw);
 		if (igb_sysfs_init(adapter))
 			dev_err(&pdev->dev,
 				"failed to allocate sysfs resources\n");
-- 
2.39.1



