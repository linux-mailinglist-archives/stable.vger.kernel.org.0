Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC38499A84
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573255AbiAXVop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54520 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455446AbiAXVfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48821614DC;
        Mon, 24 Jan 2022 21:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0869EC340E4;
        Mon, 24 Jan 2022 21:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060124;
        bh=nihZ6mRuEfw9Nm2odeKkItkBuY+SluAK7kkWNygtmr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYOnoRkkAsypJ3J3lu3A9PUpSZVHBt2rcGyAkbzM7GeO0XM72jPZK1hAdXEB8qE1s
         QbsSXGZm1sC98FN+LdAQvhfceoQa2dQN83ueCsMrCAZ83qp0xvuoYTSnz2l8/yTkQd
         80t9BmihFYl4mOs/T9ktUVE4oRdx+tt7msx1NChk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.16 0848/1039] fuse: Pass correct lend value to filemap_write_and_wait_range()
Date:   Mon, 24 Jan 2022 19:43:57 +0100
Message-Id: <20220124184153.789026336@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -2910,7 +2910,7 @@ fuse_direct_IO(struct kiocb *iocb, struc
 
 static int fuse_writeback_range(struct inode *inode, loff_t start, loff_t end)
 {
-	int err = filemap_write_and_wait_range(inode->i_mapping, start, -1);
+	int err = filemap_write_and_wait_range(inode->i_mapping, start, LLONG_MAX);
 
 	if (!err)
 		fuse_sync_writes(inode);


