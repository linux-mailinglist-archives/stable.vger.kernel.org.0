Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85552ABCA0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733221AbgKINjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbgKINDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:03:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFCD02222A;
        Mon,  9 Nov 2020 13:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926994;
        bh=XIMQnMghpz6vXvnvbYYPsyqWFNGcOkzsRKpAXmee1LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwMrJmrKMkuIXF7sjk5k+H+L7vTpMxBko5QDx5Z3wK1Ibp68HaCFDtbt0xSzFKKmY
         BRIDBYsiWGNx/ZYQaRq79/IxRMoxW1MFa+Vw2o0ov05ZDjYydWaXVqkI+EAyktcBBD
         RdHq5MXT+JU1FHU3OuR58ExKFteZA+0aygZA+58w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.9 074/117] ceph: promote to unsigned long long before shifting
Date:   Mon,  9 Nov 2020 13:55:00 +0100
Message-Id: <20201109125029.194101071@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit c403c3a2fbe24d4ed33e10cabad048583ebd4edf upstream.

On 32-bit systems, this shift will overflow for files larger than 4GB.

Cc: stable@vger.kernel.org
Fixes: 61f68816211e ("ceph: check caps in filemap_fault and page_mkwrite")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1392,7 +1392,7 @@ static int ceph_filemap_fault(struct vm_
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_info *fi = vma->vm_file->private_data;
 	struct page *pinned_page = NULL;
-	loff_t off = vmf->pgoff << PAGE_SHIFT;
+	loff_t off = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	int want, got, ret;
 	sigset_t oldset;
 


