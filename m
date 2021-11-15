Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DE5450C1B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238362AbhKORev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:34:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238070AbhKORcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:32:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D36E61BF5;
        Mon, 15 Nov 2021 17:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996876;
        bh=8okjp/3WO4GzMqEARKMcDPJVOqWX313J5qfGYiW80R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJQvBY8V1bw3B3mv/qQb1VrzSfhbSmixQiti7Y3q/GoIej4zyp8c4R7Jbn167PAE4
         DkC/WCsK+7Q3OjOPAcZQ0yuq/nrC7q6opLmKbs+CC+JJTFSOl2t351sdk3I3Hst8eL
         NQqy+j7GobCv/rDCKKxjQIgkLXi7WrT9mgj5mhDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 299/355] mtd: core: dont remove debugfs directory if device is in use
Date:   Mon, 15 Nov 2021 18:03:43 +0100
Message-Id: <20211115165323.391744911@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit c13de2386c78e890d4ae6f01a85eefd0b293fb08 ]

Previously, if del_mtd_device() failed with -EBUSY due to a non-zero
usecount, a subsequent call to attempt the deletion again would try to
remove a debugfs directory that had already been removed and panic.
With this change the second call can instead proceed safely.

Fixes: e8e3edb95ce6 ("mtd: create per-device and module-scope debugfs entries")
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211014203953.5424-1-zev@bewilderbeest.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 32a76b8feaa5d..ac5d3b6db9b84 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -727,8 +727,6 @@ int del_mtd_device(struct mtd_info *mtd)
 
 	mutex_lock(&mtd_table_mutex);
 
-	debugfs_remove_recursive(mtd->dbg.dfs_dir);
-
 	if (idr_find(&mtd_idr, mtd->index) != mtd) {
 		ret = -ENODEV;
 		goto out_error;
@@ -744,6 +742,8 @@ int del_mtd_device(struct mtd_info *mtd)
 		       mtd->index, mtd->name, mtd->usecount);
 		ret = -EBUSY;
 	} else {
+		debugfs_remove_recursive(mtd->dbg.dfs_dir);
+
 		/* Try to remove the NVMEM provider */
 		if (mtd->nvmem)
 			nvmem_unregister(mtd->nvmem);
-- 
2.33.0



