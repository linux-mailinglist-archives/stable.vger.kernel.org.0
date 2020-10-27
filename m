Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112FD29C474
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823027AbgJ0R4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901193AbgJ0OVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:21:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0072B2072D;
        Tue, 27 Oct 2020 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808469;
        bh=9HK6sxL6xOugQSJcjuw6i0Bo87xjsGOD4ApX+QPW4yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wEBHd0xqw35+4EuhjwM9h6CVl7nDIJ/EhaHM++6m7SqvjcJqzNpG4z3oMSv/kunL
         s0KVLITNdUTcBMeKOGuodmZ53TfUmbzbF9qNd/6oiFnkXpT43LendHVCqRjRMJXavt
         X8NIsONEB8/bex1b6QJwqGCILnps1MdguS6JtiLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/264] misc: mic: scif: Fix error handling path
Date:   Tue, 27 Oct 2020 14:52:41 +0100
Message-Id: <20201027135435.529968154@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

[ Upstream commit a81072a9c0ae734b7889929b0bc070fe3f353f0e ]

Inside __scif_pin_pages(), when map_flags != SCIF_MAP_KERNEL it
will call pin_user_pages_fast() to map nr_pages. However,
pin_user_pages_fast() might fail with a return value -ERRNO.

The return value is stored in pinned_pages->nr_pages. which in
turn is passed to unpin_user_pages(), which expects
pinned_pages->nr_pages >=0, else disaster.

Fix this by assigning pinned_pages->nr_pages to 0 if
pin_user_pages_fast() returns -ERRNO.

Fixes: ba612aa8b487 ("misc: mic: SCIF memory registration and unregistration")
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Link: https://lore.kernel.org/r/1600570295-29546-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mic/scif/scif_rma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mic/scif/scif_rma.c b/drivers/misc/mic/scif/scif_rma.c
index 0e4193cb08cf1..e1f59b17715d5 100644
--- a/drivers/misc/mic/scif/scif_rma.c
+++ b/drivers/misc/mic/scif/scif_rma.c
@@ -1403,6 +1403,8 @@ int __scif_pin_pages(void *addr, size_t len, int *out_prot,
 				NULL);
 		up_write(&mm->mmap_sem);
 		if (nr_pages != pinned_pages->nr_pages) {
+			if (pinned_pages->nr_pages < 0)
+				pinned_pages->nr_pages = 0;
 			if (try_upgrade) {
 				if (ulimit)
 					__scif_dec_pinned_vm_lock(mm,
@@ -1423,7 +1425,6 @@ int __scif_pin_pages(void *addr, size_t len, int *out_prot,
 
 	if (pinned_pages->nr_pages < nr_pages) {
 		err = -EFAULT;
-		pinned_pages->nr_pages = nr_pages;
 		goto dec_pinned;
 	}
 
@@ -1436,7 +1437,6 @@ int __scif_pin_pages(void *addr, size_t len, int *out_prot,
 		__scif_dec_pinned_vm_lock(mm, nr_pages, 0);
 	/* Something went wrong! Rollback */
 error_unmap:
-	pinned_pages->nr_pages = nr_pages;
 	scif_destroy_pinned_pages(pinned_pages);
 	*pages = NULL;
 	dev_dbg(scif_info.mdev.this_device,
-- 
2.25.1



