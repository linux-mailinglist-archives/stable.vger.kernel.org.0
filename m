Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D755E480111
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhL0PxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbhL0PvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:51:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E72C08E853;
        Mon, 27 Dec 2021 07:46:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 844C461118;
        Mon, 27 Dec 2021 15:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A48C36AE7;
        Mon, 27 Dec 2021 15:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619964;
        bh=oao8xLFXmz1jSat8A4tWr5HAsQkEVffxrl6EFECo8c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhBfmk0Jhig7/lgqqnLgsbqW4EjtWKenykGcAfgIo7zqOUJ1oWGHVTP0vfmr/S50E
         HlbaYoN+553H3jeYGdn3sdkf1lquCVcchixeBSQKQJIv95Ao6X3xXAUjCpR1zML/xa
         LuCwATQ2UKJZffNb2YB6MCFDKXY205wboKJP5Gs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 123/128] r8152: sync ocp base
Date:   Mon, 27 Dec 2021 16:31:38 +0100
Message-Id: <20211227151335.628523510@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

commit b24edca309535c2d9af86aab95d64065f6ef1d26 upstream.

There are some chances that the actual base of hardware is different
from the value recorded by driver, so we have to reset the variable
of ocp_base to sync it.

Set ocp_base to -1. Then, it would be updated and the new base would be
set to the hardware next time.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -32,7 +32,7 @@
 #define NETNEXT_VERSION		"12"
 
 /* Information for net */
-#define NET_VERSION		"11"
+#define NET_VERSION		"12"
 
 #define DRIVER_VERSION		"v1." NETNEXT_VERSION "." NET_VERSION
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
@@ -4016,6 +4016,11 @@ static void rtl_clear_bp(struct r8152 *t
 	ocp_write_word(tp, type, PLA_BP_BA, 0);
 }
 
+static inline void rtl_reset_ocp_base(struct r8152 *tp)
+{
+	tp->ocp_base = -1;
+}
+
 static int rtl_phy_patch_request(struct r8152 *tp, bool request, bool wait)
 {
 	u16 data, check;
@@ -4087,8 +4092,6 @@ static int rtl_post_ram_code(struct r815
 
 	rtl_phy_patch_request(tp, false, wait);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
-
 	return 0;
 }
 
@@ -4800,6 +4803,8 @@ static void rtl_ram_code_speed_up(struct
 	u32 len;
 	u8 *data;
 
+	rtl_reset_ocp_base(tp);
+
 	if (sram_read(tp, SRAM_GPHY_FW_VER) >= __le16_to_cpu(phy->version)) {
 		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
 		return;
@@ -4845,7 +4850,8 @@ static void rtl_ram_code_speed_up(struct
 		}
 	}
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
+	rtl_reset_ocp_base(tp);
+
 	rtl_phy_patch_request(tp, false, wait);
 
 	if (sram_read(tp, SRAM_GPHY_FW_VER) == __le16_to_cpu(phy->version))
@@ -4861,6 +4867,8 @@ static int rtl8152_fw_phy_ver(struct r81
 	ver_addr = __le16_to_cpu(phy_ver->ver.addr);
 	ver = __le16_to_cpu(phy_ver->ver.data);
 
+	rtl_reset_ocp_base(tp);
+
 	if (sram_read(tp, ver_addr) >= ver) {
 		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
 		return 0;
@@ -4877,6 +4885,8 @@ static void rtl8152_fw_phy_fixup(struct
 {
 	u16 addr, data;
 
+	rtl_reset_ocp_base(tp);
+
 	addr = __le16_to_cpu(fix->setting.addr);
 	data = ocp_reg_read(tp, addr);
 
@@ -4908,6 +4918,8 @@ static void rtl8152_fw_phy_union_apply(s
 	u32 length;
 	int i, num;
 
+	rtl_reset_ocp_base(tp);
+
 	num = phy->pre_num;
 	for (i = 0; i < num; i++)
 		sram_write(tp, __le16_to_cpu(phy->pre_set[i].addr),
@@ -4938,6 +4950,8 @@ static void rtl8152_fw_phy_nc_apply(stru
 	u32 length, i, num;
 	__le16 *data;
 
+	rtl_reset_ocp_base(tp);
+
 	mode_reg = __le16_to_cpu(phy->mode_reg);
 	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_pre));
 	sram_write(tp, __le16_to_cpu(phy->ba_reg),
@@ -5107,6 +5121,7 @@ post_fw:
 	if (rtl_fw->post_fw)
 		rtl_fw->post_fw(tp);
 
+	rtl_reset_ocp_base(tp);
 	strscpy(rtl_fw->version, fw_hdr->version, RTL_VER_SIZE);
 	dev_info(&tp->intf->dev, "load %s successfully\n", rtl_fw->version);
 }
@@ -8484,6 +8499,8 @@ static int rtl8152_resume(struct usb_int
 
 	mutex_lock(&tp->control);
 
+	rtl_reset_ocp_base(tp);
+
 	if (test_bit(SELECTIVE_SUSPEND, &tp->flags))
 		ret = rtl8152_runtime_resume(tp);
 	else
@@ -8499,6 +8516,7 @@ static int rtl8152_reset_resume(struct u
 	struct r8152 *tp = usb_get_intfdata(intf);
 
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
+	rtl_reset_ocp_base(tp);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
 	set_ethernet_addr(tp, true);


