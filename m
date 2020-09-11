Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B288C2664EA
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgIKQsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgIKPHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:07:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FB78222E9;
        Fri, 11 Sep 2020 12:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829079;
        bh=u1Zx9jpPbW0K5uo9rDG3f74pkx85q+fnLgYX+EDiMTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPEVd0iqYj+m1h+Ry2dF6p3J/UrMv2X+obIbuvx9auo8bxXzz0VI2Z0AFL9qWaKKn
         NvbpdTEZiETuh0yyeVpBVFYWPziIqHNb7Z+1YMke3mSwRG2UOgZRX7+Y3Q8ER1FYne
         X2wAz8yJZ6k3qzbwUE2OFVXcdDfE0VbxPVT+kI60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4.9 58/71] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
Date:   Fri, 11 Sep 2020 14:46:42 +0200
Message-Id: <20200911122507.805999939@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
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
@@ -403,9 +403,15 @@ static inline void p_setd(struct perm_bi
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
@@ -1729,6 +1735,15 @@ int vfio_config_init(struct vfio_pci_dev
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


