Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1AB5AE9DD
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbiIFNgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240710AbiIFNfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:35:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF867AC1F;
        Tue,  6 Sep 2022 06:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E84B81633;
        Tue,  6 Sep 2022 13:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9CBC433C1;
        Tue,  6 Sep 2022 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471243;
        bh=AH3bor9FHUfTQvRdH/pgLK4+Owq/zkRLMns2Qt34c4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGWvMZIYqn4kVAOvaW31njozev9pGXtNwpNhsL60ohy6UWNUdBOgJ8hdQc53MJVQR
         4hkvvZOJVp8d17wn2+8tYN90bn68Wr23k0E8TlkYWJ9dTZ0na21K7+JBmzZ4D0Koa6
         vAa1HdbD3mx/qnltY3R92NlsIM4bv/029NyBhtOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/80] xen/grants: prevent integer overflow in gnttab_dma_alloc_pages()
Date:   Tue,  6 Sep 2022 15:30:42 +0200
Message-Id: <20220906132818.881170499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e9ea0b30ada008f4e65933f449db6894832cb242 ]

The change from kcalloc() to kvmalloc() means that arg->nr_pages
might now be large enough that the "args->nr_pages << PAGE_SHIFT" can
result in an integer overflow.

Fixes: b3f7931f5c61 ("xen/gntdev: switch from kcalloc() to kvcalloc()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/YxDROJqu/RPvR0bi@kili
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 5c83d41766c85..0a2d24d6ac6f7 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -981,6 +981,9 @@ int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args)
 	size_t size;
 	int i, ret;
 
+	if (args->nr_pages < 0 || args->nr_pages > (INT_MAX >> PAGE_SHIFT))
+		return -ENOMEM;
+
 	size = args->nr_pages << PAGE_SHIFT;
 	if (args->coherent)
 		args->vaddr = dma_alloc_coherent(args->dev, size,
-- 
2.35.1



