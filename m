Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130534B48BC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343969AbiBNJ5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:57:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345102AbiBNJ4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:56:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100FB811A3;
        Mon, 14 Feb 2022 01:45:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A4106120C;
        Mon, 14 Feb 2022 09:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F4FC340E9;
        Mon, 14 Feb 2022 09:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831909;
        bh=2Q4J71DeR1ZLeLCSBBdVkEDu4STaEUAYDUFQqNBJD4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffNvjiDRR6Fvr2foUmjzReGLZyrz5JvJwMUIVx2qQ9MwaRGyapITpKBjtHYB6HNyj
         EGAOKeSAoEH2PQ0aH9jz5n/J1vxIR2Od42US+ICLZF1v6NpjyJTeXgNRkCDtdlTHBa
         lERXffTKdo4KhA22V4qbuhUsi8e4bucJvz8rEJ3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Subject: [PATCH 5.15 019/172] thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM responses
Date:   Mon, 14 Feb 2022 10:24:37 +0100
Message-Id: <20220214092507.051805810@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit aeb58c860dc516794fdf7ff89d96ead2644d5889 upstream.

Some of the RFIM mail box command returns 64 bit values. So enhance
mailbox interface to return 64 bit values and use them for RFIM
commands.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal: Export additional attributes")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.h |    2 
 drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c   |   22 +++++-----
 drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c   |   10 ++--
 3 files changed, 19 insertions(+), 15 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
@@ -80,7 +80,7 @@ void proc_thermal_rfim_remove(struct pci
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv);
 void proc_thermal_mbox_remove(struct pci_dev *pdev);
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp);
+int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp);
 int proc_thermal_add(struct device *dev, struct proc_thermal_device *priv);
 void proc_thermal_remove(struct proc_thermal_device *proc_priv);
 int proc_thermal_suspend(struct device *dev);
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
@@ -24,7 +24,7 @@
 
 static DEFINE_MUTEX(mbox_lock);
 
-static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp)
+static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp)
 {
 	struct proc_thermal_device *proc_priv;
 	u32 retries, data;
@@ -69,12 +69,16 @@ static int send_mbox_cmd(struct pci_dev
 			goto unlock_mbox;
 		}
 
-		if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_READ) {
-			data = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
-			*cmd_resp = data & 0xff;
-		}
-
 		ret = 0;
+
+		if (!cmd_resp)
+			break;
+
+		if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_READ)
+			*cmd_resp = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
+		else
+			*cmd_resp = readq((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
+
 		break;
 	} while (--retries);
 
@@ -83,7 +87,7 @@ unlock_mbox:
 	return ret;
 }
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp)
+int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp)
 {
 	return send_mbox_cmd(pdev, cmd_id, cmd_data, cmd_resp);
 }
@@ -154,7 +158,7 @@ static ssize_t workload_type_show(struct
 				   char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
@@ -188,7 +192,7 @@ static bool workload_req_created;
 
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv)
 {
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	/* Check if there is a mailbox support, if fails return success */
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -195,7 +195,7 @@ static ssize_t rfi_restriction_store(str
 				     const char *buf, size_t count)
 {
 	u16 cmd_id = 0x0008;
-	u32 cmd_resp;
+	u64 cmd_resp;
 	u32 input;
 	int ret;
 
@@ -215,14 +215,14 @@ static ssize_t rfi_restriction_show(stru
 				    char *buf)
 {
 	u16 cmd_id = 0x0007;
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, 0, &cmd_resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%u\n", cmd_resp);
+	return sprintf(buf, "%llu\n", cmd_resp);
 }
 
 static ssize_t ddr_data_rate_show(struct device *dev,
@@ -230,14 +230,14 @@ static ssize_t ddr_data_rate_show(struct
 				  char *buf)
 {
 	u16 cmd_id = 0x0107;
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, 0, &cmd_resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%u\n", cmd_resp);
+	return sprintf(buf, "%llu\n", cmd_resp);
 }
 
 static DEVICE_ATTR_RW(rfi_restriction);


