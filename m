Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C335720D9AC
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731930AbgF2Ttl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387752AbgF2Tkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F28255A7;
        Mon, 29 Jun 2020 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593450682;
        bh=8lDpxQ3aT45//5lXfEUlYjzKHtE33hJ9wKgcm0mKrw8=;
        h=Subject:To:From:Date:From;
        b=AwMWH8XZsG26z/Ig0e9/WCp6yF2JBvW1Mn04gu/L7AeOckiyhcL6SZjQQkNygfEMy
         i0/q5u+EqqbzkNITunFVLxm+Qp16vE+pkHJBj4h0lMRwsWKZJw6tdLV8S8qt1Q6Fv1
         FkDbaoAWn1aH1yxNPCGuuwQZGNoR9c6P39MjblYo=
Subject: patch "mei: bus: don't clean driver pointer" added to char-misc-linus
To:     alexander.usyskin@intel.com, apw@canonical.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 19:11:04 +0200
Message-ID: <1593450664160167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: bus: don't clean driver pointer

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e852c2c251ed9c23ae6e3efebc5ec49adb504207 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Mon, 29 Jun 2020 01:53:59 +0300
Subject: mei: bus: don't clean driver pointer

It's not needed to set driver to NULL in mei_cl_device_remove()
which is bus_type remove() handler as this is done anyway
in __device_release_driver().

Actually this is causing an endless loop in driver_detach()
on ubuntu patched kernel, while removing (rmmod) the mei_hdcp module.
The reason list_empty(&drv->p->klist_devices.k_list) is always not-empty.
as the check is always true in  __device_release_driver()
	if (dev->driver != drv)
		return;

The non upstream patch is causing this behavior, titled:
'vfio -- release device lock before userspace requests'

Nevertheless the fix is correct also for the upstream.

Link: https://patchwork.ozlabs.org/project/ubuntu-kernel/patch/20180912085046.3401-2-apw@canonical.com/
Cc: <stable@vger.kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200628225359.2185929-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 8d468e0a950a..f476dbc7252b 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -745,9 +745,8 @@ static int mei_cl_device_remove(struct device *dev)
 
 	mei_cl_bus_module_put(cldev);
 	module_put(THIS_MODULE);
-	dev->driver = NULL;
-	return ret;
 
+	return ret;
 }
 
 static ssize_t name_show(struct device *dev, struct device_attribute *a,
-- 
2.27.0


