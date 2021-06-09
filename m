Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BD43A0F14
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbhFII6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233708AbhFII6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:58:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E47161040;
        Wed,  9 Jun 2021 08:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623228984;
        bh=AfjJFle9xEB/XAYfK0N+mLEV6qJViK7E6j6C4cPyNM4=;
        h=Subject:To:From:Date:From;
        b=N0PPb1c4Dq851B60GMXZ3/UQCRp/9pr9GKLKj8RsSNrzHlbI3ePET8e1QV7T6Cbk1
         KY/ieNCyFhJ18XhAkWxhWVUc3aijNFPNDAsm+ULXqMesH78Xuvjw6G6wzRLMIVGdP+
         mtAtEYQPbr6zNdbv+kbuBlrM9JJvB8eO7z3siL/o=
Subject: patch "usb: typec: intel_pmc_mux: Put fwnode in error case during ->probe()" added to usb-linus
To:     andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 10:56:22 +0200
Message-ID: <16232289822310@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: intel_pmc_mux: Put fwnode in error case during ->probe()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1a85b350a7741776a406005b943e3dec02c424ed Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 7 Jun 2021 23:50:05 +0300
Subject: usb: typec: intel_pmc_mux: Put fwnode in error case during ->probe()

device_get_next_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: 6701adfa9693 ("usb: typec: driver for Intel PMC mux control")
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210607205007.71458-1-andy.shevchenko@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 46a25b8db72e..96d8c5a04680 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -636,8 +636,10 @@ static int pmc_usb_probe(struct platform_device *pdev)
 			break;
 
 		ret = pmc_usb_register_port(pmc, i, fwnode);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			goto err_remove_ports;
+		}
 	}
 
 	platform_set_drvdata(pdev, pmc);
-- 
2.32.0


