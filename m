Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1106827C9AC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbgI2MMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730137AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5342F23B99;
        Tue, 29 Sep 2020 11:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379291;
        bh=45ox9onnmbXiXm6UdydB2JxE3ku3xC/QAXT2+dTKYKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmhtZp1vdLbXwE8CAA0VdvcQoyl++Z7/pm26vIWLQ2aALDW8miY7XTYwT9evRUHT8
         kFE+VQ/ilPyvtUZHkCP176RgpJngIz+I+hyWjtXbhh/oOhLxDJOX6+C9eMnrLh1ID7
         FHSt9ZDVP7ggu4D6VhB/p+LvxI3M75PvNHvqZMKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/388] Bluetooth: btrtl: Use kvmalloc for FW allocations
Date:   Tue, 29 Sep 2020 12:57:09 +0200
Message-Id: <20200929110015.219775296@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



