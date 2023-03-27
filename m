Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7CA6CAB1F
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 18:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjC0Qzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 12:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjC0Qzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 12:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ED310D1
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 09:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD1E4B817B0
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 16:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201ECC433EF;
        Mon, 27 Mar 2023 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679936148;
        bh=EZAfUn7UjTfl7lvB6gcXne6wFyhP3Q029ke5wcl5LkI=;
        h=Subject:To:Cc:From:Date:From;
        b=lR9b9AstDxXu4MpV+5KYNgnTMzWo8UuZ+Y+Ej+g4MeYl5/p3hm4uWhA/kuk/8t28b
         4+qUM4S1tMb8uOraZBVVN4EsHYVxa/ofoPG4SnI8edx/uy9kbWTAo46zLJfQxsBK4F
         p6g9V5FVLm9KLtVxOsdUKhnB+dB8ZYw96CL1/cpU=
Subject: FAILED: patch "[PATCH] thunderbolt: Limit USB3 bandwidth of certain Intel USB4 host" failed to apply to 5.15-stable tree
To:     gil.fine@linux.intel.com, mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Mar 2023 18:55:37 +0200
Message-ID: <167993613759241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x f0a57dd33b3eadf540912cd130db727ea824d174
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167993613759241@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

f0a57dd33b3e ("thunderbolt: Limit USB3 bandwidth of certain Intel USB4 host routers")
7af9da8ce8f9 ("thunderbolt: Add quirk to disable CLx")
6ce3563520be ("thunderbolt: Add support for DisplayPort bandwidth allocation mode")
aef9c693e7e5 ("thunderbolt: Move vendor specific NVM handling into nvm.c")
8b02b2da77c8 ("thunderbolt: Provide tb_retimer_nvm_read() analogous to tb_switch_nvm_read()")
7bfafaa5185b ("thunderbolt: Rename and make nvm_read() available for other files")
5424e1bf16f9 ("thunderbolt: Extend NVM version fields to 32-bits")
7f333ace0257 ("thunderbolt: Move tb_xdomain_parent() to tb.h")
3084b48fa139 ("thunderbolt: Change TMU mode to HiFi uni-directional once DisplayPort tunneled")
43f977bc60b1 ("thunderbolt: Enable CL0s for Intel Titan Ridge")
23ccd21ccb56 ("thunderbolt: Implement TMU time disruption for Intel Titan Ridge")
8a90e4fa3b4d ("thunderbolt: Add CL0s support for USB4 routers")
a28ec0e165ba ("thunderbolt: Add TMU uni-directional mode")
43bddb26e20a ("thunderbolt: Tear down existing tunnels when resuming from hibernate")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0a57dd33b3eadf540912cd130db727ea824d174 Mon Sep 17 00:00:00 2001
From: Gil Fine <gil.fine@linux.intel.com>
Date: Tue, 31 Jan 2023 13:04:52 +0200
Subject: [PATCH] thunderbolt: Limit USB3 bandwidth of certain Intel USB4 host
 routers

Current Intel USB4 host routers have hardware limitation that the USB3
bandwidth cannot go higher than 16376 Mb/s. Work this around by adding a
new quirk that limits the bandwidth for the affected host routers.

Cc: stable@vger.kernel.org
Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index ae28a03fa890..1157b8869bcc 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -26,6 +26,19 @@ static void quirk_clx_disable(struct tb_switch *sw)
 	tb_sw_dbg(sw, "disabling CL states\n");
 }
 
+static void quirk_usb3_maximum_bandwidth(struct tb_switch *sw)
+{
+	struct tb_port *port;
+
+	tb_switch_for_each_port(sw, port) {
+		if (!tb_port_is_usb3_down(port))
+			continue;
+		port->max_bw = 16376;
+		tb_port_dbg(port, "USB3 maximum bandwidth limited to %u Mb/s\n",
+			    port->max_bw);
+	}
+}
+
 struct tb_quirk {
 	u16 hw_vendor_id;
 	u16 hw_device_id;
@@ -43,6 +56,24 @@ static const struct tb_quirk tb_quirks[] = {
 	 * DP buffers.
 	 */
 	{ 0x8087, 0x0b26, 0x0000, 0x0000, quirk_dp_credit_allocation },
+	/*
+	 * Limit the maximum USB3 bandwidth for the following Intel USB4
+	 * host routers due to a hardware issue.
+	 */
+	{ 0x8087, PCI_DEVICE_ID_INTEL_ADL_NHI0, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_ADL_NHI1, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_RPL_NHI0, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_RPL_NHI1, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_MTL_M_NHI0, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_MTL_P_NHI0, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_MTL_P_NHI1, 0x0000, 0x0000,
+		  quirk_usb3_maximum_bandwidth },
 	/*
 	 * CLx is not supported on AMD USB4 Yellow Carp and Pink Sardine platforms.
 	 */
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index b3cd13dc783b..275ff5219a3a 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -272,6 +272,8 @@ struct tb_bandwidth_group {
  * @group: Bandwidth allocation group the adapter is assigned to. Only
  *	   used for DP IN adapters for now.
  * @group_list: The adapter is linked to the group's list of ports through this
+ * @max_bw: Maximum possible bandwidth through this adapter if set to
+ *	    non-zero.
  *
  * In USB4 terminology this structure represents an adapter (protocol or
  * lane adapter).
@@ -299,6 +301,7 @@ struct tb_port {
 	unsigned int dma_credits;
 	struct tb_bandwidth_group *group;
 	struct list_head group_list;
+	unsigned int max_bw;
 };
 
 /**
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 95ff02395822..6e87cf993c68 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1882,6 +1882,15 @@ int usb4_port_retimer_nvm_read(struct tb_port *port, u8 index,
 				usb4_port_retimer_nvm_read_block, &info);
 }
 
+static inline unsigned int
+usb4_usb3_port_max_bandwidth(const struct tb_port *port, unsigned int bw)
+{
+	/* Take the possible bandwidth limitation into account */
+	if (port->max_bw)
+		return min(bw, port->max_bw);
+	return bw;
+}
+
 /**
  * usb4_usb3_port_max_link_rate() - Maximum support USB3 link rate
  * @port: USB3 adapter port
@@ -1903,7 +1912,9 @@ int usb4_usb3_port_max_link_rate(struct tb_port *port)
 		return ret;
 
 	lr = (val & ADP_USB3_CS_4_MSLR_MASK) >> ADP_USB3_CS_4_MSLR_SHIFT;
-	return lr == ADP_USB3_CS_4_MSLR_20G ? 20000 : 10000;
+	ret = lr == ADP_USB3_CS_4_MSLR_20G ? 20000 : 10000;
+
+	return usb4_usb3_port_max_bandwidth(port, ret);
 }
 
 /**
@@ -1930,7 +1941,9 @@ int usb4_usb3_port_actual_link_rate(struct tb_port *port)
 		return 0;
 
 	lr = val & ADP_USB3_CS_4_ALR_MASK;
-	return lr == ADP_USB3_CS_4_ALR_20G ? 20000 : 10000;
+	ret = lr == ADP_USB3_CS_4_ALR_20G ? 20000 : 10000;
+
+	return usb4_usb3_port_max_bandwidth(port, ret);
 }
 
 static int usb4_usb3_port_cm_request(struct tb_port *port, bool request)

