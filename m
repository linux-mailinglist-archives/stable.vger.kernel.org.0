Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A814661C2B
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 02:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjAIB7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Jan 2023 20:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjAIB64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 20:58:56 -0500
Received: from m12.mail.163.com (m12.mail.163.com [123.126.96.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE8DC11474;
        Sun,  8 Jan 2023 17:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=V73GE
        7ItZE/Xw4heb5jQUcmVbOy/bffSxEjr/WV2R2E=; b=bindf23vgxAqjx4tHXcgu
        YD6uTbWQCeOj8JY98upHPQIZqzpa8PBQcakbrWAckaet8O5PbKmaphC1wpm6WNI2
        dqgXGoIPzVvzenLS9FyvQD5w8hS7cp9T59+VEj8F9g212XJdknUO+/BAAxS8B7Jv
        bgAmy6fVfTD8sLZb06Afy4=
Received: from qubt.localdomain (unknown [27.29.245.123])
        by smtp19 (Coremail) with SMTP id R9xpCgDnE6W3dLtjGT8AEw--.49040S2;
        Mon, 09 Jan 2023 09:58:25 +0800 (CST)
From:   coolqyj@163.com
To:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc:     Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        Qian Yingjin <qian@ddn.com>
Subject: [PATCH] mm/filemap: fix page end in filemap_get_read_batch
Date:   Mon,  9 Jan 2023 09:58:12 +0800
Message-Id: <20230109015812.47027-1-coolqyj@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: R9xpCgDnE6W3dLtjGT8AEw--.49040S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tryDGFWrGw1kJw4DtF1kXwb_yoW8CF1Dpr
        45G3Zayrn7J3W7Zr47J3Zru3WY93y3tayYvFW8W3W3Zrn8Ja1a9w4fKFyYkryaqr4fZ34I
        gr4Yy34kuF4UtrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbvtZUUUUU=
X-Originating-IP: [27.29.245.123]
X-CM-SenderInfo: xfrrz1l1m6il2tof0z/xtbB3xDxz2BHNniq4AAAsS
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
 mm/filemap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c4d4ace9cc70..0e20a8d6dd93 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2588,18 +2588,19 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 	struct folio *folio;
 	int err = 0;
 
+	/* "last_index" is the index of the page beyond the end of the read */
 	last_index = DIV_ROUND_UP(iocb->ki_pos + iter->count, PAGE_SIZE);
 retry:
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
-	filemap_get_read_batch(mapping, index, last_index, fbatch);
+	filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	if (!folio_batch_count(fbatch)) {
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		page_cache_sync_readahead(mapping, ra, filp, index,
 				last_index - index);
-		filemap_get_read_batch(mapping, index, last_index, fbatch);
+		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	}
 	if (!folio_batch_count(fbatch)) {
 		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
-- 
2.34.1

