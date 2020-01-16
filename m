Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC34713FD29
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390926AbgAPXWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390922AbgAPXWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7BF12075B;
        Thu, 16 Jan 2020 23:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216959;
        bh=gGRnE5dBgdzdbfIbb+0EIUL/pJhprnpnZSfjDCTXL0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEQOMcLRCljT5q9akWMJX5AanLJEGoduNpX7amA+LRtjme0v5oytJUmtean2HIgjT
         mBVkRivfHAY4FAMnfyA9us2UjmcZt8wZfOCmMT+j0s7e/vvmT4ryY+bQCVE/LcBsm4
         EdFJJxtMaNk/CYRZyAP1RrlqlVzjtskTRV+cuYtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 074/203] rdma: Remove nes ABI header
Date:   Fri, 17 Jan 2020 00:16:31 +0100
Message-Id: <20200116231750.634420150@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 949b452f9cfef17e78055239f978d95ba729eee1 upstream.

This was missed when nes was removed.

Fixes: 2d3c72ed5041 ("rdma: Remove nes")
Link: https://lore.kernel.org/r/20191024135059.GA20084@ziepe.ca
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/rdma/nes-abi.h |  115 --------------------------------------------
 1 file changed, 115 deletions(-)

--- a/include/uapi/rdma/nes-abi.h
+++ /dev/null
@@ -1,115 +0,0 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
-/*
- * Copyright (c) 2006 - 2011 Intel Corporation.  All rights reserved.
- * Copyright (c) 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Cisco Systems.  All rights reserved.
- * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#ifndef NES_ABI_USER_H
-#define NES_ABI_USER_H
-
-#include <linux/types.h>
-
-#define NES_ABI_USERSPACE_VER 2
-#define NES_ABI_KERNEL_VER    2
-
-/*
- * Make sure that all structs defined in this file remain laid out so
- * that they pack the same way on 32-bit and 64-bit architectures (to
- * avoid incompatibility between 32-bit userspace and 64-bit kernels).
- * In particular do not use pointer types -- pass pointers in __u64
- * instead.
- */
-
-struct nes_alloc_ucontext_req {
-	__u32 reserved32;
-	__u8  userspace_ver;
-	__u8  reserved8[3];
-};
-
-struct nes_alloc_ucontext_resp {
-	__u32 max_pds; /* maximum pds allowed for this user process */
-	__u32 max_qps; /* maximum qps allowed for this user process */
-	__u32 wq_size; /* size of the WQs (sq+rq) allocated to the mmaped area */
-	__u8  virtwq;  /* flag to indicate if virtual WQ are to be used or not */
-	__u8  kernel_ver;
-	__u8  reserved[2];
-};
-
-struct nes_alloc_pd_resp {
-	__u32 pd_id;
-	__u32 mmap_db_index;
-};
-
-struct nes_create_cq_req {
-	__aligned_u64 user_cq_buffer;
-	__u32 mcrqf;
-	__u8 reserved[4];
-};
-
-struct nes_create_qp_req {
-	__aligned_u64 user_wqe_buffers;
-	__aligned_u64 user_qp_buffer;
-};
-
-enum iwnes_memreg_type {
-	IWNES_MEMREG_TYPE_MEM = 0x0000,
-	IWNES_MEMREG_TYPE_QP = 0x0001,
-	IWNES_MEMREG_TYPE_CQ = 0x0002,
-	IWNES_MEMREG_TYPE_MW = 0x0003,
-	IWNES_MEMREG_TYPE_FMR = 0x0004,
-	IWNES_MEMREG_TYPE_FMEM = 0x0005,
-};
-
-struct nes_mem_reg_req {
-	__u32 reg_type;	/* indicates if id is memory, QP or CQ */
-	__u32 reserved;
-};
-
-struct nes_create_cq_resp {
-	__u32 cq_id;
-	__u32 cq_size;
-	__u32 mmap_db_index;
-	__u32 reserved;
-};
-
-struct nes_create_qp_resp {
-	__u32 qp_id;
-	__u32 actual_sq_size;
-	__u32 actual_rq_size;
-	__u32 mmap_sq_db_index;
-	__u32 mmap_rq_db_index;
-	__u32 nes_drv_opt;
-};
-
-#endif	/* NES_ABI_USER_H */


