Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA61262555
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732226AbfGHPPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732222AbfGHPPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A65B21537;
        Mon,  8 Jul 2019 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598901;
        bh=IxxySg1yCqqlXUhAPt4pBwO5CcBTwYIjbIIQY49yvi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svzstEDZdV7rNx0Hfoef8V3Uc3nzP623+JA//s63IWqfiFFmlYcT828ZYft6ZBWq0
         r45W218qkkAFjDk2wZhYgojNM8b7S8oZW7SZ/qZB5N4xFRI5JMFEbFkMlztq7qSVLG
         ngoWvLbD4VGYFf26zCn9+truM3SWY6BfRosDQMTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/73] IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
Date:   Mon,  8 Jul 2019 17:12:21 +0200
Message-Id: <20190708150519.358300280@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6d517353c70bb0818b691ca003afdcb5ee5ea44e ]

By code inspection, the freeze_work is never canceled.

Fix by adding a cancel_work_sync in the shutdown path to insure it is no
longer running.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rdma/hfi1/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e48981994b10..e1531feb6c5d 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5906,6 +5906,7 @@ void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
 
 	/* disable the port */
 	clear_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+	cancel_work_sync(&ppd->freeze_work);
 }
 
 static inline int init_cpu_counters(struct hfi1_devdata *dd)
-- 
2.20.1



