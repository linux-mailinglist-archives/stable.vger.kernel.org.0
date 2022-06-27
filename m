Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF455DD29
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiF0LfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbiF0Ld7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:33:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6039BE6;
        Mon, 27 Jun 2022 04:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4181B60920;
        Mon, 27 Jun 2022 11:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4915FC3411D;
        Mon, 27 Jun 2022 11:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329476;
        bh=qVmso/Xeu4w+IvyAtNFsFsv8nDCVZ86jwETqtgL64rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtO0B+HjjHDPaYAhwL78ZPfqMNoos9bXVDXyQEfw+rxtNoz0l0XeO/FVMdUiVhv9n
         /VKeHYq/hBLU24Sn4LrBa8COEE1RsBSsADSNg6Lyxg3LVhMUbglTfpYDJoeE3Gh+zS
         h4Xx3BoWsMrvICbqTK3l9kgUipQJCh3xuKuPzGHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.15 012/135] 9p: fix fid refcount leak in v9fs_vfs_atomic_open_dotl
Date:   Mon, 27 Jun 2022 13:20:19 +0200
Message-Id: <20220627111938.515303174@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit beca774fc51a9ba8abbc869cf0c3d965ff17cd24 upstream.

We need to release directory fid if we fail halfway through open

This fixes fid leaking with xfstests generic 531

Link: https://lkml.kernel.org/r/20220612085330.1451496-2-asmadeus@codewreck.org
Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
Cc: stable@vger.kernel.org
Reported-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode_dotl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -276,6 +276,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
+		p9_client_clunk(dfid);
 		goto out;
 	}
 
@@ -287,6 +288,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *
 	if (err) {
 		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
@@ -294,6 +296,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_open_dotl failed in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	v9fs_invalidate_inode_attr(dir);


