Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A5613801B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgAKKZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729374AbgAKKZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:25:58 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE18205F4;
        Sat, 11 Jan 2020 10:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738357;
        bh=kZlyWVfDQ/Il/ZTXyaCcECiQi49gcTd2X7UKT7IULYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/GUp/+diySdSVnMgupYgwAkcBzC3kE/r6VQqy227D/Ujo4zjMOvYEZVxe7Tr2qo2
         tKm1CvvclBe+xDyzbsIhMgB6eTH0ci8dKUWDFLhoSdPQJmO/s7DY9B980D9EMfWt3Q
         Teo+GWCpi8k8llE35GH03ST8rRvEFp12ssUHRtgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/165] ocxl: Fix potential memory leak on context creation
Date:   Sat, 11 Jan 2020 10:49:58 +0100
Message-Id: <20200111094927.798722801@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Barrat <fbarrat@linux.ibm.com>

[ Upstream commit 913e73c77d48aeeb50c16450a653dca9c71ae2e2 ]

If we couldn't fully init a context, we were leaking memory.

Fixes: b9721d275cc2 ("ocxl: Allow external drivers to use OpenCAPI contexts")
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191209105513.8566-1-fbarrat@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/context.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/ocxl/context.c b/drivers/misc/ocxl/context.c
index 994563a078eb..de8a66b9d76b 100644
--- a/drivers/misc/ocxl/context.c
+++ b/drivers/misc/ocxl/context.c
@@ -10,18 +10,17 @@ int ocxl_context_alloc(struct ocxl_context **context, struct ocxl_afu *afu,
 	int pasid;
 	struct ocxl_context *ctx;
 
-	*context = kzalloc(sizeof(struct ocxl_context), GFP_KERNEL);
-	if (!*context)
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
 		return -ENOMEM;
 
-	ctx = *context;
-
 	ctx->afu = afu;
 	mutex_lock(&afu->contexts_lock);
 	pasid = idr_alloc(&afu->contexts_idr, ctx, afu->pasid_base,
 			afu->pasid_base + afu->pasid_max, GFP_KERNEL);
 	if (pasid < 0) {
 		mutex_unlock(&afu->contexts_lock);
+		kfree(ctx);
 		return pasid;
 	}
 	afu->pasid_count++;
@@ -43,6 +42,7 @@ int ocxl_context_alloc(struct ocxl_context **context, struct ocxl_afu *afu,
 	 * duration of the life of the context
 	 */
 	ocxl_afu_get(afu);
+	*context = ctx;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ocxl_context_alloc);
-- 
2.20.1



