Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C1B4A4410
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377083AbiAaLZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41558 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377945AbiAaLXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 410BAB82A75;
        Mon, 31 Jan 2022 11:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645CAC340E8;
        Mon, 31 Jan 2022 11:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628212;
        bh=d4NMCRYFez7Dv/xaGO0VoOIytB742aa78WOrxB63pdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxhw+/VFjmrn+Nikg+LkKXTBuN67skWNCqBz3pxDR+0xzjbPjxvCpHkEcNgnAOYcD
         +YXPdlULN7IPAgNI7Dk/m/TIcCXZUr7sgMPpRrjNSUyQO/NypBPNT44+mv/f/v3uGb
         xGbH7ai2YKDnLy+P6np8ka37JlEv/o0zBBOgtFec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 159/200] hwmon: (adt7470) Prevent divide by zero in adt7470_fan_write()
Date:   Mon, 31 Jan 2022 11:57:02 +0100
Message-Id: <20220131105238.901810839@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c1ec0cabc36718efc7fe8b4157d41b82d08ec1d2 ]

The "val" variable is controlled by the user and comes from
hwmon_attr_store().  The FAN_RPM_TO_PERIOD() macro divides by "val"
so a zero will crash the system.  Check for that and return -EINVAL.
Negatives are also invalid so return -EINVAL for those too.

Fixes: fc958a61ff6d ("hwmon: (adt7470) Convert to devm_hwmon_device_register_with_info API")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index d519aca4a9d64..fb6d14d213a18 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -662,6 +662,9 @@ static int adt7470_fan_write(struct device *dev, u32 attr, int channel, long val
 	struct adt7470_data *data = dev_get_drvdata(dev);
 	int err;
 
+	if (val <= 0)
+		return -EINVAL;
+
 	val = FAN_RPM_TO_PERIOD(val);
 	val = clamp_val(val, 1, 65534);
 
-- 
2.34.1



