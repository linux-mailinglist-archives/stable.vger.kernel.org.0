Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB91F4677C0
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 13:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbhLCNBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 08:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244358AbhLCNBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 08:01:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062CDC06173E
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 04:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C40BAB825B2
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 12:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07916C53FAD;
        Fri,  3 Dec 2021 12:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638536292;
        bh=DtLlkkmX/1lcUmy0oTLzXco4fms8V86Y73N3sRIjwBs=;
        h=Subject:To:From:Date:From;
        b=tBl0q5BeDuhqB6WNP8G0j3BQ/t95xG4WT7yPIlBfnuP+KAPoWCM1xypvG0nDwU5zX
         AXi9IlKtbKpCBcf/FyG2JMvxxnNbRjFl4S2qGiYfe89d0fhgUNe6G9KVOgdJ8MUEUG
         Ky6cQOT1Ne9Yws9sfuZy/sJCJo6GOYyRCPvwt3PU=
Subject: patch "usb: cdnsp: Fix a NULL pointer dereference in cdnsp_endpoint_init()" added to usb-linus
To:     zhou1615@umn.edu, gregkh@linuxfoundation.org, pawell@cadence.com,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Dec 2021 13:58:00 +0100
Message-ID: <163853628052232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fix a NULL pointer dereference in cdnsp_endpoint_init()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 37307f7020ab38dde0892a578249bf63d00bca64 Mon Sep 17 00:00:00 2001
From: Zhou Qingyang <zhou1615@umn.edu>
Date: Wed, 1 Dec 2021 01:27:00 +0800
Subject: usb: cdnsp: Fix a NULL pointer dereference in cdnsp_endpoint_init()

In cdnsp_endpoint_init(), cdnsp_ring_alloc() is assigned to pep->ring
and there is a dereference of it in cdnsp_endpoint_init(), which could
lead to a NULL pointer dereference on failure of cdnsp_ring_alloc().

Fix this bug by adding a check of pep->ring.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_USB_CDNSP_GADGET=y show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@vger.kernel.org>
Acked-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Link: https://lore.kernel.org/r/20211130172700.206650-1-zhou1615@umn.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-mem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/cdns3/cdnsp-mem.c b/drivers/usb/cdns3/cdnsp-mem.c
index ad9aee3f1e39..97866bfb2da9 100644
--- a/drivers/usb/cdns3/cdnsp-mem.c
+++ b/drivers/usb/cdns3/cdnsp-mem.c
@@ -987,6 +987,9 @@ int cdnsp_endpoint_init(struct cdnsp_device *pdev,
 
 	/* Set up the endpoint ring. */
 	pep->ring = cdnsp_ring_alloc(pdev, 2, ring_type, max_packet, mem_flags);
+	if (!pep->ring)
+		return -ENOMEM;
+
 	pep->skip = false;
 
 	/* Fill the endpoint context */
-- 
2.34.1


