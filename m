Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A7664A186
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbiLLNle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiLLNlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:41:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385451098
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:40:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA6D660FF4
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E359C433EF;
        Mon, 12 Dec 2022 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852426;
        bh=hAN3QgonAQdQkf9/bwXblsDa9Q3yKZmBX/v1qOu6cpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDrZvEb+ap8/A8BSTk63AcPuWSe0aK62PMrcidIi6IBULSbKnQDyo90mDCiBJ76pv
         18Us8ucrEvbpi73ZXp2Uwx63snB4qF3gHhRASMKd2tQQvl9hC6N0sNB5MJSqp/VNUX
         95CdsDeGRHOmU5iijRu1lsnnm8RiqIRbwOjFsbs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hugh Dickins <hughd@google.com>,
        Guoqi Chen <chenguoqic@163.com>, Rui Wang <kernel@hev.cc>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Matthew Wilcox <willy@infradead.org>,
        "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 060/157] tmpfs: fix data loss from failed fallocate
Date:   Mon, 12 Dec 2022 14:16:48 +0100
Message-Id: <20221212130936.979413327@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 44bcabd70cf1425b4243e02251c02b01638a8287 upstream.

Fix tmpfs data loss when the fallocate system call is interrupted by a
signal, or fails for some other reason.  The partial folio handling in
shmem_undo_range() forgot to consider this unfalloc case, and was liable
to erase or truncate out data which had already been committed earlier.

It turns out that none of the partial folio handling there is appropriate
for the unfalloc case, which just wants to proceed to removal of whole
folios: which find_get_entries() provides, even when partially covered.

Original patch by Rui Wang.

Link: https://lore.kernel.org/linux-mm/33b85d82.7764.1842e9ab207.Coremail.chenguoqic@163.com/
Link: https://lkml.kernel.org/r/a5dac112-cf4b-7af-a33-f386e347fd38@google.com
Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Guoqi Chen <chenguoqic@163.com>
  Link: https://lore.kernel.org/all/20221101032248.819360-1-kernel@hev.cc/
Cc: Rui Wang <kernel@hev.cc>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -958,6 +958,15 @@ static void shmem_undo_range(struct inod
 		index++;
 	}
 
+	/*
+	 * When undoing a failed fallocate, we want none of the partial folio
+	 * zeroing and splitting below, but shall want to truncate the whole
+	 * folio when !uptodate indicates that it was added by this fallocate,
+	 * even when [lstart, lend] covers only a part of the folio.
+	 */
+	if (unfalloc)
+		goto whole_folios;
+
 	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
 	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
 	if (folio) {
@@ -983,6 +992,8 @@ static void shmem_undo_range(struct inod
 		folio_put(folio);
 	}
 
+whole_folios:
+
 	index = start;
 	while (index < end) {
 		cond_resched();


