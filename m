Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5555CD8A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbiF0Lns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237452AbiF0Lmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D1ABC5;
        Mon, 27 Jun 2022 04:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7D4AB81122;
        Mon, 27 Jun 2022 11:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CEEC3411D;
        Mon, 27 Jun 2022 11:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329892;
        bh=pwOJvamP96Tuw1AUjx1q1pgZfW8V5ATClmD+AZJpHyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTAotees3rp7blWB10l4O0+nkp/klyNt4jmTvPI2asKLSqC1BuEYNDgtO/DwV05nL
         4iLmbTPcYd5K3BZ/xcMmrFfYEhiJ9TQ84MMdljrbiVsYq1sBY8Ah0dMb0v4C8uY5b3
         p9ysM0aXuxaIiy5D6DrHc16K9ViQb94BhbAh9qvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.18 015/181] 9p: fix fid refcount leak in v9fs_vfs_atomic_open_dotl
Date:   Mon, 27 Jun 2022 13:19:48 +0200
Message-Id: <20220627111945.005288038@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
@@ -274,6 +274,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
+		p9_client_clunk(dfid);
 		goto out;
 	}
 
@@ -285,6 +286,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *
 	if (err) {
 		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
@@ -292,6 +294,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_open_dotl failed in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	v9fs_invalidate_inode_attr(dir);


