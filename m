Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2106125958D
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgIAPxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731973AbgIAPrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:47:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD525214D8;
        Tue,  1 Sep 2020 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975234;
        bh=aHCoyj+j2lJWVdm5UgfX/mxFvh+za0C90Ro5NNi9D4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=othLkvXqq2FTv8yyORTshVe8zgRYP3HDyEMiQn/2zpy4EweBxIZOZocshjDdiGgLm
         mVnZKyrBXdq3Cf0RkZ9b+4nBPHZtlqCZD45Q5grXn5l3hSVe9zeJLy/zguiTynHdv7
         O47nvkvOSjWJGaG+Q/qcdBAqfhXoXoZ/HtZvOgZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.8 254/255] dma-pool: Fix an uninitialized variable bug in atomic_pool_expand()
Date:   Tue,  1 Sep 2020 17:11:50 +0200
Message-Id: <20200901151012.940296455@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 892fc9f6835ecf075efac20789b012c5c9997fcc upstream.

The "page" pointer can be used with out being initialized.

Fixes: d7e673ec2c8e ("dma-pool: Only allocate from CMA when in same memory zone")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/dma/pool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -84,7 +84,7 @@ static int atomic_pool_expand(struct gen
 			      gfp_t gfp)
 {
 	unsigned int order;
-	struct page *page;
+	struct page *page = NULL;
 	void *addr;
 	int ret = -ENOMEM;
 


