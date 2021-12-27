Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84ABB47FFBD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239022AbhL0PlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38956 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239206AbhL0PjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD32610E8;
        Mon, 27 Dec 2021 15:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09357C36AEA;
        Mon, 27 Dec 2021 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619540;
        bh=JgwP6soaSUk6CkDscb2WJFVFnzQ8SjXk+5Pme/NMhgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRzOnV0WzJU9VHO5L+WSMOPJSmdI99QB02LRD7dtmqDtKCbaNd95QpNWVgv2+N7A/
         5Ix7j5TXrBMYoHtokauOwx76AnOJfzMzFxvUCERFVZqT++rh293Q/cavPUKv4RghLN
         ErsboCvREspnbyAPxQzhSevvOYrR+3zhsye8XpHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrik Lantz <patrik.lantz@axis.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.10 59/76] tee: optee: Fix incorrect page free bug
Date:   Mon, 27 Dec 2021 16:31:14 +0100
Message-Id: <20211227151326.742718340@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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


