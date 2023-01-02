Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E1465B020
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 11:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjABK46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 05:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbjABK43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:56:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B871123
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 02:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AC8CB80D06
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 10:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7B6C433F0;
        Mon,  2 Jan 2023 10:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672656914;
        bh=Habv4ibJoS00gz1Qk+ifqlnHvrMZ1clsY3Qjo0Z0DxQ=;
        h=Subject:To:Cc:From:Date:From;
        b=N8lfKwGyMxbBrEHff45ZqJdpXQ7RBxEcebuawSdPWwdKHpPsYIoMVCaEZMPZdd0Si
         Ea5egCLCy8j7YPBtHBdKG4Rlu5Sf+n1BglYcg0HRhAX6x5dardWXrC6piJ2tcjOJiS
         KyTmavQh3t6na/aA++UCu1d4W1IPch2cEE2qSjDk=
Subject: FAILED: patch "[PATCH] f2fs: allow to read node block after shutdown" failed to apply to 5.4-stable tree
To:     jaegeuk@kernel.org, chao@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Jan 2023 11:55:03 +0100
Message-ID: <1672656903124130@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
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

