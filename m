Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7716817F3C3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 10:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgCJJdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 05:33:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11613 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbgCJJdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 05:33:45 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5A3BEFA4A233D78BADD5;
        Tue, 10 Mar 2020 17:33:40 +0800 (CST)
Received: from fedora-aep.huawei.cmm (10.175.113.49) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 10 Mar 2020 17:33:36 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <sashal@kernel.org>, <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>
Subject: [PATCH 4.4.y/4.9.y] NFS: fix highmem leak exist in nfs_readdir_xdr_to_array
Date:   Tue, 10 Mar 2020 18:02:19 +0800
Message-ID: <20200310100219.5421-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.49]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch 'e22dea67d2f7 ("NFS: Fix memory leaks and corruption in
readdir")' in 4.4.y/4.9.y will introduce a highmem leak.
Actually, nfs_readdir_get_array has did what we want to do. No need to
call kmap again.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/nfs/dir.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index c2665d920cf8..2517fcd423b6 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -678,8 +678,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 		goto out_label_free;
 	}
 
-	array = kmap(page);
-
 	status = nfs_readdir_alloc_pages(pages, array_size);
 	if (status < 0)
 		goto out_release_array;
-- 
2.17.2

