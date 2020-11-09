Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A692ABAE2
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbgKINXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387481AbgKINUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C3D520663;
        Mon,  9 Nov 2020 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928048;
        bh=wGp0qCVkWFciBTIMbfHPkFztMdbRDh0g09EpCcra3Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4rZaRl++7t9a/OIn4dNhVJnR+klCKN+CePf8vWb+iuEwpjhFzItvCQfyVQSuHvvz
         2SM3XAUUbsjtVjgI9+YlZCZvtXFlV0t2o0+EuTQEQaIn4TXrHG/8cY0RfzqRPXSbnf
         8nmsc7H0UmesGXSAlwqk31TtPCcY/kfLvMzHc7RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.9 110/133] s390/pci: fix hot-plug of PCI function missing bus
Date:   Mon,  9 Nov 2020 13:56:12 +0100
Message-Id: <20201109125035.979739429@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 0b2ca2c7d0c9e2731d01b6c862375d44a7e13923 upstream.

Under some circumstances in particular with "Reconfigure I/O Path"
a zPCI function may first appear in Standby through a PCI event with
PEC 0x0302 which initially makes it visible to the zPCI subsystem,
Only after that is it configured with a zPCI event  with PEC 0x0301.
If the zbus is still missing a PCI function zero (devfn == 0) when the
PCI event 0x0301 is handled zdev->zbus->bus is still NULL and gets
dereferenced in common code.
Check for this case and enable but don't scan the zPCI function.
This matches what would happen if we immediately got the 0x0301
configuration request or the function was included in CLP List PCI.
In all cases the PCI functions with devfn != 0 will be scanned once
function 0 appears.

Fixes: 3047766bc6ec ("s390/pci: fix enabling a reserved PCI function")
Cc: <stable@vger.kernel.org> # 5.8
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/pci/pci_event.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -101,6 +101,10 @@ static void __zpci_event_availability(st
 		if (ret)
 			break;
 
+		/* the PCI function will be scanned once function 0 appears */
+		if (!zdev->zbus->bus)
+			break;
+
 		pdev = pci_scan_single_device(zdev->zbus->bus, zdev->devfn);
 		if (!pdev)
 			break;


