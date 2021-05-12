Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E520437C971
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhELQTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239630AbhELQKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25F1A61D39;
        Wed, 12 May 2021 15:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834006;
        bh=uT4St2Xmo4LGUuzGAYbLPQpZNkJ7+0Vm+KVqVISREpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZByKfa0fniqRWty/rZl0zXmKhMV3NQ8XyQQeIUJcFxj9+ZR2KX0ER+ORdbWh6u2N
         4CQjNjP6/SRg78lN4RZ06NfQ3vZB7RFZuZoGLWadLKiVrslyzxVGo+I7Cm8u7w11r8
         3VlbkRknOwrfMr6CSXjwDh42k0gBo2kF53tNEN5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Souptick Joarder <jrdr.linux@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 328/601] media: atomisp: Fixed error handling path
Date:   Wed, 12 May 2021 16:46:45 +0200
Message-Id: <20210512144838.605279993@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souptick Joarder <jrdr.linux@gmail.com>

[ Upstream commit 16a5dcf7fbc2f5cd10c1e6264262bfa3832fb7d5 ]

Inside alloc_user_pages() based on flag value either pin_user_pages()
or get_user_pages_fast() will be called. However, these API might fail.

But free_user_pages() called in error handling path doesn't bother
about return value and will try to unpin bo->pgnr pages, which is
incorrect.

Fix this by passing the page_nr to free_user_pages(). If page_nr > 0
pages will be unpinned based on bo->mem_type. This will also take care
of non error handling path.

allocation")

Link: https://lore.kernel.org/linux-media/1601219284-13275-1-git-send-email-jrdr.linux@gmail.com
Fixes: 14a638ab96c5 ("media: atomisp: use pin_user_pages() for memory
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c
index f13af2329f48..0168f9839c90 100644
--- a/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c
@@ -857,16 +857,17 @@ static void free_private_pages(struct hmm_buffer_object *bo,
 	kfree(bo->page_obj);
 }
 
-static void free_user_pages(struct hmm_buffer_object *bo)
+static void free_user_pages(struct hmm_buffer_object *bo,
+			    unsigned int page_nr)
 {
 	int i;
 
 	hmm_mem_stat.usr_size -= bo->pgnr;
 
 	if (bo->mem_type == HMM_BO_MEM_TYPE_PFN) {
-		unpin_user_pages(bo->pages, bo->pgnr);
+		unpin_user_pages(bo->pages, page_nr);
 	} else {
-		for (i = 0; i < bo->pgnr; i++)
+		for (i = 0; i < page_nr; i++)
 			put_page(bo->pages[i]);
 	}
 	kfree(bo->pages);
@@ -942,6 +943,8 @@ static int alloc_user_pages(struct hmm_buffer_object *bo,
 		dev_err(atomisp_dev,
 			"get_user_pages err: bo->pgnr = %d, pgnr actually pinned = %d.\n",
 			bo->pgnr, page_nr);
+		if (page_nr < 0)
+			page_nr = 0;
 		goto out_of_mem;
 	}
 
@@ -954,7 +957,7 @@ static int alloc_user_pages(struct hmm_buffer_object *bo,
 
 out_of_mem:
 
-	free_user_pages(bo);
+	free_user_pages(bo, page_nr);
 
 	return -ENOMEM;
 }
@@ -1037,7 +1040,7 @@ void hmm_bo_free_pages(struct hmm_buffer_object *bo)
 	if (bo->type == HMM_BO_PRIVATE)
 		free_private_pages(bo, &dynamic_pool, &reserved_pool);
 	else if (bo->type == HMM_BO_USER)
-		free_user_pages(bo);
+		free_user_pages(bo, bo->pgnr);
 	else
 		dev_err(atomisp_dev, "invalid buffer type.\n");
 	mutex_unlock(&bo->mutex);
-- 
2.30.2



