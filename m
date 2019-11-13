Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43ABDFA642
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfKMBup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbfKMBup (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6F84222CA;
        Wed, 13 Nov 2019 01:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609844;
        bh=sOL8EgzU9/OBwUH+N3HrECg+l5C283/vV+tqbgXJvbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gs7UHoT6NxbXvVZPRp+VxdVqRDlZXBc0wDGOlXRkVBljKktAYEYynU6hfLPk+LR0M
         gLsY/KAI/lmh6umCfFoZRw4Jaa17sh8C8+O1Gua2ZUYXyPZyyL3JNixKN4UT7mQApU
         0nWDixKNLh+R6fnCArO3b6Pkh9mHNUGCdOXIyU24=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 016/209] IB/hfi1: Error path MAD response size is incorrect
Date:   Tue, 12 Nov 2019 20:47:12 -0500
Message-Id: <20191113015025.9685-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michael J. Ruhl" <michael.j.ruhl@intel.com>

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

