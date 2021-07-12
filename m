Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA263C5064
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbhGLHcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346688AbhGLHbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B648461006;
        Mon, 12 Jul 2021 07:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074894;
        bh=kpBqSebfWgQEbDKLxzqVObLHgHlgpXbNuvTDeg9xsNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXRHTbILKLJBdshLKdltijb8oSDh46eijjJVcgiZZSSDZpw36JJrnztjtzj6Gg7W6
         WZkAstm7C7FWmvG/i+ZPU+drFmqt+fMwkO11ypNgtfdxOGHDKGkGWziS6i3EfNDMV7
         RLtWT8GL01Rz2NEEzowRrv6h6ZzDufRJpke27t2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.13 032/800] gfs2: Fix underflow in gfs2_page_mkwrite
Date:   Mon, 12 Jul 2021 08:00:55 +0200
Message-Id: <20210712060917.749912640@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit d3c51c55cb9274dd43c156f1f26b5eb4d5f2d58c upstream.

On filesystems with a block size smaller than PAGE_SIZE and non-empty
files smaller then PAGE_SIZE, gfs2_page_mkwrite could end up allocating
excess blocks beyond the end of the file, similar to fallocate.  This
doesn't make sense; fix it.

Reported-by: Bob Peterson <rpeterso@redhat.com>
Fixes: 184b4e60853d ("gfs2: Fix end-of-file handling in gfs2_page_mkwrite")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -450,8 +450,8 @@ static vm_fault_t gfs2_page_mkwrite(stru
 	file_update_time(vmf->vma->vm_file);
 
 	/* page is wholly or partially inside EOF */
-	if (offset > size - PAGE_SIZE)
-		length = offset_in_page(size);
+	if (size - offset < PAGE_SIZE)
+		length = size - offset;
 	else
 		length = PAGE_SIZE;
 


