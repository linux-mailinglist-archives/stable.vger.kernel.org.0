Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE1322684F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgGTQNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387679AbgGTQNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:13:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 753FD20734;
        Mon, 20 Jul 2020 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261631;
        bh=U9A2yR2k6FkavOn/3+booMWwECu0863W08r20mMUvOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnaa8zcnt3TsDmcsV681JcsAdTggpgeibQwpOQ/BKIT632/G7M5u8QW9LelqCGvrN
         HOLq/BwEPkDqDGdSXnDf3OhkSFuXpCFAEdssg8gU0hUi+XL/BF52aBuQOblBTqDy2N
         fjMm2/y+jwZmS15G4a0UOZPFmAT6YvBtcr1ti4eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.7 186/244] mei: bus: dont clean driver pointer
Date:   Mon, 20 Jul 2020 17:37:37 +0200
Message-Id: <20200720152834.688721482@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit e852c2c251ed9c23ae6e3efebc5ec49adb504207 upstream.

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
 drivers/misc/mei/bus.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -745,9 +745,8 @@ static int mei_cl_device_remove(struct d
 
 	mei_cl_bus_module_put(cldev);
 	module_put(THIS_MODULE);
-	dev->driver = NULL;
-	return ret;
 
+	return ret;
 }
 
 static ssize_t name_show(struct device *dev, struct device_attribute *a,


