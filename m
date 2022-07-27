Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5280B582DB2
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbiG0RBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbiG0RBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:01:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39BB57221;
        Wed, 27 Jul 2022 09:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04AAD601C0;
        Wed, 27 Jul 2022 16:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE86C433D6;
        Wed, 27 Jul 2022 16:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939875;
        bh=zl8nkHP5kUCeFYDnIhWo5vo26zKl4GVTupTw4VrhxM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXVQmMUGbGv1Wg5JS0zzQDFbRmB0mRaXG5EK0DAM8L4AtQeX+mPhRfoE2ebPiQx5V
         j15kLZoAwJHNbwmeq2affDrbtyroAqtWgst1xqw4Z1IsVntb9eOb6WKzLlPOIK8DKq
         pEq0C/Th/5QMsR/GuobA3b+7ab9gvi7vLEvz3lfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 027/201] r8152: fix a WOL issue
Date:   Wed, 27 Jul 2022 18:08:51 +0200
Message-Id: <20220727161028.026683186@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

commit cdf0b86b250fd3c1c3e120c86583ea510c52e4ce upstream.

This fixes that the platform is waked by an unexpected packet. The
size and range of FIFO is different when the device enters S3 state,
so it is necessary to correct some settings when suspending.

Regardless of jumbo frame, set RMS to 1522 and MTPS to MTPS_DEFAULT.
Besides, enable MCU_BORW_EN to update the method of calculating the
pointer of data. Then, the hardware could get the correct data.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Link: https://lore.kernel.org/r/20220718082120.10957-391-nic_swsd@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -32,7 +32,7 @@
 #define NETNEXT_VERSION		"12"
 
 /* Information for net */
-#define NET_VERSION		"12"
+#define NET_VERSION		"13"
 
 #define DRIVER_VERSION		"v1." NETNEXT_VERSION "." NET_VERSION
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
@@ -5915,7 +5915,8 @@ static void r8153_enter_oob(struct r8152
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, 1522);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
 
 	switch (tp->version) {
 	case RTL_VER_03:
@@ -5951,6 +5952,10 @@ static void r8153_enter_oob(struct r8152
 	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+
 	rxdy_gated_en(tp, false);
 
 	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
@@ -6553,6 +6558,9 @@ static void rtl8156_down(struct r8152 *t
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, 1522);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
+
 	/* Clear teredo wake event. bit[15:8] is the teredo wakeup
 	 * type. Set it to zero. bits[7:0] are the W1C bits about
 	 * the events. Set them to all 1 to clear them.
@@ -6563,6 +6571,10 @@ static void rtl8156_down(struct r8152 *t
 	ocp_data |= NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+
 	rtl_rx_vlan_en(tp, true);
 	rxdy_gated_en(tp, false);
 


