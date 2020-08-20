Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D124B9E5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgHTL4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730486AbgHTKBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:01:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D1822B4D;
        Thu, 20 Aug 2020 10:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917672;
        bh=8gLfGueIubmjq71GiCt1zrB0HTttEmsPLuEs2LZ5dtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWuORETpU/zyP7tMet9qRAMRpdfLPivYV8/+8eRJEJ4tUDlAR4tusfVaP+8ij4HOm
         iHnb3YsGlOdu3IYvGbqQj+W7yKbHLyVcKCDpTbxMHH65CW2HYOn+r14mPKeux6ovL5
         QY3m2bWgE+FEtm/GV7tUmWAUc73n1fJQ9fBCnLRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 116/212] cxl: Fix kobject memleak
Date:   Thu, 20 Aug 2020 11:21:29 +0200
Message-Id: <20200820091608.209297448@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 85c5cbeba8f4fb28e6b9bfb3e467718385f78f76 ]

Currently the error return path from kobject_init_and_add() is not
followed by a call to kobject_put() - which means we are leaking
the kobject.

Fix it by adding a call to kobject_put() in the error path of
kobject_init_and_add().

Fixes: b087e6190ddc ("cxl: Export optional AFU configuration record in sysfs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Link: https://lore.kernel.org/r/20200602120733.5943-1-wanghai38@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/cxl/sysfs.c b/drivers/misc/cxl/sysfs.c
index a8b6d6a635e96..e97b3b26805d1 100644
--- a/drivers/misc/cxl/sysfs.c
+++ b/drivers/misc/cxl/sysfs.c
@@ -598,7 +598,7 @@ static struct afu_config_record *cxl_sysfs_afu_new_cr(struct cxl_afu *afu, int c
 	rc = kobject_init_and_add(&cr->kobj, &afu_config_record_type,
 				  &afu->dev.kobj, "cr%i", cr->cr);
 	if (rc)
-		goto err;
+		goto err1;
 
 	rc = sysfs_create_bin_file(&cr->kobj, &cr->config_attr);
 	if (rc)
-- 
2.25.1



