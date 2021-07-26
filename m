Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E553D613F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhGZPaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbhGZP2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:28:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B893360FD8;
        Mon, 26 Jul 2021 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315635;
        bh=So/Opxk55/ZLsA9ubwU2FKPcNTpNpnQXdG1DynM+c0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huTvZyKGI8CV+j7eI010sVZ7gKjhQWrogaVb8Gsx4dIn+4T9Gye/EBXluk4Hb6s/n
         1CCVyx6s9mIWVB65eSnbEs/XNCB98vV1QhrZZAj4doop/YvtOMkVOxeAwJpuQ51LU4
         lBNpvIVAnsVLmq9NJhYdt8IMnFJXmT7HO7Kq2zMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 5.10 153/167] driver core: Prevent warning when removing a device link from unregistered consumer
Date:   Mon, 26 Jul 2021 17:39:46 +0200
Message-Id: <20210726153844.545049021@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit e64daad660a0c9ace3acdc57099fffe5ed83f977 upstream.

sysfs_remove_link() causes a warning if the parent directory does not
exist. That can happen if the device link consumer has not been registered.
So do not attempt sysfs_remove_link() in that case.

Fixes: 287905e68dd29 ("driver core: Expose device link details in sysfs")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org # 5.9+
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20210716114408.17320-2-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -449,8 +449,10 @@ static void devlink_remove_symlinks(stru
 		return;
 	}
 
-	snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup), dev_name(sup));
-	sysfs_remove_link(&con->kobj, buf);
+	if (device_is_registered(con)) {
+		snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup), dev_name(sup));
+		sysfs_remove_link(&con->kobj, buf);
+	}
 	snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con), dev_name(con));
 	sysfs_remove_link(&sup->kobj, buf);
 	kfree(buf);


