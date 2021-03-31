Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CE434F8BC
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 08:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhCaG16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 02:27:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15409 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbhCaG1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 02:27:35 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F9GXY3y3XzlWkW;
        Wed, 31 Mar 2021 14:25:49 +0800 (CST)
Received: from DESKTOP-JU2N2LB.china.huawei.com (10.67.102.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 14:27:23 +0800
From:   wangfangpeng <wangfangpeng1@huawei.com>
To:     <richard@nod.at>, <ext-adrian.hunter@nokia.com>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nixiaoming@huawei.com>, <zengweilin@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ubifs: fix read fail but return ok
Date:   Wed, 31 Mar 2021 14:27:23 +0800
Message-ID: <20210331062723.2090-1-wangfangpeng1@huawei.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.102.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

do_readpage() may return err, but ubifs_readpage() always return ok.
The vfs will ignore the err happen in ubifs.

Fixes: 1e51764a3c2ac05a2 ("UBIFS: add new flash file system")
Cc: <stable@vger.kernel.org> #v2.6.27
Signed-off-by: wangfangpeng <wangfangpeng1@huawei.com>
---
 fs/ubifs/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 0e4b4be3aa26..001feec1d415 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -892,11 +892,13 @@ static int ubifs_bulk_read(struct page *page)
 
 static int ubifs_readpage(struct file *file, struct page *page)
 {
+	int ret;
+
 	if (ubifs_bulk_read(page))
 		return 0;
-	do_readpage(page);
+	ret = do_readpage(page);
 	unlock_page(page);
-	return 0;
+	return ret;
 }
 
 static int do_writepage(struct page *page, int len)
-- 
2.12.3

