Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BE63D280D
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhGVPyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhGVPy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F376135A;
        Thu, 22 Jul 2021 16:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971702;
        bh=9k1BIdPX0CC+8RIExlDw73dOwbK84xLdbE8koyqanis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Fv7t1haPeqG1c6FuHtcZuqvj0lqkDxqVna5PuqzZxLSV5T1ip90piBXbM1+BLbmB
         nSaOzpOKk5oFyFUohhgW0ifdfl3M+UYDYkqqYwPC+rtHQzXv02d0G9MjEnc43dOud2
         IqdrvCGBpKTgYJCcIEdb3TrdYnv2bJX4ys1bWd7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Ekstrand <jason@jlekstrand.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [PATCH 5.4 66/71] dma-buf/sync_file: Dont leak fences on merge failure
Date:   Thu, 22 Jul 2021 18:31:41 +0200
Message-Id: <20210722155620.111203896@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Ekstrand <jason@jlekstrand.net>

commit ffe000217c5068c5da07ccb1c0f8cce7ad767435 upstream.

Each add_fence() call does a dma_fence_get() on the relevant fence.  In
the error path, we weren't calling dma_fence_put() so all those fences
got leaked.  Also, in the krealloc_array failure case, we weren't
freeing the fences array.  Instead, ensure that i and fences are always
zero-initialized and dma_fence_put() all the fences and kfree(fences) on
every error path.

Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
Reviewed-by: Christian König <christian.koenig@amd.com>
Fixes: a02b9dc90d84 ("dma-buf/sync_file: refactor fence storage in struct sync_file")
Cc: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Cc: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210624174732.1754546-1-jason@jlekstrand.net
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/sync_file.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -211,8 +211,8 @@ static struct sync_file *sync_file_merge
 					 struct sync_file *b)
 {
 	struct sync_file *sync_file;
-	struct dma_fence **fences, **nfences, **a_fences, **b_fences;
-	int i, i_a, i_b, num_fences, a_num_fences, b_num_fences;
+	struct dma_fence **fences = NULL, **nfences, **a_fences, **b_fences;
+	int i = 0, i_a, i_b, num_fences, a_num_fences, b_num_fences;
 
 	sync_file = sync_file_alloc();
 	if (!sync_file)
@@ -236,7 +236,7 @@ static struct sync_file *sync_file_merge
 	 * If a sync_file can only be created with sync_file_merge
 	 * and sync_file_create, this is a reasonable assumption.
 	 */
-	for (i = i_a = i_b = 0; i_a < a_num_fences && i_b < b_num_fences; ) {
+	for (i_a = i_b = 0; i_a < a_num_fences && i_b < b_num_fences; ) {
 		struct dma_fence *pt_a = a_fences[i_a];
 		struct dma_fence *pt_b = b_fences[i_b];
 
@@ -278,15 +278,16 @@ static struct sync_file *sync_file_merge
 		fences = nfences;
 	}
 
-	if (sync_file_set_fence(sync_file, fences, i) < 0) {
-		kfree(fences);
+	if (sync_file_set_fence(sync_file, fences, i) < 0)
 		goto err;
-	}
 
 	strlcpy(sync_file->user_name, name, sizeof(sync_file->user_name));
 	return sync_file;
 
 err:
+	while (i)
+		dma_fence_put(fences[--i]);
+	kfree(fences);
 	fput(sync_file->file);
 	return NULL;
 


