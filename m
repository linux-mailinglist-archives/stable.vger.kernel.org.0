Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8949E036
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731295AbfH0IB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730582AbfH0IB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:01:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D5FC217F5;
        Tue, 27 Aug 2019 08:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892885;
        bh=Vtm0LSf/FYsGIcGYLuGcLmm0g16FWGHaQU+a0WvHkNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwnFosII306HpvWi2ClvicToSB0jm75kIFKqvMl7iXjRT0l7+M9/KVaMDx/Nx6tup
         4j79KLDRwFJWEoPReF6v5D/uiECcmVgzRCpbX5hGlXNm2t/SRMeYmKxws+SrfBzadU
         9TmiJaxuuPjrWrQ9jaSDs1VYINAChR+L+ghAR/GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Segal <bpsegal20@gmail.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 047/162] habanalabs: fix F/W download in BE architecture
Date:   Tue, 27 Aug 2019 09:49:35 +0200
Message-Id: <20190827072739.870046566@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 75035fe22b808a520e1d712ebe913684ba406e01 ]

writeX macros might perform byte-swapping in BE architectures. As our F/W
is in LE format, we need to make sure no byte-swapping will occur.

There is a standard kernel function (called memcpy_toio) for copying data
to I/O area which is used in a lot of drivers to download F/W to PCIe
adapters. That function also makes sure the data is copied "as-is",
without byte-swapping.

This patch use that function to copy the F/W to the GOYA ASIC instead of
writeX macros.

Signed-off-by: Ben Segal <bpsegal20@gmail.com>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/firmware_if.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/misc/habanalabs/firmware_if.c b/drivers/misc/habanalabs/firmware_if.c
index eda5d7fcb79f2..fe9e57a81b6fd 100644
--- a/drivers/misc/habanalabs/firmware_if.c
+++ b/drivers/misc/habanalabs/firmware_if.c
@@ -24,7 +24,7 @@ int hl_fw_push_fw_to_device(struct hl_device *hdev, const char *fw_name,
 {
 	const struct firmware *fw;
 	const u64 *fw_data;
-	size_t fw_size, i;
+	size_t fw_size;
 	int rc;
 
 	rc = request_firmware(&fw, fw_name, hdev->dev);
@@ -45,22 +45,7 @@ int hl_fw_push_fw_to_device(struct hl_device *hdev, const char *fw_name,
 
 	fw_data = (const u64 *) fw->data;
 
-	if ((fw->size % 8) != 0)
-		fw_size -= 8;
-
-	for (i = 0 ; i < fw_size ; i += 8, fw_data++, dst += 8) {
-		if (!(i & (0x80000 - 1))) {
-			dev_dbg(hdev->dev,
-				"copied so far %zu out of %zu for %s firmware",
-				i, fw_size, fw_name);
-			usleep_range(20, 100);
-		}
-
-		writeq(*fw_data, dst);
-	}
-
-	if ((fw->size % 8) != 0)
-		writel(*(const u32 *) fw_data, dst);
+	memcpy_toio(dst, fw_data, fw_size);
 
 out:
 	release_firmware(fw);
-- 
2.20.1



