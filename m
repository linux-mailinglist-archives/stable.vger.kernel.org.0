Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EAC29B774
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799788AbgJ0PdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799783AbgJ0PdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E21D220728;
        Tue, 27 Oct 2020 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812800;
        bh=fu3uDtQ4JNhx8SeeO5viHDKh1uc61fwGi5AYR1NFENI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnDDf/fAb1dO9WBAzNrzfShMAXE4QLRyDt1Kt+KxrMxKELdKGsDEDHxc0dGG4wTzH
         F0HBGw5vdoR7GcjZ8amQIzgwJUho/Sd0y1yc7PfNp5uMG7CeldsWvSnPGWYjaHc//G
         lycycPwFkD4l0cdwO3CgOU3v3TNxNsjMJ8SkV0pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 334/757] nvmem: core: fix possibly memleak when use nvmem_cell_info_to_nvmem_cell()
Date:   Tue, 27 Oct 2020 14:49:44 +0100
Message-Id: <20201027135506.225319473@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 204a515d8bc5d..29a51cd795609 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -361,16 +361,14 @@ static void nvmem_cell_add(struct nvmem_cell *cell)
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
@@ -382,13 +380,30 @@ static int nvmem_cell_info_to_nvmem_cell(struct nvmem_device *nvmem,
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
@@ -1463,7 +1478,7 @@ ssize_t nvmem_device_cell_read(struct nvmem_device *nvmem,
 	if (!nvmem)
 		return -EINVAL;
 
-	rc = nvmem_cell_info_to_nvmem_cell(nvmem, info, &cell);
+	rc = nvmem_cell_info_to_nvmem_cell_nodup(nvmem, info, &cell);
 	if (rc)
 		return rc;
 
@@ -1493,7 +1508,7 @@ int nvmem_device_cell_write(struct nvmem_device *nvmem,
 	if (!nvmem)
 		return -EINVAL;
 
-	rc = nvmem_cell_info_to_nvmem_cell(nvmem, info, &cell);
+	rc = nvmem_cell_info_to_nvmem_cell_nodup(nvmem, info, &cell);
 	if (rc)
 		return rc;
 
-- 
2.25.1



