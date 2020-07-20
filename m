Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47E622675B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbgGTQLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387721AbgGTQK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6BB20684;
        Mon, 20 Jul 2020 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261456;
        bh=epSn6X67jXL7DK+sef6AUsbKfE/5ksNrra+ChpvgqGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2npfzQeMmWNAs3jsithgc1l3iaq7XSzwZvaBV6KrcQelDeqf3e0UgvTzZCn3kaHG
         aAYMmH4adtbG6bhKDphlBdPndZYeRIoMLfRJlzIcreY1yCWiYZRuGT4R0UL1ruwNdV
         NiFpLwD96dcsXl1nbRgfrR/6revpe3kzxWJpOx6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjunz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.7 123/244] RDMA/rxe: Set default vendor ID
Date:   Mon, 20 Jul 2020 17:36:34 +0200
Message-Id: <20200720152831.687617727@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

commit 0184afd15a141d7ce24c32c0d86a1e3ba6bc0eb3 upstream.

The RXE driver doesn't set vendor_id and user space applications see
zeros. This causes to pyverbs tests to fail with the following traceback,
because the expectation is to have valid vendor_id.

Traceback (most recent call last):
  File "tests/test_device.py", line 51, in test_query_device
    self.verify_device_attr(attr)
  File "tests/test_device.py", line 77, in verify_device_attr
    assert attr.vendor_id != 0

In order to fix it, we will set vendor_id 0XFFFFFF, according to the IBTA
v1.4 A3.3.1 VENDOR INFORMATION section.

"""
A vendor that produces a generic controller (i.e., one that supports a
standard I/O protocol such as SRP), which does not have vendor specific
device drivers, may use the value of 0xFFFFFF in the VendorID field.
"""

Before:

hca_id: rxe0
        transport:                      InfiniBand (0)
        fw_ver:                         0.0.0
        node_guid:                      5054:00ff:feaa:5363
        sys_image_guid:                 5054:00ff:feaa:5363
        vendor_id:                      0x0000

After:

hca_id: rxe0
        transport:                      InfiniBand (0)
        fw_ver:                         0.0.0
        node_guid:                      5054:00ff:feaa:5363
        sys_image_guid:                 5054:00ff:feaa:5363
        vendor_id:                      0xffffff

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200406173501.1466273-1-leon@kernel.org
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/rxe/rxe.c       |    1 +
 drivers/infiniband/sw/rxe/rxe_param.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -77,6 +77,7 @@ static void rxe_init_device_param(struct
 {
 	rxe->max_inline_data			= RXE_MAX_INLINE_DATA;
 
+	rxe->attr.vendor_id			= RXE_VENDOR_ID;
 	rxe->attr.max_mr_size			= RXE_MAX_MR_SIZE;
 	rxe->attr.page_size_cap			= RXE_PAGE_SIZE_CAP;
 	rxe->attr.max_qp			= RXE_MAX_QP;
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -127,6 +127,9 @@ enum rxe_device_param {
 
 	/* Delay before calling arbiter timer */
 	RXE_NSEC_ARB_TIMER_DELAY	= 200,
+
+	/* IBTA v1.4 A3.3.1 VENDOR INFORMATION section */
+	RXE_VENDOR_ID			= 0XFFFFFF,
 };
 
 /* default/initial rxe port parameters */


