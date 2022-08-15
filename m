Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65106593BEA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345974AbiHOUNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346175AbiHOUK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:10:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28635598;
        Mon, 15 Aug 2022 11:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 567506125B;
        Mon, 15 Aug 2022 18:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D2BC433D7;
        Mon, 15 Aug 2022 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589810;
        bh=pqBJ1NWS1RN2vBwc3PaPKuwfdOzMrRfU7YsQ6GivFJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twz3rajwPB3oZ/nul8KbjYFrlrB4YQ6FuOHzyMnjhar8LSJ4/igoyO0UfrouT64iQ
         tbnGE2gLotss/ZSuUVEzSohBi6zE7khBXibZvfa5ZVyx6OV7W2e63qb7hyhd+uzBoz
         tYYJBjMuvCr0/LJUCz7kRNY1f1yqwAR6Ao9xqvIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongbo Yin <yinhongbo@bytedance.com>,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Tianci Zhang <zhangtianci.1997@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.18 0055/1095] ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()
Date:   Mon, 15 Aug 2022 19:50:54 +0200
Message-Id: <20220815180431.744923553@linuxfoundation.org>
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

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit dd524b7f317de8d31d638cbfdc7be4cf9b770e42 upstream.

Some code paths cannot guarantee the inode have any dentry alias. So
WARN_ON() all !dentry may flood the kernel logs.

For example, when an overlayfs inode is watched by inotifywait (1), and
someone is trying to read the /proc/$(pidof inotifywait)/fdinfo/INOTIFY_FD,
at that time if the dentry has been reclaimed by kernel (such as
echo 2 > /proc/sys/vm/drop_caches), there will be a WARN_ON(). The
printed call stack would be like:

    ? show_mark_fhandle+0xf0/0xf0
    show_mark_fhandle+0x4a/0xf0
    ? show_mark_fhandle+0xf0/0xf0
    ? seq_vprintf+0x30/0x50
    ? seq_printf+0x53/0x70
    ? show_mark_fhandle+0xf0/0xf0
    inotify_fdinfo+0x70/0x90
    show_fdinfo.isra.4+0x53/0x70
    seq_show+0x130/0x170
    seq_read+0x153/0x440
    vfs_read+0x94/0x150
    ksys_read+0x5f/0xe0
    do_syscall_64+0x59/0x1e0
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

So let's drop WARN_ON() to avoid kernel log flooding.

Reported-by: Hongbo Yin <yinhongbo@bytedance.com>
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Tianci Zhang <zhangtianci.1997@bytedance.com>
Fixes: 8ed5eec9d6c4 ("ovl: encode pure upper file handles")
Cc: <stable@vger.kernel.org> # v4.16
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/export.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -259,7 +259,7 @@ static int ovl_encode_fh(struct inode *i
 		return FILEID_INVALID;
 
 	dentry = d_find_any_alias(inode);
-	if (WARN_ON(!dentry))
+	if (!dentry)
 		return FILEID_INVALID;
 
 	bytes = ovl_dentry_to_fid(ofs, dentry, fid, buflen);


