Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CE4CDF81
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 12:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJGKlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 06:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727252AbfJGKlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 06:41:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4B1D2070B;
        Mon,  7 Oct 2019 10:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570444875;
        bh=pwKSDWwxwXohNDSxI0SrpYuE8b82xTMDMxaUqFxO56g=;
        h=Subject:To:From:Date:From;
        b=wOfDETa7lRH3ZO43aiDgO1pLUQxehrKPOhgiN/18zfTuNsiRJGfQOg4yTJ8qaQ8nv
         Vgzb0pv9H+yPoXQTqGynno780OnJFJyWDGtOwJsTFMuwsYiVDYwg1eWGgHYh3b9FT3
         lwj6RSsSnZgTq+9mPUkER9CjamIdh250i0S8Yjos=
Subject: patch "staging: vt6655: Fix memory leak in vt6655_probe" added to staging-linus
To:     navid.emamdoost@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Oct 2019 12:41:13 +0200
Message-ID: <157044487320622@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vt6655: Fix memory leak in vt6655_probe

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 80b15db5e1e9c3300de299b2d43d1aafb593e6ac Mon Sep 17 00:00:00 2001
From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Fri, 4 Oct 2019 15:03:15 -0500
Subject: staging: vt6655: Fix memory leak in vt6655_probe

In vt6655_probe, if vnt_init() fails the cleanup code needs to be called
like other error handling cases. The call to device_free_info() is
added.

Fixes: 67013f2c0e58 ("staging: vt6655: mac80211 conversion add main mac80211 functions")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191004200319.22394-1-navid.emamdoost@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vt6655/device_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c6bb4aaf9bd0..082302944c37 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1748,8 +1748,10 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 	priv->hw->max_signal = 100;
 
-	if (vnt_init(priv))
+	if (vnt_init(priv)) {
+		device_free_info(priv);
 		return -ENODEV;
+	}
 
 	device_print_info(priv);
 	pci_set_drvdata(pcid, priv);
-- 
2.23.0


