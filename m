Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403B97F2C2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405319AbfHBJo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403954AbfHBJo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:44:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CABB21726;
        Fri,  2 Aug 2019 09:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739095;
        bh=6wl/sh3c5xisdjPWXnVAYZ+Biy68tXVcGJNcha7fBhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4ptJZ2Y4OflcinpNCMIAkwLsIJYFnTSTl/Uv9M2DcSfwuEr9yfaOpp566eJk8IPx
         dkH2azpcWq+OXdtmRHd4Cd8Q65VPmtnSBtwlp6SQqfbaIa/3pJ7W/maGFYCt4Ky+/e
         aykntjWbAi83Cq8ZkDUp/bFYOSjaenmQWjWOdSgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 4.9 111/223] PCI: hv: Delete the device earlier from hbus->children for hot-remove
Date:   Fri,  2 Aug 2019 11:35:36 +0200
Message-Id: <20190802092246.437519832@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit e74d2ebdda33b3bdd1826b5b92e9aa45bdf92bb3 upstream.

After we send a PCI_EJECTION_COMPLETE message to the host, the host will
immediately send us a PCI_BUS_RELATIONS message with
relations->device_count == 0, so pci_devices_present_work(), running on
another thread, can find the being-ejected device, mark the
hpdev->reported_missing to true, and run list_move_tail()/list_del() for
the device -- this races hv_eject_device_work() -> list_del().

Move the list_del() in hv_eject_device_work() to an earlier place, i.e.,
before we send PCI_EJECTION_COMPLETE, so later the
pci_devices_present_work() can't see the device.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jake Oshins <jakeo@microsoft.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pci-hyperv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -1607,6 +1607,10 @@ static void hv_eject_device_work(struct
 		pci_unlock_rescan_remove();
 	}
 
+	spin_lock_irqsave(&hpdev->hbus->device_list_lock, flags);
+	list_del(&hpdev->list_entry);
+	spin_unlock_irqrestore(&hpdev->hbus->device_list_lock, flags);
+
 	memset(&ctxt, 0, sizeof(ctxt));
 	ejct_pkt = (struct pci_eject_response *)&ctxt.pkt.message;
 	ejct_pkt->message_type.type = PCI_EJECTION_COMPLETE;
@@ -1615,10 +1619,6 @@ static void hv_eject_device_work(struct
 			 sizeof(*ejct_pkt), (unsigned long)&ctxt.pkt,
 			 VM_PKT_DATA_INBAND, 0);
 
-	spin_lock_irqsave(&hpdev->hbus->device_list_lock, flags);
-	list_del(&hpdev->list_entry);
-	spin_unlock_irqrestore(&hpdev->hbus->device_list_lock, flags);
-
 	put_pcichild(hpdev, hv_pcidev_ref_childlist);
 	put_pcichild(hpdev, hv_pcidev_ref_initial);
 	put_pcichild(hpdev, hv_pcidev_ref_pnp);


