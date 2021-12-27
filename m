Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBEF47FF30
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbhL0PgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:02 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40070 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238288AbhL0Pfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:35:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 233C4CE10B6;
        Mon, 27 Dec 2021 15:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21DAC36AEB;
        Mon, 27 Dec 2021 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619335;
        bh=JgwP6soaSUk6CkDscb2WJFVFnzQ8SjXk+5Pme/NMhgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsC+sHoDd5O4n4zvUSSLLF1woB5JSoZq7GHzGxopwwy3QO7eji9obJ4YyzJKtAT7c
         oSY28ZPbUYv9TyjrNQZU0AlPr1niR5YCffNQlI5Iv3DNqskki2Oh9L8Ah/GdO0HpIQ
         ikVzroRXPoNNgMfDgSQgrzEo3CB6JECF2qspfCDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrik Lantz <patrik.lantz@axis.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.4 35/47] tee: optee: Fix incorrect page free bug
Date:   Mon, 27 Dec 2021 16:31:11 +0100
Message-Id: <20211227151322.004889674@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

commit 18549bf4b21c739a9def39f27dcac53e27286ab5 upstream.

Pointer to the allocated pages (struct page *page) has already
progressed towards the end of allocation. It is incorrect to perform
__free_pages(page, order) using this pointer as we would free any
arbitrary pages. Fix this by stop modifying the page pointer.

Fixes: ec185dd3ab25 ("optee: Fix memory leak when failing to register shm pages")
Cc: stable@vger.kernel.org
Reported-by: Patrik Lantz <patrik.lantz@axis.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/shm_pool.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/tee/optee/shm_pool.c
+++ b/drivers/tee/optee/shm_pool.c
@@ -41,10 +41,8 @@ static int pool_op_alloc(struct tee_shm_
 			goto err;
 		}
 
-		for (i = 0; i < nr_pages; i++) {
-			pages[i] = page;
-			page++;
-		}
+		for (i = 0; i < nr_pages; i++)
+			pages[i] = page + i;
 
 		shm->flags |= TEE_SHM_REGISTER;
 		rc = optee_shm_register(shm->ctx, shm, pages, nr_pages,


