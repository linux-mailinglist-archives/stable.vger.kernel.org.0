Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E1960AB3F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbiJXNqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236664AbiJXNpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:45:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBA848CA3;
        Mon, 24 Oct 2022 05:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30103612B2;
        Mon, 24 Oct 2022 12:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4395BC433C1;
        Mon, 24 Oct 2022 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615135;
        bh=mGqmo0S/cZ1DZJ0WQ/Bt9WjSLdXTjqMxohIkX6GdePo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zN0XRl7FQrxqthb0iSMZVMCZInoqyms8WvmXJ8HrBDhg4009W3fDehI66+a8lCtjN
         HG3T6thrO1DpM9v7jyA7/mXHCzYdWQ8wbdXSjJqP/N7LIsgrVB3ffuqR7sAvnlnR0U
         jBeikqUAFhyNNTEweYayi4cjy/7gsxqCQHa2dFfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 095/530] ext4: fix check for block being out of directory size
Date:   Mon, 24 Oct 2022 13:27:19 +0200
Message-Id: <20221024113049.320400755@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 61a1d87a324ad5e3ed27c6699dfc93218fcf3201 upstream.

The check in __ext4_read_dirblock() for block being outside of directory
size was wrong because it compared block number against directory size
in bytes. Fix it.

Fixes: 65f8ea4cd57d ("ext4: check if directory block is within i_size")
CVE: CVE-2022-1184
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Link: https://lore.kernel.org/r/20220822114832.1482-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -126,7 +126,7 @@ static struct buffer_head *__ext4_read_d
 	struct ext4_dir_entry *dirent;
 	int is_dx_block = 0;
 
-	if (block >= inode->i_size) {
+	if (block >= inode->i_size >> inode->i_blkbits) {
 		ext4_error_inode(inode, func, line, block,
 		       "Attempting to read directory block (%u) that is past i_size (%llu)",
 		       block, inode->i_size);


