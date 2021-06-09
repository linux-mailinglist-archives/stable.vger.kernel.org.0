Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEDD3A0F16
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhFII61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233708AbhFII61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CDCB6101A;
        Wed,  9 Jun 2021 08:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623228992;
        bh=gMH74MiIL1k1cLNfr2SBA9prh+/4AeJGopnc8vc1vY4=;
        h=Subject:To:From:Date:From;
        b=ES3SM0FwGIDru5gOzFuxWRmx3iyZaAeNiP8W7SOBSheymgJ17X2K3Md5hlGMyNksy
         1DIlu12r66oRPpsSl15hsQ1rHAX/D38YjQipHP9n1fH3uKPCzHpUXbZmdRY5+iwGGq
         1BAwVEQRaMB9Rjrb/lR1mXZCU4+n3mmufiwAJd9E=
Subject: patch "usb: typec: intel_pmc_mux: Add missed error check for" added to usb-linus
To:     andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 10:56:22 +0200
Message-ID: <162322898229122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: intel_pmc_mux: Add missed error check for

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 843fabdd7623271330af07f1b7fbd7fabe33c8de Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 7 Jun 2021 23:50:06 +0300
Subject: usb: typec: intel_pmc_mux: Add missed error check for
 devm_ioremap_resource()

devm_ioremap_resource() can return an error, add missed check for it.

Fixes: 43d596e32276 ("usb: typec: intel_pmc_mux: Check the port status before connect")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210607205007.71458-2-andy.shevchenko@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 96d8c5a04680..31b1b3b555c7 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -586,6 +586,11 @@ static int pmc_usb_probe_iom(struct pmc_usb *pmc)
 		return -ENOMEM;
 	}
 
+	if (IS_ERR(pmc->iom_base)) {
+		put_device(&adev->dev);
+		return PTR_ERR(pmc->iom_base);
+	}
+
 	pmc->iom_adev = adev;
 
 	return 0;
-- 
2.32.0


