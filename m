Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCB93288BD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbhCARnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238875AbhCARjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:39:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F37F1650B8;
        Mon,  1 Mar 2021 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617767;
        bh=h0U7qTnf+fLfgy1KWV6m+xHvf/Qai+xc/rs2KZ2b+zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iihC+kIcB0ScSmBMBv1VzqHKfTORuwk8OK5kwuyfOIJ1bCXY8RVbgB67iMomWvGD
         T+dHJ7X0zll9EDwBhak/N6kx+fqroFsQX/bvs+8NoVIwEBYU+fEXpx2AUahZ2B7xnd
         zwcEi9Ckse+Zchzrjyzafuvgdr3CsISl9uXUrn24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/340] RDMA/hns: Fix type of sq_signal_bits
Date:   Mon,  1 Mar 2021 17:12:13 +0100
Message-Id: <20210301161057.613629515@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit ea4092f3b56b236d08890ea589506ebd76248c53 ]

This bit should be in type of enum ib_sig_type, or there will be a sparse
warning.

Fixes: bfe860351e31 ("RDMA/hns: Fix cast from or to restricted __le32 for driver")
Link: https://lore.kernel.org/r/1612517974-31867-3-git-send-email-liweihang@huawei.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index e36d315690819..3e68ba9dab45d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -657,7 +657,7 @@ struct hns_roce_qp {
 	u8			rdb_en;
 	u8			sdb_en;
 	u32			doorbell_qpn;
-	u32			sq_signal_bits;
+	enum ib_sig_type	sq_signal_bits;
 	struct hns_roce_wq	sq;
 
 	struct ib_umem		*umem;
-- 
2.27.0



