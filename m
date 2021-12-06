Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5AD469D4D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356228AbhLFP27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41336 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377915AbhLFPY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD6D6134E;
        Mon,  6 Dec 2021 15:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E63DC341C1;
        Mon,  6 Dec 2021 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804088;
        bh=f8FDVQlSX/kwqMVCs12n3hux8Hv+01Gm08VbV2EG0pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuIEQ3t5ZhjC/l3lXsn4IqtorDfcPYiHgSVlE/Nr/JR8ZCK9hW2GkZRspj9ydb1SQ
         i4QMzZ09Hm+65Q4obezGaG6TthrakaXDB91vR1OG6jSHDH69fy71k1Bq6xHZvEfN4n
         fQnkt95wGdAl4zDlD0ceeBB1QzDl0ujz/aTyMn60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        Zekun Shen <bruceshenzk@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/207] atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait
Date:   Mon,  6 Dec 2021 15:54:36 +0100
Message-Id: <20211206145610.968866168@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit b922f622592af76b57cbc566eaeccda0b31a3496 ]

This bug report shows up when running our research tools. The
reports is SOOB read, but it seems SOOB write is also possible
a few lines below.

In details, fw.len and sw.len are inputs coming from io. A len
over the size of self->rpc triggers SOOB. The patch fixes the
bugs by adding sanity checks.

The bugs are triggerable with compromised/malfunctioning devices.
They are potentially exploitable given they first leak up to
0xffff bytes and able to overwrite the region later.

The patch is tested with QEMU emulater.
This is NOT tested with a real device.

Attached is the log we found by fuzzing.

BUG: KASAN: slab-out-of-bounds in
	hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
Read of size 4 at addr ffff888016260b08 by task modprobe/213
CPU: 0 PID: 213 Comm: modprobe Not tainted 5.6.0 #1
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 __kasan_report.cold+0x37/0x7c
 ? aq_hw_read_reg_bit+0x60/0x70 [atlantic]
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 kasan_report+0xe/0x20
 hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 hw_atl_utils_fw_rpc_call+0x95/0x130 [atlantic]
 hw_atl_utils_fw_rpc_wait+0x176/0x210 [atlantic]
 hw_atl_utils_mpi_create+0x229/0x2e0 [atlantic]
 ? hw_atl_utils_fw_rpc_wait+0x210/0x210 [atlantic]
 ? hw_atl_utils_initfw+0x9f/0x1c8 [atlantic]
 hw_atl_utils_initfw+0x12a/0x1c8 [atlantic]
 aq_nic_ndev_register+0x88/0x650 [atlantic]
 ? aq_nic_ndev_init+0x235/0x3c0 [atlantic]
 aq_pci_probe+0x731/0x9b0 [atlantic]
 ? aq_pci_func_init+0xc0/0xc0 [atlantic]
 local_pci_probe+0xd3/0x160
 pci_device_probe+0x23f/0x3e0

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c   | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 404cbf60d3f2f..da1d185f6d226 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -559,6 +559,11 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 			goto err_exit;
 
 		if (fw.len == 0xFFFFU) {
+			if (sw.len > sizeof(self->rpc)) {
+				printk(KERN_INFO "Invalid sw len: %x\n", sw.len);
+				err = -EINVAL;
+				goto err_exit;
+			}
 			err = hw_atl_utils_fw_rpc_call(self, sw.len);
 			if (err < 0)
 				goto err_exit;
@@ -567,6 +572,11 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 
 	if (rpc) {
 		if (fw.len) {
+			if (fw.len > sizeof(self->rpc)) {
+				printk(KERN_INFO "Invalid fw len: %x\n", fw.len);
+				err = -EINVAL;
+				goto err_exit;
+			}
 			err =
 			hw_atl_utils_fw_downld_dwords(self,
 						      self->rpc_addr,
-- 
2.33.0



