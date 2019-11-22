Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10737106D33
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbfKVK6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730773AbfKVK6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8F882071C;
        Fri, 22 Nov 2019 10:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420289;
        bh=MMgzRe5yVk3nwNXkDvps5UuvfqiDrf2kC1LxpPtNu0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lU/8QRCLiWXUC7g7juz6SCd64BVh6m9EfQSWHp8e2TOIRY43QadEtNzh5lq7D6uBJ
         x1+MkE9mymEVIuXyL1Xak1Q22j3g9h/ACldkfEp6tr+FosXDm+Zgwoe2kDWBEgioDm
         QtO6UyMbvcYUQRWifxTzGXA7Pjnrdm682rCCg2tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/220] IB/hfi1: Error path MAD response size is incorrect
Date:   Fri, 22 Nov 2019 11:26:34 +0100
Message-Id: <20191122100914.513996783@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

[ Upstream commit 935c84ac649a147e1aad2c48ee5c5a1a9176b2d0 ]

If a MAD packet has incorrect header information, the logic uses the reply
path to report the error.  The reply path expects *resp_len to be set
prior to return.  Unfortunately, *resp_len is set to 0 for this path.
This causes an incorrect response packet.

Fix by ensuring that the *resp_len is defaulted to the incoming packet
size (wc->bytes_len - sizeof(GRH)).

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/mad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index f208a25d0e4f5..1669548e91dcf 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015-2017 Intel Corporation.
+ * Copyright(c) 2015-2018 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -4829,7 +4829,7 @@ static int hfi1_process_opa_mad(struct ib_device *ibdev, int mad_flags,
 	int ret;
 	int pkey_idx;
 	int local_mad = 0;
-	u32 resp_len = 0;
+	u32 resp_len = in_wc->byte_len - sizeof(*in_grh);
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 
 	pkey_idx = hfi1_lookup_pkey_idx(ibp, LIM_MGMT_P_KEY);
-- 
2.20.1



