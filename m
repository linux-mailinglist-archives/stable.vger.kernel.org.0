Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32375507A9
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbfFXKIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbfFXKIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:08:50 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF31A2089F;
        Mon, 24 Jun 2019 10:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370929;
        bh=jIlfMerZzWk/pZXDKx+h7+Fdu6ct/+sUeYQ0rQ9U/ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlpEIVD6s13S8Pcz8QCdGsN7UAExAJAV09LiOvkF4K4DIU61C+GQsg1lK6p77k0dW
         WFRvUzYRR5ZrfbEXlrhzcBcfRDsR+t1fsBwPdtU3DOpIottvdYkFUWke5/qXceCpQa
         aiItkwjBH3DlaF6hjd7o6SDUgZYDiDDcKHwLbKqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Kamenee Arumugam <kamenee.arumugam@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 053/121] IB/hfi1: Validate page aligned for a given virtual address
Date:   Mon, 24 Jun 2019 17:56:25 +0800
Message-Id: <20190624092323.432996036@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
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
index 0cd71ce7cc71..3592a9ec155e 100644
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



