Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC367328D84
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbhCATMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241079AbhCATID (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:08:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC33651EE;
        Mon,  1 Mar 2021 17:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619191;
        bh=WtIXoASjy4g1xAjEoGOnnv30xwffeE9ag5+Uci8/37U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FS+dyzscwKzMnogllJ3KU3iWCFeSYPL2buItrjWwHCZjEsCLUSGW1tHyo2XiHkUzv
         Wt8Hb8kwEtX7qUM2b0j0kVgZoSkfsePuxg9Q/lPRAZhbS2e3WKwvu12SxBH0wyTkjm
         k5MFuZWQyH36CEDDo7x0adw/gAYsZF7KhmCWtd10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/663] RDMA/hns: Fix type of sq_signal_bits
Date:   Mon,  1 Mar 2021 17:10:06 +0100
Message-Id: <20210301161159.567933398@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 1ea87f92aabbe..d9aa7424d2902 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -632,7 +632,7 @@ struct hns_roce_qp {
 	struct hns_roce_db	sdb;
 	unsigned long		en_flags;
 	u32			doorbell_qpn;
-	u32			sq_signal_bits;
+	enum ib_sig_type	sq_signal_bits;
 	struct hns_roce_wq	sq;
 
 	struct hns_roce_mtr	mtr;
-- 
2.27.0



