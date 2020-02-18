Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE58163280
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgBRUHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgBRT7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C3E24655;
        Tue, 18 Feb 2020 19:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055961;
        bh=6DlsMtUAQvpGL98hwpqKAjqCQIqpEYmenz0309Qh9LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcTBMtq4vx2CwZ5/Rwe20tSIwbyNnR4CSneyINUhh2Xjyg+9mzgX5KXZHI6+24Nps
         eXeokfxO3SwiOUCKxJRuv5EtImQ8KiBqDlSPoZ0CLQzIOBYuJywpFOuiVgiTRpeLbn
         y13+uf4XZFp6fcvfOP2YrzAXF+YcKH5zTE1r6gWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 46/66] RDMA/hfi1: Fix memory leak in _dev_comp_vect_mappings_create
Date:   Tue, 18 Feb 2020 20:55:13 +0100
Message-Id: <20200218190432.267767795@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

commit 8a4f300b978edbbaa73ef9eca660e45eb9f13873 upstream.

Make sure to free the allocated cpumask_var_t's to avoid the following
reported memory leak by kmemleak:

$ cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff8897f812d6a8 (size 8):
  comm "kworker/1:1", pid 347, jiffies 4294751400 (age 101.703s)
  hex dump (first 8 bytes):
    00 00 00 00 00 00 00 00                          ........
  backtrace:
    [<00000000bff49664>] alloc_cpumask_var_node+0x4c/0xb0
    [<0000000075d3ca81>] hfi1_comp_vectors_set_up+0x20f/0x800 [hfi1]
    [<0000000098d420df>] hfi1_init_dd+0x3311/0x4960 [hfi1]
    [<0000000071be7e52>] init_one+0x25e/0xf10 [hfi1]
    [<000000005483d4c2>] local_pci_probe+0xd4/0x180
    [<000000007c3cbc6e>] work_for_cpu_fn+0x51/0xa0
    [<000000001d626905>] process_one_work+0x8f0/0x17b0
    [<000000007e569e7e>] worker_thread+0x536/0xb50
    [<00000000fd39a4a5>] kthread+0x30c/0x3d0
    [<0000000056f2edb3>] ret_from_fork+0x3a/0x50

Fixes: 5d18ee67d4c1 ("IB/{hfi1, rdmavt, qib}: Implement CQ completion vector support")
Link: https://lore.kernel.org/r/20200205110530.12129-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/affinity.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -479,6 +479,8 @@ static int _dev_comp_vect_mappings_creat
 			  rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), i, cpu);
 	}
 
+	free_cpumask_var(available_cpus);
+	free_cpumask_var(non_intr_cpus);
 	return 0;
 
 fail:


