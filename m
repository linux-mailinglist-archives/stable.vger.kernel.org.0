Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0994257DAB
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgHaPje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728526AbgHaPaD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E872A20936;
        Mon, 31 Aug 2020 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887803;
        bh=9R4Lb8/rS3PyMG8TzFaJ1uD6D9wLNRMWS/lo3IlBBOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvxlaz7BAWlaxRhzfvWKfRzZ7HrnaBKADCqKJKAWrHCNy4pHPEo1Sy91mQ4v0MW1F
         NQwi8y3rruVEuzmHsZ8QAxn2DIMFDUcbVUaapDX3rUkd7XgL9KLDA84/DntOYLhdkh
         0mmgbgYqOoBzuKnamG5GoVL26w5kkMOqhDbLn+DU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 19/42] habanalabs: validate FW file size
Date:   Mon, 31 Aug 2020 11:29:11 -0400
Message-Id: <20200831152934.1023912-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
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
index d27841cb5bcb3..345c228a7971e 100644
--- a/drivers/misc/habanalabs/firmware_if.c
+++ b/drivers/misc/habanalabs/firmware_if.c
@@ -13,6 +13,7 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/slab.h>
 
+#define FW_FILE_MAX_SIZE	0x1400000 /* maximum size of 20MB */
 /**
  * hl_fw_load_fw_to_device() - Load F/W code to device's memory.
  * @hdev: pointer to hl_device structure.
@@ -45,6 +46,14 @@ int hl_fw_load_fw_to_device(struct hl_device *hdev, const char *fw_name,
 
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

