Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49B049920E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358395AbiAXURM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355456AbiAXUNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F48DC06177E;
        Mon, 24 Jan 2022 11:37:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BF5BB80FA1;
        Mon, 24 Jan 2022 19:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E94DC340E5;
        Mon, 24 Jan 2022 19:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053018;
        bh=KXa3PZX3KZ79XnZVl87pu7FZ3QvuxgE02+fJGd2UNa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwBay6TLX9Yv9r0Lm8wTWrlpP6jRSD3zGXHbQGHmr1r6IVGRU9pBsn4pPK5/kR/QC
         xY9QE6HPqXqpIqIorA8XM7UVDA83HYEceJdGMtcEYo3sK/Oaj/ysHSu40vgVjUAQaI
         nh6yvrNv6GerfCQGqtM+fDpKoOf1t7g72TuCMa9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 250/320] fuse: Pass correct lend value to filemap_write_and_wait_range()
Date:   Mon, 24 Jan 2022 19:43:54 +0100
Message-Id: <20220124184002.493762000@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -3188,7 +3188,7 @@ fuse_direct_IO(struct kiocb *iocb, struc
 
 static int fuse_writeback_range(struct inode *inode, loff_t start, loff_t end)
 {
-	int err = filemap_write_and_wait_range(inode->i_mapping, start, -1);
+	int err = filemap_write_and_wait_range(inode->i_mapping, start, LLONG_MAX);
 
 	if (!err)
 		fuse_sync_writes(inode);


