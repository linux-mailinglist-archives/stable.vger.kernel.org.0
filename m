Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFFC60A859
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiJXNE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiJXNC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:02:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981414152E;
        Mon, 24 Oct 2022 05:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02BBF612A0;
        Mon, 24 Oct 2022 12:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169E1C433C1;
        Mon, 24 Oct 2022 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613963;
        bh=Rgjgdw2DC7kp/77ebZizQDTOOM9pa7o69IMwmu0EMHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSGRuwF8KJRt8kwHS3wWKNl56WTlRdiXiHSVpEP0JWCCVXk6rUMuiB32sk6IcVBKg
         aOQpeOvfy3M04lTGwMC1GJW1o/SPw2EnTKhw7Nte1buWrzD9PP9/+g73127K9smjxZ
         N+NH04rZ1sQJGfWMh/PO/A2o69DG5zy6Y65pS5Gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 079/390] thunderbolt: Explicitly enable lane adapter hotplug events at startup
Date:   Mon, 24 Oct 2022 13:27:56 +0200
Message-Id: <20221024113025.979475295@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 5d2569cb4a65c373896ec0217febdf88739ed295 upstream.

Software that has run before the USB4 CM in Linux runs may have disabled
hotplug events for a given lane adapter.

Other CMs such as that one distributed with Windows 11 will enable hotplug
events. Do the same thing in the Linux CM which fixes hotplug events on
"AMD Pink Sardine".

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c  |   24 ++++++++++++++++++++++++
 drivers/thunderbolt/tb.h      |    1 +
 drivers/thunderbolt/tb_regs.h |    1 +
 drivers/thunderbolt/usb4.c    |   20 ++++++++++++++++++++
 4 files changed, 46 insertions(+)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2413,6 +2413,26 @@ void tb_switch_unconfigure_link(struct t
 		tb_lc_unconfigure_port(down);
 }
 
+static int tb_switch_port_hotplug_enable(struct tb_switch *sw)
+{
+	struct tb_port *port;
+
+	if (tb_switch_is_icm(sw))
+		return 0;
+
+	tb_switch_for_each_port(sw, port) {
+		int res;
+
+		if (!port->cap_usb4)
+			continue;
+
+		res = usb4_port_hotplug_enable(port);
+		if (res)
+			return res;
+	}
+	return 0;
+}
+
 /**
  * tb_switch_add() - Add a switch to the domain
  * @sw: Switch to add
@@ -2480,6 +2500,10 @@ int tb_switch_add(struct tb_switch *sw)
 			return ret;
 	}
 
+	ret = tb_switch_port_hotplug_enable(sw);
+	if (ret)
+		return ret;
+
 	ret = device_add(&sw->dev);
 	if (ret) {
 		dev_err(&sw->dev, "failed to add device: %d\n", ret);
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -979,6 +979,7 @@ struct tb_port *usb4_switch_map_usb3_dow
 					  const struct tb_port *port);
 
 int usb4_port_unlock(struct tb_port *port);
+int usb4_port_hotplug_enable(struct tb_port *port);
 int usb4_port_configure(struct tb_port *port);
 void usb4_port_unconfigure(struct tb_port *port);
 int usb4_port_configure_xdomain(struct tb_port *port);
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -285,6 +285,7 @@ struct tb_regs_port_header {
 #define ADP_CS_5				0x05
 #define ADP_CS_5_LCA_MASK			GENMASK(28, 22)
 #define ADP_CS_5_LCA_SHIFT			22
+#define ADP_CS_5_DHP				BIT(31)
 
 /* TMU adapter registers */
 #define TMU_ADP_CS_3				0x03
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -854,6 +854,26 @@ int usb4_port_unlock(struct tb_port *por
 	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_4, 1);
 }
 
+/**
+ * usb4_port_hotplug_enable() - Enables hotplug for a port
+ * @port: USB4 port to operate on
+ *
+ * Enables hot plug events on a given port. This is only intended
+ * to be used on lane, DP-IN, and DP-OUT adapters.
+ */
+int usb4_port_hotplug_enable(struct tb_port *port)
+{
+	int ret;
+	u32 val;
+
+	ret = tb_port_read(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
+	if (ret)
+		return ret;
+
+	val &= ~ADP_CS_5_DHP;
+	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
+}
+
 static int usb4_port_set_configured(struct tb_port *port, bool configured)
 {
 	int ret;


