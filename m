Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFB7452605
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358648AbhKPCBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240325AbhKOSHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F22C163299;
        Mon, 15 Nov 2021 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998357;
        bh=k30sNTIFzq2ZzH2ZOoyUbQcRWsIJPXzBxrGXzDCSVxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUTJLddNeZa0O8jUSdmkHdDcDPeGK1BOzTnTI9t647YgWjUt1IoZbXSy1VObTiBo/
         4a9wOerxqe6CTq/sa1mtpyeweK1n5h1sen6grWFXCIpdlm1LhxXcGggeoze9WJUP4q
         7qOTLfS8ke+/w6Apa2LGn7IT2a9UmznvQ5EZ67qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 481/575] mtd: core: dont remove debugfs directory if device is in use
Date:   Mon, 15 Nov 2021 18:03:26 +0100
Message-Id: <20211115165400.346524260@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 1c8c407286783..a5197a4819025 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -721,8 +721,6 @@ int del_mtd_device(struct mtd_info *mtd)
 
 	mutex_lock(&mtd_table_mutex);
 
-	debugfs_remove_recursive(mtd->dbg.dfs_dir);
-
 	if (idr_find(&mtd_idr, mtd->index) != mtd) {
 		ret = -ENODEV;
 		goto out_error;
@@ -738,6 +736,8 @@ int del_mtd_device(struct mtd_info *mtd)
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



