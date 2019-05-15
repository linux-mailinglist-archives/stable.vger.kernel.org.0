Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9BA1EF84
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbfEOLbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfEOLbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75DB3206BF;
        Wed, 15 May 2019 11:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919891;
        bh=GtcRU5ZM3n54XN/gJfZc+nyZGktY5oRZUcZIHhUpe/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybvuPSvLRTCdwFv37PFCliD7qsfDQ+UHiWhu+YXKstqcGXIvUtzzokV6yvdK9cwqp
         1Q6fSNw1dFxTrazu/jNCKE63HEY7Fra9kRSa6zCXQy2v0cfVDCsfg7IXzHNPIpLGie
         Uzl5Cd4TMuytLpbVlHhIiVZFAChjgY2Q2o4yc+ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 5.0 134/137] PCI: hv: Fix a memory leak in hv_eject_device_work()
Date:   Wed, 15 May 2019 12:56:55 +0200
Message-Id: <20190515090703.600457250@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 05f151a73ec2b23ffbff706e5203e729a995cdc2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pci-hyperv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1905,6 +1905,9 @@ static void hv_eject_device_work(struct
 			 sizeof(*ejct_pkt), (unsigned long)&ctxt.pkt,
 			 VM_PKT_DATA_INBAND, 0);
 
+	/* For the get_pcichild() in hv_pci_eject_device() */
+	put_pcichild(hpdev);
+	/* For the two refs got in new_pcichild_device() */
 	put_pcichild(hpdev);
 	put_pcichild(hpdev);
 	put_hvpcibus(hpdev->hbus);


