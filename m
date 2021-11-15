Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315844522E7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345065AbhKPBQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244805AbhKOTRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E78B63421;
        Mon, 15 Nov 2021 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000642;
        bh=9gjOBNv0Ncuny4uU9Xw/pTuX/OSEYyHxcP3HP3USgYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3BYuR86M6JhrJGzLsbewPYLOivt93rwt9eRKOT4fcfGBOfot6pSVrSaJ87TiU1jr
         GhxrU0+JGWr5AeoWELfAU6qJEGVGGVXaLJ1z47+OaTfcam26JPGGwGtEa/OEE47ww/
         jgEdJYf/ZuqlvnUMYWORrIxT2d1P6jMvDoPBHors=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 736/849] PCI: Do not enable AtomicOps on VFs
Date:   Mon, 15 Nov 2021 18:03:39 +0100
Message-Id: <20211115165445.144505430@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index a4eb0c042ca3e..e1de19fad9875 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3709,6 +3709,14 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
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



