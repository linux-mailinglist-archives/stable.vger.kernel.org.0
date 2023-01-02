Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F097465B04E
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjABLK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbjABK4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:56:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954D362F7
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 02:55:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DEC0B80D08
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 10:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB8EC433EF;
        Mon,  2 Jan 2023 10:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672656917;
        bh=g12yHwjZid4Cv/igLlokzgdfhYOn3MqPONZKos6PoT8=;
        h=Subject:To:Cc:From:Date:From;
        b=WGoy/23PgoBFkqC5U6J93e5f9+IkaRbr2nnzUqz8E+ZjP5kCtg8BRyHe6IndW1kKq
         ZbEsmQBFVdt8Z7pylA2+ZRtVXl9+P5BF20o6Z4e6OXCs/LGfotZeIN3bC8X7hsrkw7
         mTviOHeI4T5zKRF5vbjx9OZik/aE98atXM6YltGU=
Subject: FAILED: patch "[PATCH] f2fs: allow to read node block after shutdown" failed to apply to 4.19-stable tree
To:     jaegeuk@kernel.org, chao@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Jan 2023 11:55:04 +0100
Message-ID: <1672656904209210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e6ecb1424291 ("f2fs: allow to read node block after shutdown")
b7ec2061737f ("f2fs: do not submit NEW_ADDR to read node block")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e6ecb142429183cef4835f31d4134050ae660032 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Tue, 8 Nov 2022 17:59:34 -0800
Subject: [PATCH] f2fs: allow to read node block after shutdown

If block address is still alive, we should give a valid node block even after
shutdown. Otherwise, we can see zero data when reading out a file.

Cc: stable@vger.kernel.org
Fixes: 83a3bfdb5a8a ("f2fs: indicate shutdown f2fs to allow unmount successfully")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 983572f23896..b9ee5a1176a0 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1360,8 +1360,7 @@ static int read_node_page(struct page *page, blk_opf_t op_flags)
 		return err;
 
 	/* NEW_ADDR can be seen, after cp_error drops some dirty node pages */
-	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR) ||
-			is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)) {
+	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR)) {
 		ClearPageUptodate(page);
 		return -ENOENT;
 	}

