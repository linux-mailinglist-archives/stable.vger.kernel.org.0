Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C9049959D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442127AbiAXUxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41836 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391403AbiAXUrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:47:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0C6660B21;
        Mon, 24 Jan 2022 20:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892CFC340E5;
        Mon, 24 Jan 2022 20:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057256;
        bh=i0lihinUbInNOUuO3k/TpBIaxsO2EYAGWFul2X7X+Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HatzBXLTH2KyOyBnEJSyhGjFKBP5YsZTs70qrQO/aprPlhzl0leASEG5ZDy1JOx1I
         c6OdeD8AQcHoh3LdYSM4102/PWitZae3ahfmRqMgnuAXdS7z/Jbyhl0SN2C/nUIFmZ
         m433lMhmL1L/U0XT9+UtaU2ViKOSaPKV8oMRfrN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 751/846] RDMA/hns: Modify the mapping attribute of doorbell to device
Date:   Mon, 24 Jan 2022 19:44:28 +0100
Message-Id: <20220124184126.884360488@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -352,7 +352,7 @@ static int hns_roce_mmap(struct ib_ucont
 		return rdma_user_mmap_io(context, vma,
 					 to_hr_ucontext(context)->uar.pfn,
 					 PAGE_SIZE,
-					 pgprot_noncached(vma->vm_page_prot),
+					 pgprot_device(vma->vm_page_prot),
 					 NULL);
 
 	/* vm_pgoff: 1 -- TPTR */


