Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511D4593DD7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347167AbiHOUQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243555AbiHOUOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:14:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B987890199;
        Mon, 15 Aug 2022 11:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7144AB8109E;
        Mon, 15 Aug 2022 18:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20A7C433C1;
        Mon, 15 Aug 2022 18:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589959;
        bh=Dh+emGNHm1D8DGNCBwnBuEUQw+j66ciJrWboMiUcFmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OH+OUO6RlatWLtZKS/GI4qptL3WxCUTm9YDXMKWTVXo9jwbIhowRvzVusZrqtjR4v
         eR5/53UDFEM6zKm4SPJRehjxwoz/YPI6m2dao4TcihnSpI/D7glk0W/SHBExaIbxHU
         qz9qmxYGY4nhTZzskoLgdKC6vifnzdUf48cBqx10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6e1efbd8efaaa6860e91@syzkaller.appspotmail.com,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.18 0105/1095] fuse: write inode in fuse_release()
Date:   Mon, 15 Aug 2022 19:51:44 +0200
Message-Id: <20220815180433.905210062@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 035ff33cf4db101250fb980a3941bf078f37a544 upstream.

A race between write(2) and close(2) allows pages to be dirtied after
fuse_flush -> write_inode_now().  If these pages are not flushed from
fuse_release(), then there might not be a writable open file later.  So any
remaining dirty pages must be written back before the file is released.

This is a partial revert of the blamed commit.

Reported-by: syzbot+6e1efbd8efaaa6860e91@syzkaller.appspotmail.com
Fixes: 36ea23374d1f ("fuse: write inode in fuse_vma_close() instead of fuse_release()")
Cc: <stable@vger.kernel.org> # v5.16
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -338,6 +338,15 @@ static int fuse_open(struct inode *inode
 
 static int fuse_release(struct inode *inode, struct file *file)
 {
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	/*
+	 * Dirty pages might remain despite write_inode_now() call from
+	 * fuse_flush() due to writes racing with the close.
+	 */
+	if (fc->writeback_cache)
+		write_inode_now(inode, 1);
+
 	fuse_release_common(file, false);
 
 	/* return value is ignored by VFS */


