Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2CE261BB8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbgIHTIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731253AbgIHQG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:06:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48BA723E1C;
        Tue,  8 Sep 2020 15:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580004;
        bh=J4CaTd7Li/OR/Dm2Ko/DItTSRlT5z2EhpUFE1LseStI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEFRBpR5tWF7bCeqOcj0A1gSvXr2RNCxyOjmCr4cyLDz+NYkvQCZSIISvptHSWJrd
         U/Y1EZjAHb4tFDt+bqgrreYemvPRbOCfr09/xBQVEsO4X4D7zDlMtIkGwwsh9iXB9Q
         l4FtjnaKlZcx+gBx1+rA7QzrFZUeMNRRgCXAPoq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 122/129] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
Date:   Tue,  8 Sep 2020 17:26:03 +0200
Message-Id: <20200908152235.948324566@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit ebfa440ce38b7e2e04c3124aa89c8a9f4094cf21 upstream.

SR-IOV VFs do not implement the memory enable bit of the command
register, therefore this bit is not set in config space after
pci_enable_device().  This leads to an unintended difference
between PF and VF in hand-off state to the user.  We can correct
this by setting the initial value of the memory enable bit in our
virtualized config space.  There's really no need however to
ever fault a user on a VF though as this would only indicate an
error in the user's management of the enable bit, versus a PF
where the same access could trigger hardware faults.

Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/pci/vfio_pci_config.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -398,9 +398,15 @@ static inline void p_setd(struct perm_bi
 /* Caller should hold memory_lock semaphore */
 bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
 {
+	struct pci_dev *pdev = vdev->pdev;
 	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 
-	return cmd & PCI_COMMAND_MEMORY;
+	/*
+	 * SR-IOV VF memory enable is handled by the MSE bit in the
+	 * PF SR-IOV capability, there's therefore no need to trigger
+	 * faults based on the virtual value.
+	 */
+	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
 }
 
 /*
@@ -1726,6 +1732,15 @@ int vfio_config_init(struct vfio_pci_dev
 				 vconfig[PCI_INTERRUPT_PIN]);
 
 		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
+
+		/*
+		 * VFs do no implement the memory enable bit of the COMMAND
+		 * register therefore we'll not have it set in our initial
+		 * copy of config space after pci_enable_device().  For
+		 * consistency with PFs, set the virtual enable bit here.
+		 */
+		*(__le16 *)&vconfig[PCI_COMMAND] |=
+					cpu_to_le16(PCI_COMMAND_MEMORY);
 	}
 
 	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)


