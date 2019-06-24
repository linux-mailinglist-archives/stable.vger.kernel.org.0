Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605FD506C2
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfFXJ6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbfFXJ6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:58:17 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4AB021530;
        Mon, 24 Jun 2019 09:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370296;
        bh=TSnBK+TOK1j2SbjEs6KEX4gUZT3ktGaHfgONdzdZuWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2OHTj4FO9f0agH9rs+pm2/tMHE1L+uGRkSHHQKg7HMGMzVYaaGyRvfU7xjYtafAs
         JTTzDCa39dDHIsevVgqWZXzRZ7+J1HSxLNz7CRb4ZTUxNtXM5b3dTGnB/gDpw1V1Ev
         FySutypTpLLruuhpwfK8LD9cC70iBRq3tkw+kvIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Kamenee Arumugam <kamenee.arumugam@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/51] IB/hfi1: Validate page aligned for a given virtual address
Date:   Mon, 24 Jun 2019 17:56:38 +0800
Message-Id: <20190624092308.572253031@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 97736f36dbebf2cda2799db3b54717ba5b388255 ]

User applications can register memory regions for TID buffers that are not
aligned on page boundaries. Hfi1 is expected to pin those pages in memory
and cache the pages with mmu_rb. The rb tree will fail to insert pages
that are not aligned correctly.

Validate whether a given virtual address is page aligned before pinning.

Fixes: 7e7a436ecb6e ("staging/hfi1: Add TID entry program function body")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 6f6c14df383e..b38e3808836c 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -324,6 +324,9 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	u32 *tidlist = NULL;
 	struct tid_user_buf *tidbuf;
 
+	if (!PAGE_ALIGNED(tinfo->vaddr))
+		return -EINVAL;
+
 	tidbuf = kzalloc(sizeof(*tidbuf), GFP_KERNEL);
 	if (!tidbuf)
 		return -ENOMEM;
-- 
2.20.1



