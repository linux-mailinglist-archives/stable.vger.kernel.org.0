Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC3D261B60
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIHTCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731293AbgIHQIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:08:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D59B23E56;
        Tue,  8 Sep 2020 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580057;
        bh=1/B2Nlfy+gnWful87HjQ5P9kzGx/+jtgEH5HlRcJhUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biK2xbuL9A6kjDinANH30khfzTRzDPB+bz4o6wSXAPZLck6domfJ5YNR4tWnZkI0M
         b/em2RKZ1YqdASFsTO7SLCZGKoIZOxHJKVyL6j00RyK87xXOEorGUfqEAIvdry+gZP
         l55HXlaUu41pVCddgfhnSE8vVTMgkYjbJD3ZlB0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, JiangYu <lnsyyj@hotmail.com>,
        Daniel Meyerholt <dxm523@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 05/88] scsi: target: tcmu: Optimize use of flush_dcache_page
Date:   Tue,  8 Sep 2020 17:25:06 +0200
Message-Id: <20200908152221.351964351@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

commit 3c58f737231e2c8cbf543a09d84d8c8e80e05e43 upstream.

(scatter|gather)_data_area() need to flush dcache after writing data to or
before reading data from a page in uio data area.  The two routines are
able to handle data transfer to/from such a page in fragments and flush the
cache after each fragment was copied by calling the wrapper
tcmu_flush_dcache_range().

That means:

1) flush_dcache_page() can be called multiple times for the same page.

2) Calling flush_dcache_page() indirectly using the wrapper does not make
   sense, because each call of the wrapper is for one single page only and
   the calling routine already has the correct page pointer.

Change (scatter|gather)_data_area() such that, instead of calling
tcmu_flush_dcache_range() before/after each memcpy, it now calls
flush_dcache_page() before unmapping a page (when writing is complete for
that page) or after mapping a page (when starting to read the page).

After this change only calls to tcmu_flush_dcache_range() for addresses in
vmalloc'ed command ring are left over.

The patch was tested on ARM with kernel 4.19.118 and 5.7.2

Link: https://lore.kernel.org/r/20200618131632.32748-2-bstroesser@ts.fujitsu.com
Tested-by: JiangYu <lnsyyj@hotmail.com>
Tested-by: Daniel Meyerholt <dxm523@gmail.com>
Acked-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_user.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -687,8 +687,10 @@ static void scatter_data_area(struct tcm
 		from = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
-				if (to)
+				if (to) {
+					flush_dcache_page(page);
 					kunmap_atomic(to);
+				}
 
 				block_remaining = DATA_BLOCK_SIZE;
 				dbi = tcmu_cmd_get_dbi(tcmu_cmd);
@@ -733,7 +735,6 @@ static void scatter_data_area(struct tcm
 				memcpy(to + offset,
 				       from + sg->length - sg_remaining,
 				       copy_bytes);
-				tcmu_flush_dcache_range(to, copy_bytes);
 			}
 
 			sg_remaining -= copy_bytes;
@@ -742,8 +743,10 @@ static void scatter_data_area(struct tcm
 		kunmap_atomic(from - sg->offset);
 	}
 
-	if (to)
+	if (to) {
+		flush_dcache_page(page);
 		kunmap_atomic(to);
+	}
 }
 
 static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
@@ -789,13 +792,13 @@ static void gather_data_area(struct tcmu
 				dbi = tcmu_cmd_get_dbi(cmd);
 				page = tcmu_get_block_page(udev, dbi);
 				from = kmap_atomic(page);
+				flush_dcache_page(page);
 			}
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
 			if (read_len < copy_bytes)
 				copy_bytes = read_len;
 			offset = DATA_BLOCK_SIZE - block_remaining;
-			tcmu_flush_dcache_range(from, copy_bytes);
 			memcpy(to + sg->length - sg_remaining, from + offset,
 					copy_bytes);
 


