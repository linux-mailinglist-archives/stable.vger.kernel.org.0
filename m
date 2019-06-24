Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA61A506C5
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfFXKBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbfFXJ6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:58:09 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B87FE208CA;
        Mon, 24 Jun 2019 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370288;
        bh=fZy+owkQ5DaOdc0dKydq3l2GUL2bV94BCin+fLxZW88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n93NU2bp71BnSDvVPa8Rlc0VEFWaLwSEWCQjFJJ9P0WEFiRQVEe+zC0ie7Cfzq5mn
         7mmJfUghRBVy1UOuxsxf1HIJRTpUrExN3z5oXgoVQ79ZmDmMV7TcgytRZ9MQ2xHXli
         5Fd/om31o6Vx72+XIgGJ/iAGjsIC/He70IYsro0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/51] IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
Date:   Mon, 24 Jun 2019 17:56:36 +0800
Message-Id: <20190624092308.365340411@linuxfoundation.org>
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
index db33ad985a12..69a79fdfa23e 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9823,6 +9823,7 @@ void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
 
 	/* disable the port */
 	clear_rcvctrl(dd, RCV_CTRL_RCV_PORT_ENABLE_SMASK);
+	cancel_work_sync(&ppd->freeze_work);
 }
 
 static inline int init_cpu_counters(struct hfi1_devdata *dd)
-- 
2.20.1



