Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B561C65CC21
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 04:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbjADDWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 22:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbjADDWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 22:22:02 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E2B11789C;
        Tue,  3 Jan 2023 19:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NSE/V
        BFSGdyolrkn2/uYBXDt5bVP5xQn71kPlTU2ij0=; b=DShXx0lqovfrrmcLp/sao
        OBZ7+API/TJZ1FPKy8pbZaklzNwQXs1OZyLDMl7gZzVxJA6guXaFtGLgLJH9Y+3e
        jWmlmJ6wiW4LS+Om0d0IXiNhOV04Ecemcv2fdHx7lE3vOD9OqANifahwQkl6aGjq
        FsuFYF2wt/sdHbbDSH+R7c=
Received: from qubt.localdomain (unknown [171.40.161.28])
        by zwqz-smtp-mta-g2-0 (Coremail) with SMTP id _____wC3Vba28LRjndQoAA--.18469S2;
        Wed, 04 Jan 2023 11:21:28 +0800 (CST)
From:   coolqyj@163.com
To:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc:     Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        qian@ddn.com
Subject: [PATCH] mm/filemap: fix page end in filemap_get_read_batch
Date:   Wed,  4 Jan 2023 11:21:24 +0800
Message-Id: <20230104032124.72483-1-coolqyj@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wC3Vba28LRjndQoAA--.18469S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tryDGFWrGw1kJw4DtF1kXwb_yoW8tr1Upr
        s8Gw1vyr4DGF4UCrsrJ3WDu3WYk3srtay5ZFW8Ww1SvFn8JFnIgr9rKFy5Ar98XrWfZa4x
        tF4jy348uF4jqrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjmhrUUUUU=
X-Originating-IP: [171.40.161.28]
X-CM-SenderInfo: xfrrz1l1m6il2tof0z/xtbBERvsz1aEMQJ12wAAsm
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Yingjin <qian@ddn.com>

I was running traces of the read code against an RAID storage
system to understand why read requests were being misaligned
against the underlying RAID strips. I found that the page end
offset calculation in filemap_get_read_batch() was off by one.

When a read is submitted with end offset 1048575, then it
calculates the end page for read of 256 when it should be 255.
"last_index" is the index of the page beyond the end of the read
and it should be skipped when get a batch of pages for read in
@filemap_get_read_batch().

The below simple patch fixes the problem. This code was introduced
in kernel 5.12.

Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")

Signed-off-by: Qian Yingjin <qian@ddn.com>
---
 mm/filemap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c4d4ace9cc70..b7754760c09a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2371,7 +2371,7 @@ static void shrink_readahead_size_eio(struct file_ra_state *ra)
  * clear so that the caller can take the appropriate action.
  */
 static void filemap_get_read_batch(struct address_space *mapping,
-		pgoff_t index, pgoff_t max, struct folio_batch *fbatch)
+		pgoff_t index, pgoff_t last_index, struct folio_batch *fbatch)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
@@ -2380,7 +2380,11 @@ static void filemap_get_read_batch(struct address_space *mapping,
 	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
-		if (xas.xa_index > max || xa_is_value(folio))
+		/*
+		 * "last_index" is the index of the page beyond the end of
+		 * the read.
+		 */
+		if (xas.xa_index >= last_index || xa_is_value(folio))
 			break;
 		if (xa_is_sibling(folio))
 			break;
@@ -2588,6 +2592,7 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 	struct folio *folio;
 	int err = 0;
 
+	/* "last_index" is the index of the page beyond the end of the read */
 	last_index = DIV_ROUND_UP(iocb->ki_pos + iter->count, PAGE_SIZE);
 retry:
 	if (fatal_signal_pending(current))
-- 
2.34.1

