Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A8429C0A1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818073AbgJ0RRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782189AbgJ0O4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3F422283;
        Tue, 27 Oct 2020 14:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810607;
        bh=qdq0E/jGIruANVQF+VFYNqx9xPDbKDwAH9Ni7hWWuyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tG70Y+swoQIk+/IYO7yhuGc08BZVeugiio6xJdEB27Yektww3gSdRhIs2AV9RT9pB
         uDhPEyytGHKC4hH6C9RtqPTzn+lF2/i+CHNR48PnvJOn/ic4fbuu8WKUMzyy2o79lH
         uw6sQm63NGMLGWNphQyzssGxYvugcjPp6oBqfypE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Souptick Joarder <jrdr.linux@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 199/633] drivers/virt/fsl_hypervisor: Fix error handling path
Date:   Tue, 27 Oct 2020 14:49:02 +0100
Message-Id: <20201027135532.017651660@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

[ Upstream commit 7f360bec37857bfd5a48cef21d86f58a09a3df63 ]

First, when memory allocation for sg_list_unaligned failed, there
is a bug of calling put_pages() as we haven't pinned any pages.

Second, if get_user_pages_fast() failed we should unpin num_pinned
pages.

This will address both.

As part of these changes, minor update in documentation.

Fixes: 6db7199407ca ("drivers/virt: introduce Freescale hypervisor management driver")
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Link: https://lore.kernel.org/r/1598995271-6755-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/fsl_hypervisor.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 1b0b11b55d2a0..46ee0a0998b6f 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -157,7 +157,7 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __user *p)
 
 	unsigned int i;
 	long ret = 0;
-	int num_pinned; /* return value from get_user_pages() */
+	int num_pinned = 0; /* return value from get_user_pages_fast() */
 	phys_addr_t remote_paddr; /* The next address in the remote buffer */
 	uint32_t count; /* The number of bytes left to copy */
 
@@ -174,7 +174,7 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __user *p)
 		return -EINVAL;
 
 	/*
-	 * The array of pages returned by get_user_pages() covers only
+	 * The array of pages returned by get_user_pages_fast() covers only
 	 * page-aligned memory.  Since the user buffer is probably not
 	 * page-aligned, we need to handle the discrepancy.
 	 *
@@ -224,7 +224,7 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __user *p)
 
 	/*
 	 * 'pages' is an array of struct page pointers that's initialized by
-	 * get_user_pages().
+	 * get_user_pages_fast().
 	 */
 	pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages) {
@@ -241,7 +241,7 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __user *p)
 	if (!sg_list_unaligned) {
 		pr_debug("fsl-hv: could not allocate S/G list\n");
 		ret = -ENOMEM;
-		goto exit;
+		goto free_pages;
 	}
 	sg_list = PTR_ALIGN(sg_list_unaligned, sizeof(struct fh_sg_list));
 
@@ -250,7 +250,6 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __user *p)
 		num_pages, param.source != -1 ? FOLL_WRITE : 0, pages);
 
 	if (num_pinned != num_pages) {
-		/* get_user_pages() failed */
 		pr_debug("fsl-hv: could not lock source buffer\n");
 		ret = (num_pinned < 0) ? num_pinned : -EFAULT;
 		goto exit;
@@ -292,13 +291,13 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __user *p)
 		virt_to_phys(sg_list), num_pages);
 
 exit:
-	if (pages) {
-		for (i = 0; i < num_pages; i++)
-			if (pages[i])
-				put_page(pages[i]);
+	if (pages && (num_pinned > 0)) {
+		for (i = 0; i < num_pinned; i++)
+			put_page(pages[i]);
 	}
 
 	kfree(sg_list_unaligned);
+free_pages:
 	kfree(pages);
 
 	if (!ret)
-- 
2.25.1



