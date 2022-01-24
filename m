Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451E249928A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347451AbiAXUVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348246AbiAXUTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:19:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545D5C07595F;
        Mon, 24 Jan 2022 11:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F692B8122F;
        Mon, 24 Jan 2022 19:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B99C340E7;
        Mon, 24 Jan 2022 19:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053115;
        bh=M9oIfxmAlJKoa8Khik9yGYB1gk0CI7pD+tdr8Mbg2A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJ2AIF4oq4sPy+F0jD+7+roKg4PlcJPmUPPhMhvzvHRxx0bMrjrlr8g/pmTMwp2t7
         GRkaZ4ytHH6/3QF0AOioUSapQ9RUsvM8R5kHs/sn2OgASz5beQeXErJtJtfirGDqAL
         xL6yZUc9mrhTRcBoSl1O9EyqFcxjfRtujP3YnR2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 282/320] RDMA/hns: Modify the mapping attribute of doorbell to device
Date:   Mon, 24 Jan 2022 19:44:26 +0100
Message-Id: <20220124184003.567963329@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -362,7 +362,7 @@ static int hns_roce_mmap(struct ib_ucont
 		return rdma_user_mmap_io(context, vma,
 					 to_hr_ucontext(context)->uar.pfn,
 					 PAGE_SIZE,
-					 pgprot_noncached(vma->vm_page_prot));
+					 pgprot_device(vma->vm_page_prot));
 
 	/* vm_pgoff: 1 -- TPTR */
 	case 1:


