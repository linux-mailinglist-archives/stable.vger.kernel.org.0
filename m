Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F2129B99E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802653AbgJ0Pun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801555AbgJ0Pmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E17D720657;
        Tue, 27 Oct 2020 15:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813363;
        bh=H9n+XaeDssBh4aMeX7Fcvndm3NXzCkWYtp+V389zFRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cp/mUwWExhgNjrxnV4if9EE/Xwyp5sPQkk4NRnSuzaE2gBPTRERWndhUaYxRIg+6s
         zZpMMgD3FDN5QyYkFOPFMpPhGhdSQ+QOPQA7aZlxV+SptL9YXFvgG1FqKJsS3Fq3WN
         oAHD5KT+J/wwHDEFOh69uJo0kz6pWBvPMMw8awGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 526/757] PCI/IOV: Mark VFs as not implementing PCI_COMMAND_MEMORY
Date:   Tue, 27 Oct 2020 14:52:56 +0100
Message-Id: <20201027135515.154720871@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

[ Upstream commit 12856e7acde4702b7c3238c15fcba86ff6aa507f ]

For VFs, the Memory Space Enable bit in the Command Register is
hard-wired to 0.

Add a new bit to signify devices where the Command Register Memory
Space Enable bit does not control the device's response to MMIO
accesses.

Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c   | 1 +
 include/linux/pci.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index b37e08c4f9d1a..4afd4ee4f7f04 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -180,6 +180,7 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 	virtfn->device = iov->vf_device;
 	virtfn->is_virtfn = 1;
 	virtfn->physfn = pci_dev_get(dev);
+	virtfn->no_command_memory = 1;
 
 	if (id == 0)
 		pci_read_vf_config_common(virtfn);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 835530605c0d7..3ff723124ca7f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -445,6 +445,7 @@ struct pci_dev {
 	unsigned int	is_probed:1;		/* Device probing in progress */
 	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
 	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
+	unsigned int	no_command_memory:1;	/* No PCI_COMMAND_MEMORY */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
-- 
2.25.1



