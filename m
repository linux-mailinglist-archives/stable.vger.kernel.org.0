Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A276A15C202
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBMP2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbgBMP2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:12 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 174C020661;
        Thu, 13 Feb 2020 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607691;
        bh=CuVfiS2S9a2bwNenn2jhACMneXOOC1/b5Hy9foAEjiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MY4fgVkx/SVfjFCGi/wSs2iWFtuKPobHt4z+hzQ7taLSr3zDTS282CiyeQvPC5JHH
         T7W4Iyzv+w8h1gXTYMQP3IupvbBPQDhHoNKe8+ANxFhOHHijEqhybogS6uVmNERkC/
         A0EOjTBWO6qnKkU4mW4NecQlK9Yqt2oTeNwzmG8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.5 029/120] NFS: Revalidate the file size on a fatal write error
Date:   Thu, 13 Feb 2020 07:20:25 -0800
Message-Id: <20200213151911.904360143@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 0df68ced55443243951d02cc497be31fadf28173 upstream.

If we suffer a fatal error upon writing a file, which causes us to
need to revalidate the entire mapping, then we should also revalidate
the file size.

Fixes: d2ceb7e57086 ("NFS: Don't use page_file_mapping after removing the page")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/write.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -243,7 +243,15 @@ out:
 /* A writeback failed: mark the page as bad, and invalidate the page cache */
 static void nfs_set_pageerror(struct address_space *mapping)
 {
+	struct inode *inode = mapping->host;
+
 	nfs_zap_mapping(mapping->host, mapping);
+	/* Force file size revalidation */
+	spin_lock(&inode->i_lock);
+	NFS_I(inode)->cache_validity |= NFS_INO_REVAL_FORCED |
+					NFS_INO_REVAL_PAGECACHE |
+					NFS_INO_INVALID_SIZE;
+	spin_unlock(&inode->i_lock);
 }
 
 static void nfs_mapping_set_error(struct page *page, int error)


