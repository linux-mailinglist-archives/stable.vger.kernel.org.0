Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16E12F1472
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbhAKNYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732600AbhAKNRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DE1E22795;
        Mon, 11 Jan 2021 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371022;
        bh=k3LMdc1mx+tCG5SW3cFuU0akgB7OzWBZtsMuxdz5sPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mG1ZblqrO9jW5b+XuimKE+jSOIHNB3NVdhOzv9gh6E5QWKpXclHypUcyZhQAD4xnC
         i5sD76bDmXWcbICDRt+5g7V917R1vg1LvC1NUHJ5UnOu/pzSbmDUDzr+5WmxN9BMyl
         LgBsDrEpsLysXbL4E8uFMqoY98zneL3lQvR3NOcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Arcari <darcari@redhat.com>,
        Naveen Krishna Chatradhi <nchatrad@amd.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 108/145] hwmon: (amd_energy) fix allocation of hwmon_channel_info config
Date:   Mon, 11 Jan 2021 14:02:12 +0100
Message-Id: <20210111130053.716228132@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Arcari <darcari@redhat.com>

commit 84e261553e6f919bf0b4d65244599ab2b41f1da5 upstream.

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
Signed-off-by: David Arcari <darcari@redhat.com>
Acked-by: Naveen Krishna Chatradhi <nchatrad@amd.com>
Link: https://lore.kernel.org/r/20210107144707.6927-1-darcari@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/amd_energy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/amd_energy.c
+++ b/drivers/hwmon/amd_energy.c
@@ -222,7 +222,7 @@ static int amd_create_sensor(struct devi
 	 */
 	cpus = num_present_cpus() / num_siblings;
 
-	s_config = devm_kcalloc(dev, cpus + sockets,
+	s_config = devm_kcalloc(dev, cpus + sockets + 1,
 				sizeof(u32), GFP_KERNEL);
 	if (!s_config)
 		return -ENOMEM;
@@ -254,6 +254,7 @@ static int amd_create_sensor(struct devi
 			scnprintf(label_l[i], 10, "Esocket%u", (i - cpus));
 	}
 
+	s_config[i] = 0;
 	return 0;
 }
 


