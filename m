Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A390257D44
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgHaPa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbgHaPa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A78E20FC3;
        Mon, 31 Aug 2020 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887856;
        bh=6ABlp9+wcVdx81zzzjvzeQsU7AAr4YpLoxK1KXLo8P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6/0r0HxVyKxvwoD7ex3yuXngBIDL3JTwxzGW9ryXLB7EZn8kW2k0osKLGQfbmYEx
         lRJ7fAGGup8g6jDI997pxzirtE8qgnLMAL4G8f9HOLgwefS9IvocP1/OP2wpybU5fO
         eDcUrevpg2+FEmX/9bwWmZ5/qx/enSUEbJ/tTqQs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 10/23] habanalabs: validate FW file size
Date:   Mon, 31 Aug 2020 11:30:26 -0400
Message-Id: <20200831153039.1024302-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153039.1024302-1-sashal@kernel.org>
References: <20200831153039.1024302-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit bce382a8bb080ed5f2f3a06754526dc58b91cca2 ]

We must validate FW size in order not to corrupt memory in case
a malicious FW file will be present in system.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/firmware_if.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/misc/habanalabs/firmware_if.c b/drivers/misc/habanalabs/firmware_if.c
index ea2ca67fbfbfa..153858475abc1 100644
--- a/drivers/misc/habanalabs/firmware_if.c
+++ b/drivers/misc/habanalabs/firmware_if.c
@@ -11,6 +11,7 @@
 #include <linux/genalloc.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 
+#define FW_FILE_MAX_SIZE	0x1400000 /* maximum size of 20MB */
 /**
  * hl_fw_push_fw_to_device() - Push FW code to device.
  * @hdev: pointer to hl_device structure.
@@ -43,6 +44,14 @@ int hl_fw_push_fw_to_device(struct hl_device *hdev, const char *fw_name,
 
 	dev_dbg(hdev->dev, "%s firmware size == %zu\n", fw_name, fw_size);
 
+	if (fw_size > FW_FILE_MAX_SIZE) {
+		dev_err(hdev->dev,
+			"FW file size %zu exceeds maximum of %u bytes\n",
+			fw_size, FW_FILE_MAX_SIZE);
+		rc = -EINVAL;
+		goto out;
+	}
+
 	fw_data = (const u64 *) fw->data;
 
 	memcpy_toio(dst, fw_data, fw_size);
-- 
2.25.1

