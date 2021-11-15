Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D696451E42
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344010AbhKPAfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344776AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50185632BB;
        Mon, 15 Nov 2021 19:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003042;
        bh=Za4I7HrQYTzxsOoAXjDn67if9utOMtF6yh1X6233+2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=araUINmaU/q/Fjnog7CQygooIrr8d0/CqgM/CDyWS93cnSAtsaDkVp0CMaUbnj0+U
         QdCxR/tA4heVl4jE+DU/oXPb6s5c+1tqseKXYov0XIdkBzJD7mCWpYGF3u9Q4sAThd
         KgjsdS1wp4/qiAREy96QTx8iZxPznJh1AqDDDUa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 790/917] PCI: Do not enable AtomicOps on VFs
Date:   Mon, 15 Nov 2021 18:04:45 +0100
Message-Id: <20211115165455.748687431@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 5ec0a6fcb60ea430f8ee7e0bec22db9b22f856d3 ]

Host crashes when pci_enable_atomic_ops_to_root() is called for VFs with
virtual buses. The virtual buses added to SR-IOV have bus->self set to NULL
and host crashes due to this.

  PID: 4481   TASK: ffff89c6941b0000  CPU: 53  COMMAND: "bash"
  ...
   #3 [ffff9a9481713808] oops_end at ffffffffb9025cd6
   #4 [ffff9a9481713828] page_fault_oops at ffffffffb906e417
   #5 [ffff9a9481713888] exc_page_fault at ffffffffb9a0ad14
   #6 [ffff9a94817138b0] asm_exc_page_fault at ffffffffb9c00ace
      [exception RIP: pcie_capability_read_dword+28]
      RIP: ffffffffb952fd5c  RSP: ffff9a9481713960  RFLAGS: 00010246
      RAX: 0000000000000001  RBX: ffff89c6b1096000  RCX: 0000000000000000
      RDX: ffff9a9481713990  RSI: 0000000000000024  RDI: 0000000000000000
      RBP: 0000000000000080   R8: 0000000000000008   R9: ffff89c64341a2f8
      R10: 0000000000000002  R11: 0000000000000000  R12: ffff89c648bab000
      R13: 0000000000000000  R14: 0000000000000000  R15: ffff89c648bab0c8
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
   #7 [ffff9a9481713988] pci_enable_atomic_ops_to_root at ffffffffb95359a6
   #8 [ffff9a94817139c0] bnxt_qplib_determine_atomics at ffffffffc08c1a33 [bnxt_re]
   #9 [ffff9a94817139d0] bnxt_re_dev_init at ffffffffc08ba2d1 [bnxt_re]

Per PCIe r5.0, sec 9.3.5.10, the AtomicOp Requester Enable bit in Device
Control 2 is reserved for VFs.  The PF value applies to all associated VFs.

Return -EINVAL if pci_enable_atomic_ops_to_root() is called for a VF.

Link: https://lore.kernel.org/r/1631354585-16597-1-git-send-email-selvin.xavier@broadcom.com
Fixes: 35f5ace5dea4 ("RDMA/bnxt_re: Enable global atomic ops if platform supports")
Fixes: 430a23689dea ("PCI: Add pci_enable_atomic_ops_to_root()")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ce2ab62b64cfa..a101faf3e88a9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3719,6 +3719,14 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
 	struct pci_dev *bridge;
 	u32 cap, ctl2;
 
+	/*
+	 * Per PCIe r5.0, sec 9.3.5.10, the AtomicOp Requester Enable bit
+	 * in Device Control 2 is reserved in VFs and the PF value applies
+	 * to all associated VFs.
+	 */
+	if (dev->is_virtfn)
+		return -EINVAL;
+
 	if (!pci_is_pcie(dev))
 		return -EINVAL;
 
-- 
2.33.0



