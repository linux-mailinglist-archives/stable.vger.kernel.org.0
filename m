Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3EA6CC4A6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjC1PHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbjC1PHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0590FD53B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D636185F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C09C433EF;
        Tue, 28 Mar 2023 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015901;
        bh=3AzyqRGKXF5WAeNY8KNlc4zgouVeABvVduLJnoml2gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOFJTLeje6lLN2oTGP7wSYW6uHwnlP751QGQMwrLc5aWfjIimB1uoTODLM/aWatcW
         eHPjzknajLLKYGY3KDU0xmbxuJx4TzaLrxNgEXdX6XyX/S+yQZvh/j1hhqIvly4HUX
         Vzp8flxkR0qcR+WVOT+5pMp/l3j7kVyULf5nrAiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Savino Dicanosa <sd7.dev@pm.me>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 187/224] io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get()
Date:   Tue, 28 Mar 2023 16:43:03 +0200
Message-Id: <20230328142625.170308091@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Savino Dicanosa <sd7.dev@pm.me>

commit 02a4d923e4400a36d340ea12d8058f69ebf3a383 upstream.

When fixed files are unregistered, file_alloc_end and alloc_hint
are not cleared. This can later cause a NULL pointer dereference in
io_file_bitmap_get() if auto index selection is enabled via
IORING_FILE_INDEX_ALLOC:

[    6.519129] BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
[    6.541468] RIP: 0010:_find_next_zero_bit+0x1a/0x70
[...]
[    6.560906] Call Trace:
[    6.561322]  <TASK>
[    6.561672]  io_file_bitmap_get+0x38/0x60
[    6.562281]  io_fixed_fd_install+0x63/0xb0
[    6.562851]  ? __pfx_io_socket+0x10/0x10
[    6.563396]  io_socket+0x93/0xf0
[    6.563855]  ? __pfx_io_socket+0x10/0x10
[    6.564411]  io_issue_sqe+0x5b/0x3d0
[    6.564914]  io_submit_sqes+0x1de/0x650
[    6.565452]  __do_sys_io_uring_enter+0x4fc/0xb20
[    6.566083]  ? __do_sys_io_uring_register+0x11e/0xd80
[    6.566779]  do_syscall_64+0x3c/0x90
[    6.567247]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[...]

To fix the issue, set file alloc range and alloc_hint to zero after
file tables are freed.

Cc: stable@vger.kernel.org
Fixes: 4278a0deb1f6 ("io_uring: defer alloc_hint update to io_file_bitmap_set()")
Signed-off-by: Savino Dicanosa <sd7.dev@pm.me>
[axboe: add explicit bitmap == NULL check as well]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/filetable.c |    3 +++
 io_uring/rsrc.c      |    1 +
 2 files changed, 4 insertions(+)

--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -19,6 +19,9 @@ static int io_file_bitmap_get(struct io_
 	unsigned long nr = ctx->file_alloc_end;
 	int ret;
 
+	if (!table->bitmap)
+		return -ENFILE;
+
 	do {
 		ret = find_next_zero_bit(table->bitmap, nr, table->alloc_hint);
 		if (ret != nr)
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -779,6 +779,7 @@ void __io_sqe_files_unregister(struct io
 	}
 #endif
 	io_free_file_tables(&ctx->file_table);
+	io_file_table_set_alloc_range(ctx, 0, 0);
 	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;


