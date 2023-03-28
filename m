Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C196CC2FC
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbjC1Ou0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbjC1OuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:50:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5547E192
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:49:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4DE961804
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0562CC433D2;
        Tue, 28 Mar 2023 14:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014974;
        bh=NjmRWM0xEXG/zUQcEE7zhOg6Fqc4ekjsfjN1lv+duH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3nNujwbSGy3EmG4u7PrUVWBj65bpYHYQABD1ohoKaGAGQ3dB+XHn6KrS3/NAzYA7
         WtuJrIzIORHGmvrECKuX1zBSdh9/Q1uAiQntcmlLAzq/7oUTXAsXkMo1irNHYITjEO
         dCP5UUOcElWaLKbHUJ79xlCf46PL9t0bJhvj9zYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sanjay R Mehta <sanju.mehta@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.2 120/240] thunderbolt: Add quirk to disable CLx
Date:   Tue, 28 Mar 2023 16:41:23 +0200
Message-Id: <20230328142624.787603286@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

From: Sanjay R Mehta <sanju.mehta@amd.com>

commit 7af9da8ce8f9a16221ecd8ba4280582f5bd452fc upstream.

Add QUIRK_NO_CLX to disable the CLx state for hardware which
doesn't supports it.

AMD Yellow Carp and Pink Sardine don't support CLx state,
hence disabling it using QUIRK_NO_CLX.

Cc: stable@vger.kernel.org
Signed-off-by: Sanjay R Mehta <sanju.mehta@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
[mw: added debug log when the quirk is run]
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/quirks.c |   13 +++++++++++++
 drivers/thunderbolt/tb.h     |   11 ++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -20,6 +20,12 @@ static void quirk_dp_credit_allocation(s
 	}
 }
 
+static void quirk_clx_disable(struct tb_switch *sw)
+{
+	sw->quirks |= QUIRK_NO_CLX;
+	tb_sw_dbg(sw, "disabling CL states\n");
+}
+
 struct tb_quirk {
 	u16 hw_vendor_id;
 	u16 hw_device_id;
@@ -37,6 +43,13 @@ static const struct tb_quirk tb_quirks[]
 	 * DP buffers.
 	 */
 	{ 0x8087, 0x0b26, 0x0000, 0x0000, quirk_dp_credit_allocation },
+	/*
+	 * CLx is not supported on AMD USB4 Yellow Carp and Pink Sardine platforms.
+	 */
+	{ 0x0438, 0x0208, 0x0000, 0x0000, quirk_clx_disable },
+	{ 0x0438, 0x0209, 0x0000, 0x0000, quirk_clx_disable },
+	{ 0x0438, 0x020a, 0x0000, 0x0000, quirk_clx_disable },
+	{ 0x0438, 0x020b, 0x0000, 0x0000, quirk_clx_disable },
 };
 
 /**
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -23,6 +23,11 @@
 #define NVM_MAX_SIZE		SZ_512K
 #define NVM_DATA_DWORDS		16
 
+/* Keep link controller awake during update */
+#define QUIRK_FORCE_POWER_LINK_CONTROLLER		BIT(0)
+/* Disable CLx if not supported */
+#define QUIRK_NO_CLX					BIT(1)
+
 /**
  * struct tb_nvm - Structure holding NVM information
  * @dev: Owner of the NVM
@@ -997,6 +1002,9 @@ static inline bool tb_switch_is_clx_enab
  */
 static inline bool tb_switch_is_clx_supported(const struct tb_switch *sw)
 {
+	if (sw->quirks & QUIRK_NO_CLX)
+		return false;
+
 	return tb_switch_is_usb4(sw) || tb_switch_is_titan_ridge(sw);
 }
 
@@ -1254,9 +1262,6 @@ struct usb4_port *usb4_port_device_add(s
 void usb4_port_device_remove(struct usb4_port *usb4);
 int usb4_port_device_resume(struct usb4_port *usb4);
 
-/* Keep link controller awake during update */
-#define QUIRK_FORCE_POWER_LINK_CONTROLLER		BIT(0)
-
 void tb_check_quirks(struct tb_switch *sw);
 
 #ifdef CONFIG_ACPI


