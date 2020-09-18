Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661F626F3B6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgIRDIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbgIRCDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F37A2311A;
        Fri, 18 Sep 2020 02:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394595;
        bh=45ox9onnmbXiXm6UdydB2JxE3ku3xC/QAXT2+dTKYKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2WpcrHhs7nDl2+jbxry5raPqKtts0rXtH9m8kysHWqmeQJECbyB7qlVUPh29OkGp
         wFMCqFcWMa7nKDhT62K6tPRXcdxPMXppD0pSQPpPPpf0DKj8VDTNJHKmmXB84MDpxZ
         F+nB82f9gYofvO40S57GMU+F+5YumHd6Xjwib2gw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 103/330] Bluetooth: btrtl: Use kvmalloc for FW allocations
Date:   Thu, 17 Sep 2020 21:57:23 -0400
Message-Id: <20200918020110.2063155-103-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit 268d3636dfb22254324774de1f8875174b3be064 ]

Currently, kmemdup is applied to the firmware data, and it invokes
kmalloc under the hood. The firmware size and patch_length are big (more
than PAGE_SIZE), and on some low-end systems (like ASUS E202SA) kmalloc
may fail to allocate a contiguous chunk under high memory usage and
fragmentation:

Bluetooth: hci0: RTL: examining hci_ver=06 hci_rev=000a lmp_ver=06 lmp_subver=8821
Bluetooth: hci0: RTL: rom_version status=0 version=1
Bluetooth: hci0: RTL: loading rtl_bt/rtl8821a_fw.bin
kworker/u9:2: page allocation failure: order:4, mode:0x40cc0(GFP_KERNEL|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
<stack trace follows>

As firmware load happens on each resume, Bluetooth will stop working
after several iterations, when the kernel fails to allocate an order-4
page.

This patch replaces kmemdup with kvmalloc+memcpy. It's not required to
have a contiguous chunk here, because it's not mapped to the device
directly.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index bf3c02be69305..0dfaf90a31b06 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -370,11 +370,11 @@ static int rtlbt_parse_firmware(struct hci_dev *hdev,
 	 * the end.
 	 */
 	len = patch_length;
-	buf = kmemdup(btrtl_dev->fw_data + patch_offset, patch_length,
-		      GFP_KERNEL);
+	buf = kvmalloc(patch_length, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
+	memcpy(buf, btrtl_dev->fw_data + patch_offset, patch_length - 4);
 	memcpy(buf + patch_length - 4, &epatch_info->fw_version, 4);
 
 	*_buf = buf;
@@ -460,8 +460,10 @@ static int rtl_load_file(struct hci_dev *hdev, const char *name, u8 **buff)
 	if (ret < 0)
 		return ret;
 	ret = fw->size;
-	*buff = kmemdup(fw->data, ret, GFP_KERNEL);
-	if (!*buff)
+	*buff = kvmalloc(fw->size, GFP_KERNEL);
+	if (*buff)
+		memcpy(*buff, fw->data, ret);
+	else
 		ret = -ENOMEM;
 
 	release_firmware(fw);
@@ -499,14 +501,14 @@ static int btrtl_setup_rtl8723b(struct hci_dev *hdev,
 		goto out;
 
 	if (btrtl_dev->cfg_len > 0) {
-		tbuff = kzalloc(ret + btrtl_dev->cfg_len, GFP_KERNEL);
+		tbuff = kvzalloc(ret + btrtl_dev->cfg_len, GFP_KERNEL);
 		if (!tbuff) {
 			ret = -ENOMEM;
 			goto out;
 		}
 
 		memcpy(tbuff, fw_data, ret);
-		kfree(fw_data);
+		kvfree(fw_data);
 
 		memcpy(tbuff + ret, btrtl_dev->cfg_data, btrtl_dev->cfg_len);
 		ret += btrtl_dev->cfg_len;
@@ -519,14 +521,14 @@ static int btrtl_setup_rtl8723b(struct hci_dev *hdev,
 	ret = rtl_download_firmware(hdev, fw_data, ret);
 
 out:
-	kfree(fw_data);
+	kvfree(fw_data);
 	return ret;
 }
 
 void btrtl_free(struct btrtl_device_info *btrtl_dev)
 {
-	kfree(btrtl_dev->fw_data);
-	kfree(btrtl_dev->cfg_data);
+	kvfree(btrtl_dev->fw_data);
+	kvfree(btrtl_dev->cfg_data);
 	kfree(btrtl_dev);
 }
 EXPORT_SYMBOL_GPL(btrtl_free);
-- 
2.25.1

