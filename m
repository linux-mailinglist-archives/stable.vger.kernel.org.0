Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECF125DC2C
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgIDOpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730021AbgIDOpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 10:45:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E575206F2;
        Fri,  4 Sep 2020 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599230730;
        bh=JDEF7AsdvzADZWqhPDTug6DhhrjNj+9GyEU/xJmRBcc=;
        h=Subject:To:From:Date:From;
        b=iwXy2WloRjknYfxrtbKGbJs6ZBa5FYhnrvpdEGEJg6U3C/nW4gENSWKYxF7li6Ar0
         hoITagfNhmlUT4OAFlvYhfdaa1jchGC/icwZ21mAsgL4HU0cDKOVbMVVXPiTEO7h5W
         7rnuNi9xQf9MC5pslwicImNk2WYFMtzwxUMO1N3s=
Subject: patch "usb: typec: intel_pmc_mux: Un-register the USB role switch" added to usb-linus
To:     madhusudanarao.amara@intel.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 16:45:47 +0200
Message-ID: <159923074731212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: intel_pmc_mux: Un-register the USB role switch

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 290a405ce318d036666c4155d5899eb8cd6e0d97 Mon Sep 17 00:00:00 2001
From: Madhusudanarao Amara <madhusudanarao.amara@intel.com>
Date: Wed, 26 Aug 2020 00:08:11 +0530
Subject: usb: typec: intel_pmc_mux: Un-register the USB role switch

Added missing code for un-register USB role switch in the remove and
error path.

Cc: Stable <stable@vger.kernel.org> # v5.8
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Fixes: 6701adfa9693b ("usb: typec: driver for Intel PMC mux control")
Signed-off-by: Madhusudanarao Amara <madhusudanarao.amara@intel.com>
Link: https://lore.kernel.org/r/20200825183811.7262-1-madhusudanarao.amara@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index e4021e13af40..fd9008f19208 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -497,6 +497,7 @@ static int pmc_usb_probe(struct platform_device *pdev)
 	for (i = 0; i < pmc->num_ports; i++) {
 		typec_switch_unregister(pmc->port[i].typec_sw);
 		typec_mux_unregister(pmc->port[i].typec_mux);
+		usb_role_switch_unregister(pmc->port[i].usb_sw);
 	}
 
 	return ret;
@@ -510,6 +511,7 @@ static int pmc_usb_remove(struct platform_device *pdev)
 	for (i = 0; i < pmc->num_ports; i++) {
 		typec_switch_unregister(pmc->port[i].typec_sw);
 		typec_mux_unregister(pmc->port[i].typec_mux);
+		usb_role_switch_unregister(pmc->port[i].usb_sw);
 	}
 
 	return 0;
-- 
2.28.0


