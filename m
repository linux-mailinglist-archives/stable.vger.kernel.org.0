Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C794173EC
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345157AbhIXNAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345766AbhIXM7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E222C613B5;
        Fri, 24 Sep 2021 12:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487987;
        bh=asz7dV+O7xCkncg+U15FeU0iCWKQP6LqWTxECWg+gMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKMLA/SQgmVvJOkGwIwWwxgbXiyzWRbB/CvKcLjr6sCQoloADSSq+treNNvOBz+wV
         XyvSJF95FJnHc2IMPUb8kCWUyhB2+ZOpol8SrxL9NURJCxCWHiHRXu79o5FoNiCEnp
         LTA7OhzKYX8i5kOdjQFMtF6Pt/jitiss8d8LDFvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.14 008/100] RDMA/hns: Enable stash feature of HIP09
Date:   Fri, 24 Sep 2021 14:43:17 +0200
Message-Id: <20210924124341.741821219@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

commit 260f64a40198309008026447f7fda277a73ed8c3 upstream.

The stash feature is enabled by default on HIP09.

Fixes: f93c39bc9547 ("RDMA/hns: Add support for QP stash")
Fixes: bfefae9f108d ("RDMA/hns: Add support for CQ stash")
Link: https://lore.kernel.org/r/1629539607-33217-3-git-send-email-liangwenpeng@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2004,6 +2004,7 @@ static void set_default_caps(struct hns_
 	caps->gid_table_len[0] = HNS_ROCE_V2_GID_INDEX_NUM;
 
 	if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09) {
+		caps->flags |= HNS_ROCE_CAP_FLAG_STASH;
 		caps->max_sq_inline = HNS_ROCE_V3_MAX_SQ_INLINE;
 	} else {
 		caps->max_sq_inline = HNS_ROCE_V2_MAX_SQ_INLINE;


