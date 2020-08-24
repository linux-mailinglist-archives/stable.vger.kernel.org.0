Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F5A24F424
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgHXIdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgHXIdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB24E2075B;
        Mon, 24 Aug 2020 08:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257991;
        bh=3zyVuaLG4n6LYqY9mo4GXGzX3bDo1979MFzeLU8gLmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWkbVR7gzQVgLmV0EGG2clRk7e4iqFkQaUjoL29CaDP3XiJ2odJkAeaoAmYg5WQTD
         QQXpPcNVljF1Isgw/o1ArZ+/ml07nB4nzTqvkyHqReCiYHQLY1ziUqgfF/1aMBVVm2
         0m2oxQng35GD/uufW8LEwNALortRR8QcQ0hpWdO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shalini Chellathurai Saroja <shalini@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.8 034/148] s390/pci: ignore stale configuration request event
Date:   Mon, 24 Aug 2020 10:28:52 +0200
Message-Id: <20200824082415.678255398@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit b76fee1bc56c31a9d2a49592810eba30cc06d61a upstream.

A configuration request event may be stale, that is the event
may reference a zdev which was already configured.
This can happen when a hotplug happens during boot such that
the device is discovered and configured in the initial clp_list_pci(),
then after initialization we enable events and process
the original configuration request which additionally still contains
the old disabled function handle leading to a failure during device
enablement and subsequent I/O lockout.

Fix this by restoring the check that the device to be configured is in
standby which was removed in commit f606b3ef47c9 ("s390/pci: adapt events
for zbus").

This check does not need serialization as we only enable the events after
zPCI has fully initialized, which includes the initial clp_list_pci(),
rescan only does updates and events are serialized with respect to each
other.

Fixes: f606b3ef47c9 ("s390/pci: adapt events for zbus")
Cc: <stable@vger.kernel.org> # 5.8
Reported-by: Shalini Chellathurai Saroja <shalini@linux.ibm.com>
Tested-by: Shalini Chellathurai Saroja <shalini@linux.ibm.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/pci/pci_event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -92,6 +92,9 @@ static void __zpci_event_availability(st
 			ret = clp_add_pci_device(ccdf->fid, ccdf->fh, 1);
 			break;
 		}
+		/* the configuration request may be stale */
+		if (zdev->state != ZPCI_FN_STATE_STANDBY)
+			break;
 		zdev->fh = ccdf->fh;
 		zdev->state = ZPCI_FN_STATE_CONFIGURED;
 		ret = zpci_enable_device(zdev);


