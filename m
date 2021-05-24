Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C75938EDCC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhEXPmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233774AbhEXPkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40E3B61439;
        Mon, 24 May 2021 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870451;
        bh=4y53AlV7J/GunMYGYqM0s5l56bGEUAVQa7NrzwKwNJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fLnwVTMjkw9kNjAWEE86COV4MPrxlk/lQP3X97R0imAYQv3MR6Ix45/jRxXhL4l6
         Zci53QjMGemsyFh05o0H1Q95T90fQYx4VOyjc0tc5+ESp/bVT/+KVJhV0gmWOy4v1w
         i+LHShmJWCNJhvRd1lI04WgpI037Wkp49BMHE6KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 13/37] xen-pciback: reconfigure also from backend watch handler
Date:   Mon, 24 May 2021 17:25:17 +0200
Message-Id: <20210524152324.646191260@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
References: <20210524152324.199089755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit c81d3d24602540f65256f98831d0a25599ea6b87 upstream.

When multiple PCI devices get assigned to a guest right at boot, libxl
incrementally populates the backend tree. The writes for the first of
the devices trigger the backend watch. In turn xen_pcibk_setup_backend()
will set the XenBus state to Initialised, at which point no further
reconfigures would happen unless a device got hotplugged. Arrange for
reconfigure to also get triggered from the backend watch handler.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/2337cbd6-94b9-4187-9862-c03ea12e0c61@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-pciback/xenbus.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -358,7 +358,8 @@ out:
 	return err;
 }
 
-static int xen_pcibk_reconfigure(struct xen_pcibk_device *pdev)
+static int xen_pcibk_reconfigure(struct xen_pcibk_device *pdev,
+				 enum xenbus_state state)
 {
 	int err = 0;
 	int num_devs;
@@ -372,9 +373,7 @@ static int xen_pcibk_reconfigure(struct
 	dev_dbg(&pdev->xdev->dev, "Reconfiguring device ...\n");
 
 	mutex_lock(&pdev->dev_lock);
-	/* Make sure we only reconfigure once */
-	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
-	    XenbusStateReconfiguring)
+	if (xenbus_read_driver_state(pdev->xdev->nodename) != state)
 		goto out;
 
 	err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename, "num_devs", "%d",
@@ -499,6 +498,10 @@ static int xen_pcibk_reconfigure(struct
 		}
 	}
 
+	if (state != XenbusStateReconfiguring)
+		/* Make sure we only reconfigure once. */
+		goto out;
+
 	err = xenbus_switch_state(pdev->xdev, XenbusStateReconfigured);
 	if (err) {
 		xenbus_dev_fatal(pdev->xdev, err,
@@ -524,7 +527,7 @@ static void xen_pcibk_frontend_changed(s
 		break;
 
 	case XenbusStateReconfiguring:
-		xen_pcibk_reconfigure(pdev);
+		xen_pcibk_reconfigure(pdev, XenbusStateReconfiguring);
 		break;
 
 	case XenbusStateConnected:
@@ -663,6 +666,15 @@ static void xen_pcibk_be_watch(struct xe
 		xen_pcibk_setup_backend(pdev);
 		break;
 
+	case XenbusStateInitialised:
+		/*
+		 * We typically move to Initialised when the first device was
+		 * added. Hence subsequent devices getting added may need
+		 * reconfiguring.
+		 */
+		xen_pcibk_reconfigure(pdev, XenbusStateInitialised);
+		break;
+
 	default:
 		break;
 	}


