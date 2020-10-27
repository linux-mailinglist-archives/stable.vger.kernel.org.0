Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A88529B8D8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802037AbgJ0Pp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799597AbgJ0PcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E60EA22202;
        Tue, 27 Oct 2020 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812741;
        bh=5kuC3kJSimG113f+PYMvFxVBPS4coVAVuPo3jkozgVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSqTjc66x815bal8G+u+4C21w8mOww+AWqDEiccdIBHBusZJZCo/Re30gaZmbiiPz
         8MTGifP0ua2B2UVYms04MzLOOkSTw8Q3PVt+PkdsRlGGzgzMYebToSbrwx+I8q4od1
         1ubEIyt4srTmF/X6PjaWFVhc3TQ+mmEt/PjIF4XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 307/757] misc: mic: scif: Fix error handling path
Date:   Tue, 27 Oct 2020 14:49:17 +0100
Message-Id: <20201027135504.954643283@linuxfoundation.org>
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
index 2da3b474f4863..18fb9d8b8a4b5 100644
--- a/drivers/misc/mic/scif/scif_rma.c
+++ b/drivers/misc/mic/scif/scif_rma.c
@@ -1392,6 +1392,8 @@ int __scif_pin_pages(void *addr, size_t len, int *out_prot,
 				(prot & SCIF_PROT_WRITE) ? FOLL_WRITE : 0,
 				pinned_pages->pages);
 		if (nr_pages != pinned_pages->nr_pages) {
+			if (pinned_pages->nr_pages < 0)
+				pinned_pages->nr_pages = 0;
 			if (try_upgrade) {
 				if (ulimit)
 					__scif_dec_pinned_vm_lock(mm, nr_pages);
@@ -1408,7 +1410,6 @@ int __scif_pin_pages(void *addr, size_t len, int *out_prot,
 
 	if (pinned_pages->nr_pages < nr_pages) {
 		err = -EFAULT;
-		pinned_pages->nr_pages = nr_pages;
 		goto dec_pinned;
 	}
 
@@ -1421,7 +1422,6 @@ int __scif_pin_pages(void *addr, size_t len, int *out_prot,
 		__scif_dec_pinned_vm_lock(mm, nr_pages);
 	/* Something went wrong! Rollback */
 error_unmap:
-	pinned_pages->nr_pages = nr_pages;
 	scif_destroy_pinned_pages(pinned_pages);
 	*pages = NULL;
 	dev_dbg(scif_info.mdev.this_device,
-- 
2.25.1



