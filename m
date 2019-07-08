Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7221624F6
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733069AbfGHPSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733078AbfGHPSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:18:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75300216C4;
        Mon,  8 Jul 2019 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599118;
        bh=8/lC03YzkHQ4B9GbuL6zUCR4C63sNd7RPqB15Ylpnlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyOUNZ+ezlaq+mZFUIz9wQ501GkYg/zK7IW/51hpUNhR3EupLeInXRMWfyAX1xH2H
         tu/FjOXckYy9UpIfvADenamNZ4Oau0jv2pzR8MuM6pj8fWA5EY9eU1w1niIHLt+hyJ
         fyfPKolAsdq6ve/dNrN4GlpzLHQTebMb5WG/gLBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 012/102] IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
Date:   Mon,  8 Jul 2019 17:12:05 +0200
Message-Id: <20190708150526.713423359@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
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
 drivers/infiniband/hw/hfi1/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index d30b3b908621..85db856047a9 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9620,6 +9620,7 @@ void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
 
 	/* disable the port */
 	clear_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+	cancel_work_sync(&ppd->freeze_work);
 }
 
 static inline int init_cpu_counters(struct hfi1_devdata *dd)
-- 
2.20.1



