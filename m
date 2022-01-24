Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414B0498D0E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347088AbiAXT10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:27:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52656 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345874AbiAXTYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:24:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B7F61447;
        Mon, 24 Jan 2022 19:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58207C340E5;
        Mon, 24 Jan 2022 19:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052260;
        bh=hHYPuzQMlbi5BWrijAFproJ8AIh6hz9KF3iVdpWexwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfTKlzHoNe7TQ130Uz55/1uhmoaqc1+qecy2drWgt0ypQnnEuWG7sNPzpWD7366eW
         kiKPTO8XXs412t53ubLcGkefeonZgLUZu59OCaaEHGCBwNabDRp0RLXjgeMo8zW7KU
         IxHq3xjh1338Ou/R+i5/lMDhryOOqoDuDAEx28f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.19 215/239] RDMA/hns: Modify the mapping attribute of doorbell to device
Date:   Mon, 24 Jan 2022 19:44:13 +0100
Message-Id: <20220124183949.946783914@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
@@ -432,7 +432,7 @@ static int hns_roce_mmap(struct ib_ucont
 		return -EINVAL;
 
 	if (vma->vm_pgoff == 0) {
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
 		if (io_remap_pfn_range(vma, vma->vm_start,
 				       to_hr_ucontext(context)->uar.pfn,
 				       PAGE_SIZE, vma->vm_page_prot))


