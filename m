Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991B12A5816
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732097AbgKCVsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:48:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731287AbgKCUuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFEFE20719;
        Tue,  3 Nov 2020 20:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436621;
        bh=OMTqSajG1lCHhZJ0KW8Cav0eH77NUzurjbVwVAwb5rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POrNWb9eOXbe/K8BhyGGp61dP/wtba2XhVbMN2dPV8w5DnB/GVfJL5ffwik3C/pnl
         dgpzAU+EUFoGBO3NXCZuvLNHmv9xb6h8di+UpK/8LkDg2CAKURwbh8pEtydGRABqRo
         Sy7livNEqryqScUkaU+AZR1FBLlEyk+oTbuI+5xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.9 330/391] 9P: Cast to loff_t before multiplying
Date:   Tue,  3 Nov 2020 21:36:21 +0100
Message-Id: <20201103203409.390559336@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit f5f7ab168b9a60e12a4b8f2bb6fcc91321dc23c1 upstream.

On 32-bit systems, this multiplication will overflow for files larger
than 4GB.

Link: http://lkml.kernel.org/r/20201004180428.14494-2-willy@infradead.org
Cc: stable@vger.kernel.org
Fixes: fb89b45cdfdc ("9P: introduction of a new cache=mmap model.")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/9p/vfs_file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -612,9 +612,9 @@ static void v9fs_mmap_vm_close(struct vm
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
 		.sync_mode = WB_SYNC_ALL,
-		.range_start = vma->vm_pgoff * PAGE_SIZE,
+		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,
 		 /* absolute end, byte at end included */
-		.range_end = vma->vm_pgoff * PAGE_SIZE +
+		.range_end = (loff_t)vma->vm_pgoff * PAGE_SIZE +
 			(vma->vm_end - vma->vm_start - 1),
 	};
 


