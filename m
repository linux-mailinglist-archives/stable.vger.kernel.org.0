Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740D2261448
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbgIHQMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbgIHQLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7C57247A7;
        Tue,  8 Sep 2020 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579741;
        bh=6ABlp9+wcVdx81zzzjvzeQsU7AAr4YpLoxK1KXLo8P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0XGVNHcUW357EaTdA/mPJCMPWZGRpkwoPvI7m5K00iNk86u/FzFzDRGkV2w1CaT6
         rkTBoPVsxd5nKC0tpv3NaM4662PX6b92dwQ/CWEWg+gZhgtBNarjoT09lGXbabu8fj
         KkVJZetZxccFmOyz4MmJIfOdctFuOl3HElaxgiRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/129] habanalabs: validate FW file size
Date:   Tue,  8 Sep 2020 17:24:09 +0200
Message-Id: <20200908152230.106783696@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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



