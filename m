Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84638157836
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgBJMj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729565AbgBJMjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:55 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273DC24687;
        Mon, 10 Feb 2020 12:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338395;
        bh=YXX6cR3x+e3G80K+lLm7f6Fy3Ra2rdoWEb/mknS6CgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6P37LGgJR45pzglWA4rBDOeeb4+Ee4KUGCkxDoPP5uqx+EyTqdszpA1JQA1puOI8
         K0LaL7DJ3yo0Tat62s32XrsJE5TTyiS1FQEoiN/zQV4FFerqvtFVxauhSpoNx3xigq
         qNTSLY7SmybVDMSs5XmRIVhyOLw/cpn5jGfezhY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.5 089/367] PCI/ATS: Use PF PASID for VFs
Date:   Mon, 10 Feb 2020 04:30:02 -0800
Message-Id: <20200210122432.584539528@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

commit 2e34673be0bd6bb0c6c496a861cbc3f7431e7ce3 upstream.

Per PCIe r5.0, sec 9.3.7.14, if a PF implements the PASID Capability, the
PF PASID configuration is shared by its VFs, and VFs must not implement
their own PASID Capability.  But commit 751035b8dc06 ("PCI/ATS: Cache PASID
Capability offset") changed pci_max_pasids() and pci_pasid_features() to
use the PASID Capability of the VF device instead of the associated PF
device.  This leads to IOMMU bind failures when pci_max_pasids() and
pci_pasid_features() are called for VFs.

In pci_max_pasids() and pci_pasid_features(), always use the PF PASID
Capability.

Fixes: 751035b8dc06 ("PCI/ATS: Cache PASID Capability offset")
Link: https://lore.kernel.org/r/fe891f9755cb18349389609e7fed9940fc5b081a.1580325170.git.sathyanarayanan.kuppuswamy@linux.intel.com
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: stable@vger.kernel.org	# v5.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/ats.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -424,11 +424,12 @@ void pci_restore_pasid_state(struct pci_
 int pci_pasid_features(struct pci_dev *pdev)
 {
 	u16 supported;
-	int pasid = pdev->pasid_cap;
+	int pasid;
 
 	if (pdev->is_virtfn)
 		pdev = pci_physfn(pdev);
 
+	pasid = pdev->pasid_cap;
 	if (!pasid)
 		return -EINVAL;
 
@@ -451,11 +452,12 @@ int pci_pasid_features(struct pci_dev *p
 int pci_max_pasids(struct pci_dev *pdev)
 {
 	u16 supported;
-	int pasid = pdev->pasid_cap;
+	int pasid;
 
 	if (pdev->is_virtfn)
 		pdev = pci_physfn(pdev);
 
+	pasid = pdev->pasid_cap;
 	if (!pasid)
 		return -EINVAL;
 


