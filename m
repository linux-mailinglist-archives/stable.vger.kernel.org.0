Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8566D29B4B9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762663AbgJ0PAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1788582AbgJ0PA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EFDE20714;
        Tue, 27 Oct 2020 15:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810829;
        bh=X29lZydw6kWSNcMmU6M4f+oKfY11QqVF0S/Svtg6fok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwg+Myc8SwoNJE2Bnbaisygf1RFd3xZvQgsGYRrlmuCO/EEROqDlcEWf+1LhCgA5b
         GoVE878UsxsUjZgepnt1Flz4bCoWN05h1Hy9CuZWJZUZ2qTI9Oh+AlXB6PhOERkYvi
         A15XIOzR1NUyZjZIq38FBoI9eUohpEuF0DZHfXbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 276/633] nvmem: core: fix possibly memleak when use nvmem_cell_info_to_nvmem_cell()
Date:   Tue, 27 Oct 2020 14:50:19 +0100
Message-Id: <20201027135535.616771401@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>

[ Upstream commit fc9eec4d643597cf4cb2fef17d48110e677610da ]

Fix missing 'kfree_const(cell->name)' when call to
nvmem_cell_info_to_nvmem_cell() in several places:

     * after nvmem_cell_info_to_nvmem_cell() failed during
       nvmem_add_cells()

     * during nvmem_device_cell_{read,write} when cell->name is
       kstrdup'ed() without calling kfree_const() at the end, but
       really there is no reason to do that 'dup, because the cell
       instance is allocated on the stack for some short period to be
       read/write without exposing it to the caller.

So the new nvmem_cell_info_to_nvmem_cell_nodup() helper is introduced
which is used to convert cell_info -> cell without name duplication as
a lighweight version of nvmem_cell_info_to_nvmem_cell().

Fixes: e2a5402ec7c6 ("nvmem: Add nvmem_device based consumer apis.")
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Link: https://lore.kernel.org/r/20200923204456.14032-1-vadym.kochan@plvision.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 394e75dede725..4aca5b4a87d75 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -355,16 +355,14 @@ static void nvmem_cell_add(struct nvmem_cell *cell)
 	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_CELL_ADD, cell);
 }
 
-static int nvmem_cell_info_to_nvmem_cell(struct nvmem_device *nvmem,
-				   const struct nvmem_cell_info *info,
-				   struct nvmem_cell *cell)
+static int nvmem_cell_info_to_nvmem_cell_nodup(struct nvmem_device *nvmem,
+					const struct nvmem_cell_info *info,
+					struct nvmem_cell *cell)
 {
 	cell->nvmem = nvmem;
 	cell->offset = info->offset;
 	cell->bytes = info->bytes;
-	cell->name = kstrdup_const(info->name, GFP_KERNEL);
-	if (!cell->name)
-		return -ENOMEM;
+	cell->name = info->name;
 
 	cell->bit_offset = info->bit_offset;
 	cell->nbits = info->nbits;
@@ -376,13 +374,30 @@ static int nvmem_cell_info_to_nvmem_cell(struct nvmem_device *nvmem,
 	if (!IS_ALIGNED(cell->offset, nvmem->stride)) {
 		dev_err(&nvmem->dev,
 			"cell %s unaligned to nvmem stride %d\n",
-			cell->name, nvmem->stride);
+			cell->name ?: "<unknown>", nvmem->stride);
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
+static int nvmem_cell_info_to_nvmem_cell(struct nvmem_device *nvmem,
+				const struct nvmem_cell_info *info,
+				struct nvmem_cell *cell)
+{
+	int err;
+
+	err = nvmem_cell_info_to_nvmem_cell_nodup(nvmem, info, cell);
+	if (err)
+		return err;
+
+	cell->name = kstrdup_const(info->name, GFP_KERNEL);
+	if (!cell->name)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /**
  * nvmem_add_cells() - Add cell information to an nvmem device
  *
@@ -1436,7 +1451,7 @@ ssize_t nvmem_device_cell_read(struct nvmem_device *nvmem,
 	if (!nvmem)
 		return -EINVAL;
 
-	rc = nvmem_cell_info_to_nvmem_cell(nvmem, info, &cell);
+	rc = nvmem_cell_info_to_nvmem_cell_nodup(nvmem, info, &cell);
 	if (rc)
 		return rc;
 
@@ -1466,7 +1481,7 @@ int nvmem_device_cell_write(struct nvmem_device *nvmem,
 	if (!nvmem)
 		return -EINVAL;
 
-	rc = nvmem_cell_info_to_nvmem_cell(nvmem, info, &cell);
+	rc = nvmem_cell_info_to_nvmem_cell_nodup(nvmem, info, &cell);
 	if (rc)
 		return rc;
 
-- 
2.25.1



