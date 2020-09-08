Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0588E261D61
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbgIHTfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730966AbgIHP5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:57:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205E623BDF;
        Tue,  8 Sep 2020 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579360;
        bh=9R4Lb8/rS3PyMG8TzFaJ1uD6D9wLNRMWS/lo3IlBBOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpNha34I89FLUauhi0Iqh8j415bLp9YuP2+oCLPwjQlqcT10uMmouqfxdLWYBIbYn
         yOo6KCzqZmFns8KlCcyLU6vDmrlYP5sbR7BqplXpOpIQcRLgtblATgSdl2Ikh9ATvG
         90eoAspeQ0SAfP0Jk9mmURA0Ofp20tMxWHEqshBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 016/186] habanalabs: validate FW file size
Date:   Tue,  8 Sep 2020 17:22:38 +0200
Message-Id: <20200908152242.450358041@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



