Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D5F2ED306
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbhAGOtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:49:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728073AbhAGOtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 09:49:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610030877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=yMfKNp6sr/mfI0tAtJ2iQEz34mSVMtqRtWVBL/+ynqo=;
        b=Ur7nYeNuxWG8D29YeRMuLuno7Q7bZ5G30jz36H22H+p5bQXRQEa6SkWxmci8enrFfhMMoE
        sQJK3Ghkm1as4IXtSfX09eVQqG58uFEmY97KDLwHCtgmYlLXNOWBqGt27VTGDTdQ3x9+kG
        DNk3rRXZ1ywpN6hV6PyEmE1x6XPx3zA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-_g_6mqkxNWqv29eFtqW9LA-1; Thu, 07 Jan 2021 09:47:56 -0500
X-MC-Unique: _g_6mqkxNWqv29eFtqW9LA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5323C805EFF;
        Thu,  7 Jan 2021 14:47:37 +0000 (UTC)
Received: from darcari.bos.com (ovpn-113-9.rdu2.redhat.com [10.10.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 450D160861;
        Thu,  7 Jan 2021 14:47:36 +0000 (UTC)
From:   David Arcari <darcari@redhat.com>
To:     linux-hwmon@vger.kernel.org
Cc:     David Arcari <darcari@redhat.com>,
        Naveen Krishna Chatradhi <nchatrad@amd.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info config
Date:   Thu,  7 Jan 2021 09:47:07 -0500
Message-Id: <20210107144707.6927-1-darcari@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hwmon, specifically hwmon_num_channel_attrs, expects the config
array in the hwmon_channel_info structure to be terminated by
a zero entry.  amd_energy does not honor this convention.  As
result, a KASAN warning is possible.  Fix this by adding an
additional entry and setting it to zero.

Fixes: 8abee9566b7e ("hwmon: Add amd_energy driver to report energy counters")

Signed-off-by: David Arcari <darcari@redhat.com>
Cc: Naveen Krishna Chatradhi <nchatrad@amd.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/hwmon/amd_energy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/amd_energy.c b/drivers/hwmon/amd_energy.c
index 9b306448b7a0..822c2e74b98d 100644
--- a/drivers/hwmon/amd_energy.c
+++ b/drivers/hwmon/amd_energy.c
@@ -222,7 +222,7 @@ static int amd_create_sensor(struct device *dev,
 	 */
 	cpus = num_present_cpus() / num_siblings;
 
-	s_config = devm_kcalloc(dev, cpus + sockets,
+	s_config = devm_kcalloc(dev, cpus + sockets + 1,
 				sizeof(u32), GFP_KERNEL);
 	if (!s_config)
 		return -ENOMEM;
@@ -254,6 +254,7 @@ static int amd_create_sensor(struct device *dev,
 			scnprintf(label_l[i], 10, "Esocket%u", (i - cpus));
 	}
 
+	s_config[i] = 0;
 	return 0;
 }
 
-- 
2.18.1

