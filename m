Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05065237A0
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387699AbfETMwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730819AbfETMSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:18:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA1E5208C3;
        Mon, 20 May 2019 12:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354711;
        bh=g+JruYIfqgO+BWwlMhcvFwYfPn/bYDmBg8KUOWPJY0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQBg8SsLq9XnMbpX5rzaeX/1XhunP+0QEyVP/8WbnoM6dVwA9XZQ7i9QoMnlyJsoR
         Uwrvnfv40Gbv0G6EZHpzFbK6M+in6cVf1y/muZQC5nePyMgalmhxJgs8jSsU9sIgf7
         xBxtGtkZVq5SP+5dL3Db3NXFnB+eCB2WvP+NLJmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/63] PCI: hv: Fix a memory leak in hv_eject_device_work()
Date:   Mon, 20 May 2019 14:13:42 +0200
Message-Id: <20190520115231.555170179@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 05f151a73ec2b23ffbff706e5203e729a995cdc2 ]

When a device is created in new_pcichild_device(), hpdev->refs is set
to 2 (i.e. the initial value of 1 plus the get_pcichild()).

When we hot remove the device from the host, in a Linux VM we first call
hv_pci_eject_device(), which increases hpdev->refs by get_pcichild() and
then schedules a work of hv_eject_device_work(), so hpdev->refs becomes
3 (let's ignore the paired get/put_pcichild() in other places). But in
hv_eject_device_work(), currently we only call put_pcichild() twice,
meaning the 'hpdev' struct can't be freed in put_pcichild().

Add one put_pcichild() to fix the memory leak.

The device can also be removed when we run "rmmod pci-hyperv". On this
path (hv_pci_remove() -> hv_pci_bus_exit() -> hv_pci_devices_present()),
hpdev->refs is 2, and we do correctly call put_pcichild() twice in
pci_devices_present_work().

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
[lorenzo.pieralisi@arm.com: commit log rework]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pci-hyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
index 53d1c08cef4dc..292450c7da625 100644
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -1941,6 +1941,7 @@ static void hv_eject_device_work(struct work_struct *work)
 			 VM_PKT_DATA_INBAND, 0);
 
 	put_pcichild(hpdev, hv_pcidev_ref_childlist);
+	put_pcichild(hpdev, hv_pcidev_ref_initial);
 	put_pcichild(hpdev, hv_pcidev_ref_pnp);
 	put_hvpcibus(hpdev->hbus);
 }
-- 
2.20.1



