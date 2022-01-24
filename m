Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1BA49A5DB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371175AbiAYAHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363514AbiAXXop (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:44:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4935C05A19B;
        Mon, 24 Jan 2022 13:39:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 835F0614DC;
        Mon, 24 Jan 2022 21:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED46C340E4;
        Mon, 24 Jan 2022 21:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060369;
        bh=YlEiyxyqTNYwmSha/fJ9ajhtW4rM+zQ7a+BoGfI6+YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHW7zCekR8ZIBPgNNZf60JqymO0IIKAM3DCEJAQMTwIGNPVLoVtk4o4uOZaNatWCn
         ezW6lgbAajHErGRCSICyyr3YwrX17RkWFKjgTDqX2VRTzMle/Y0tbUNEZTai5COETu
         KmykzZZrzirohQffqVZnRueQbdMK5C6q+0i9FK+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.16 0925/1039] RDMA/hns: Modify the mapping attribute of doorbell to device
Date:   Mon, 24 Jan 2022 19:45:14 +0100
Message-Id: <20220124184156.385374522@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

commit 39d5534b1302189c809e90641ffae8cbdc42a8fc upstream.

It is more general for ARM device drivers to use the device attribute to
map PCI BAR spaces.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Link: https://lore.kernel.org/r/20211206133652.27476-1-liangwenpeng@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -442,7 +442,7 @@ static int hns_roce_mmap(struct ib_ucont
 	prot = vma->vm_page_prot;
 
 	if (entry->mmap_type != HNS_ROCE_MMAP_TYPE_TPTR)
-		prot = pgprot_noncached(prot);
+		prot = pgprot_device(prot);
 
 	ret = rdma_user_mmap_io(uctx, vma, pfn, rdma_entry->npages * PAGE_SIZE,
 				prot, rdma_entry);


