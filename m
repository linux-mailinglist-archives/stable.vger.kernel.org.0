Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44B0490E5C
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243114AbiAQRIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242115AbiAQRGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:06:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18C4C0612A3;
        Mon, 17 Jan 2022 09:04:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3954611D9;
        Mon, 17 Jan 2022 17:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691D4C36AE3;
        Mon, 17 Jan 2022 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439044;
        bh=6SWFNtQAhiPbgkd6kdbFRMEtXk7VCljfVemFjaj60sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5/JgWdrEnttYoOhNfRcX6Px2ktU99W/GT5di+aDZPmMi/6rI0S3BLoVcRvnpwkEN
         u7JNfwh0WetVXGqC6stY5j4VAbH4Mgo2QpuVaxdtwX+vE3DoIwZ5s3o/i4LhMvaB0q
         xHbzDL/h32nqbV6C1I/p5r0r/p0pqxvLzISjAq+zrAst6Lw98aQyOLllShOHVfl68Q
         6rKHpjFodov6DakDn8iKbrOnyg+7iwXhM/JznYXa077L50g6E6LTKSdzAvwjSSxe0/
         qpqZHpDmLRWxD8IN1Ki6MxIgyPkRWZqCofAREZIDBvxAvx9Ul+LgYpL0GFbZnXnh8G
         vaep6vMXbj3iA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 17/34] dm: fix alloc_dax error handling in alloc_dev
Date:   Mon, 17 Jan 2022 12:03:07 -0500
Message-Id: <20220117170326.1471712-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d751939235b9b7bc4af15f90a3e99288a8b844a7 ]

Make sure ->dax_dev is NULL on error so that the cleanup path doesn't
trip over an ERR_PTR.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211129102203.2243509-2-hch@lst.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 19a70f434029b..6030cba5b0382 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1894,8 +1894,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
-		if (IS_ERR(md->dax_dev))
+		if (IS_ERR(md->dax_dev)) {
+			md->dax_dev = NULL;
 			goto bad;
+		}
 	}
 
 	add_disk_no_queue_reg(md->disk);
-- 
2.34.1

