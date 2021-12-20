Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D2147AD35
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhLTOux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54544 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbhLTOr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BAEFB80EE9;
        Mon, 20 Dec 2021 14:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA58C36AE7;
        Mon, 20 Dec 2021 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011647;
        bh=VLF/6JVooaR1fAgBByo04dqJVL0sKw6ncRWbOB4/yHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Km0nr4Hy9pzox2qIXhM+DhRh1eeijONdyuRj+b3H/EAHNgUHBqvksBJI8T3k4CnXA
         DfBxkatQDv8MgbmzR3fwELPEYN1fnGEGDm0FzQRbrjyALtU+yLTdVa1gF1iZDfaViW
         SMk9plI8IZPcfIJmA63cyKiFP51Sk/tCggilMWvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/99] tee: amdtee: fix an IS_ERR() vs NULL bug
Date:   Mon, 20 Dec 2021 15:33:57 +0100
Message-Id: <20211220143030.167535107@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9d7482771fac8d8e38e763263f2ca0ca12dd22c6 ]

The __get_free_pages() function does not return error pointers it returns
NULL so fix this condition to avoid a NULL dereference.

Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/amdtee/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index da6b88e80dc07..297dc62bca298 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -203,9 +203,8 @@ static int copy_ta_binary(struct tee_context *ctx, void *ptr, void **ta,
 
 	*ta_size = roundup(fw->size, PAGE_SIZE);
 	*ta = (void *)__get_free_pages(GFP_KERNEL, get_order(*ta_size));
-	if (IS_ERR(*ta)) {
-		pr_err("%s: get_free_pages failed 0x%llx\n", __func__,
-		       (u64)*ta);
+	if (!*ta) {
+		pr_err("%s: get_free_pages failed\n", __func__);
 		rc = -ENOMEM;
 		goto rel_fw;
 	}
-- 
2.33.0



