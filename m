Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B496CC52B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjC1PMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjC1PMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAA810253
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D348B81D96
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D6BC433EF;
        Tue, 28 Mar 2023 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016136;
        bh=Lfej/e+R/XfH5jbjc2UVAuZ5x+IgxBUNvehXgPGZ1Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/VRfCcXmtCPcR0U3QpLoGw2k4f5VMRjDVtNq4V4cbqSpZwj9kiUC0kXc7KQ33H43
         dd59tYOcNWDF2/N/2Ps7uJU0S4F0ZpS/pY0udVUH3XEEUrAduUvI2uhSg3HHyd9UE3
         9+/DgRIoneK+K9CAxBk5NXUEvE+l+kMPQkN5mwkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20Schaubschl=C3=A4ger?= 
        <christian.schaubschlaeger@gmx.at>,
        Gil Fine <gil.fine@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 079/146] thunderbolt: Add missing UNSET_INBOUND_SBTX for retimer access
Date:   Tue, 28 Mar 2023 16:42:48 +0200
Message-Id: <20230328142606.003226503@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gil Fine <gil.fine@linux.intel.com>

commit cd0c1e582b055dea615001b8bd8eccaf6f69f7ce upstream.

According to USB4 retimer specification, the process of firmware update
sequence requires issuing a SET_INBOUND_SBTX port operation that later
shall be followed by UNSET_INBOUND_SBTX port operation. This last step
is not currently issued by the driver but it is necessary to make sure
the retimers are put back to passthrough mode even during enumeration.

If this step is missing the link may not come up properly after
soft-reboot for example.

For this reason issue UNSET_INBOUND_SBTX after SET_INBOUND_SBTX for
enumeration and also when the NVM upgrade is run.

Reported-by: Christian Schaubschläger <christian.schaubschlaeger@gmx.at>
Link: https://lore.kernel.org/linux-usb/b556f5ed-5ee8-9990-9910-afd60db93310@gmx.at/
Cc: stable@vger.kernel.org
Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/retimer.c |   23 +++++++++++++++++++++--
 drivers/thunderbolt/sb_regs.h |    1 +
 drivers/thunderbolt/tb.h      |    1 +
 drivers/thunderbolt/usb4.c    |   14 ++++++++++++++
 4 files changed, 37 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -208,6 +208,22 @@ static ssize_t nvm_authenticate_show(str
 	return ret;
 }
 
+static void tb_retimer_set_inbound_sbtx(struct tb_port *port)
+{
+	int i;
+
+	for (i = 1; i <= TB_MAX_RETIMER_INDEX; i++)
+		usb4_port_retimer_set_inbound_sbtx(port, i);
+}
+
+static void tb_retimer_unset_inbound_sbtx(struct tb_port *port)
+{
+	int i;
+
+	for (i = TB_MAX_RETIMER_INDEX; i >= 1; i--)
+		usb4_port_retimer_unset_inbound_sbtx(port, i);
+}
+
 static ssize_t nvm_authenticate_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -234,6 +250,7 @@ static ssize_t nvm_authenticate_store(st
 	rt->auth_status = 0;
 
 	if (val) {
+		tb_retimer_set_inbound_sbtx(rt->port);
 		if (val == AUTHENTICATE_ONLY) {
 			ret = tb_retimer_nvm_authenticate(rt, true);
 		} else {
@@ -253,6 +270,7 @@ static ssize_t nvm_authenticate_store(st
 	}
 
 exit_unlock:
+	tb_retimer_unset_inbound_sbtx(rt->port);
 	mutex_unlock(&rt->tb->lock);
 exit_rpm:
 	pm_runtime_mark_last_busy(&rt->dev);
@@ -466,8 +484,7 @@ int tb_retimer_scan(struct tb_port *port
 	 * Enable sideband channel for each retimer. We can do this
 	 * regardless whether there is device connected or not.
 	 */
-	for (i = 1; i <= TB_MAX_RETIMER_INDEX; i++)
-		usb4_port_retimer_set_inbound_sbtx(port, i);
+	tb_retimer_set_inbound_sbtx(port);
 
 	/*
 	 * Before doing anything else, read the authentication status.
@@ -490,6 +507,8 @@ int tb_retimer_scan(struct tb_port *port
 			break;
 	}
 
+	tb_retimer_unset_inbound_sbtx(port);
+
 	if (!last_idx)
 		return 0;
 
--- a/drivers/thunderbolt/sb_regs.h
+++ b/drivers/thunderbolt/sb_regs.h
@@ -20,6 +20,7 @@ enum usb4_sb_opcode {
 	USB4_SB_OPCODE_ROUTER_OFFLINE = 0x4e45534c,		/* "LSEN" */
 	USB4_SB_OPCODE_ENUMERATE_RETIMERS = 0x4d554e45,		/* "ENUM" */
 	USB4_SB_OPCODE_SET_INBOUND_SBTX = 0x5055534c,		/* "LSUP" */
+	USB4_SB_OPCODE_UNSET_INBOUND_SBTX = 0x50555355,		/* "USUP" */
 	USB4_SB_OPCODE_QUERY_LAST_RETIMER = 0x5453414c,		/* "LAST" */
 	USB4_SB_OPCODE_GET_NVM_SECTOR_SIZE = 0x53534e47,	/* "GNSS" */
 	USB4_SB_OPCODE_NVM_SET_OFFSET = 0x53504f42,		/* "BOPS" */
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1080,6 +1080,7 @@ int usb4_port_router_online(struct tb_po
 int usb4_port_enumerate_retimers(struct tb_port *port);
 
 int usb4_port_retimer_set_inbound_sbtx(struct tb_port *port, u8 index);
+int usb4_port_retimer_unset_inbound_sbtx(struct tb_port *port, u8 index);
 int usb4_port_retimer_read(struct tb_port *port, u8 index, u8 reg, void *buf,
 			   u8 size);
 int usb4_port_retimer_write(struct tb_port *port, u8 index, u8 reg,
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1442,6 +1442,20 @@ int usb4_port_retimer_set_inbound_sbtx(s
 }
 
 /**
+ * usb4_port_retimer_unset_inbound_sbtx() - Disable sideband channel transactions
+ * @port: USB4 port
+ * @index: Retimer index
+ *
+ * Disables sideband channel transations on SBTX. The reverse of
+ * usb4_port_retimer_set_inbound_sbtx().
+ */
+int usb4_port_retimer_unset_inbound_sbtx(struct tb_port *port, u8 index)
+{
+	return usb4_port_retimer_op(port, index,
+				    USB4_SB_OPCODE_UNSET_INBOUND_SBTX, 500);
+}
+
+/**
  * usb4_port_retimer_read() - Read from retimer sideband registers
  * @port: USB4 port
  * @index: Retimer index


