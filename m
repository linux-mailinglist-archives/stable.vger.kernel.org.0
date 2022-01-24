Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D979C499547
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392527AbiAXUvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46738 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390742AbiAXUqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DF19B8122A;
        Mon, 24 Jan 2022 20:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7354AC340E5;
        Mon, 24 Jan 2022 20:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057167;
        bh=iVX2nFnEFRhokD0VjO3Y941ZpUA2yRw+aa5PKgYWm4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1fyC7UXzzdo+9zWhVBOTyQS5hkZ6dyAbS9vWj7GDXseRwX1ueThJ8ED1nb+DxWhQ
         pt2zxpV7Mp0fjmtyQSI43+d62vq9207ZAiaP7VEGkZKBUDf025GVGUB8Ga2FUalAhm
         9PmSV37+PwK/2lVopZ2zMGPSBIwh3dRDDZyuT9DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 680/846] fuse: Pass correct lend value to filemap_write_and_wait_range()
Date:   Mon, 24 Jan 2022 19:43:17 +0100
Message-Id: <20220124184124.534235330@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

commit e388164ea385f04666c4633f5dc4f951fca71890 upstream.

The acceptable maximum value of lend parameter in
filemap_write_and_wait_range() is LLONG_MAX rather than -1. And there is
also some logic depending on LLONG_MAX check in write_cache_pages(). So
let's pass LLONG_MAX to filemap_write_and_wait_range() in
fuse_writeback_range() instead.

Fixes: 59bda8ecee2f ("fuse: flush extending writes")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Cc: <stable@vger.kernel.org> # v5.15
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2913,7 +2913,7 @@ fuse_direct_IO(struct kiocb *iocb, struc
 
 static int fuse_writeback_range(struct inode *inode, loff_t start, loff_t end)
 {
-	int err = filemap_write_and_wait_range(inode->i_mapping, start, -1);
+	int err = filemap_write_and_wait_range(inode->i_mapping, start, LLONG_MAX);
 
 	if (!err)
 		fuse_sync_writes(inode);


