Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F8C29B6CC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798429AbgJ0P0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797693AbgJ0PYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF08C2064B;
        Tue, 27 Oct 2020 15:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812288;
        bh=9CLILCPVgTaUt4VkfpGYMDGq5kPlOrV2Y9UK5QuXMk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuQ2aw6hsuKQvYRu6GKyn3l1K1nqAflO+JDsVmm9ale6syLXFQjCwvTRQIlTNWC8K
         20i+nNDF3ua/wt5DrJJH4AWuRfenk9hIHorUp7rpx/xruqzUiYvn04R3BNXk797CX2
         zzMrt6YZZe4jBY0x/F8seHZBhvYJd7kWbvjb/Y4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 157/757] hwmon: (w83627ehf) Fix a resource leak in probe
Date:   Tue, 27 Oct 2020 14:46:47 +0100
Message-Id: <20201027135457.968737032@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 18360b33a071e5883250fd1e04bfdeff8c3887a3 ]

Smatch has a new check for resource leaks which found a bug in probe:

    drivers/hwmon/w83627ehf.c:2417 w83627ehf_probe()
    warn: 'res->start' not released on lines: 2412.

We need to clean up if devm_hwmon_device_register_with_info() fails.

Fixes: 266cd5835947 ("hwmon: (w83627ehf) convert to with_info interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dr. David Alan Gilbert <linux@treblig.org>
Link: https://lore.kernel.org/r/20200921125212.GA1128194@mwanda
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/w83627ehf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 5a5120121e507..3964ceab2817c 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1951,8 +1951,12 @@ static int w83627ehf_probe(struct platform_device *pdev)
 							 data,
 							 &w83627ehf_chip_info,
 							 w83627ehf_groups);
+	if (IS_ERR(hwmon_dev)) {
+		err = PTR_ERR(hwmon_dev);
+		goto exit_release;
+	}
 
-	return PTR_ERR_OR_ZERO(hwmon_dev);
+	return 0;
 
 exit_release:
 	release_region(res->start, IOREGION_LENGTH);
-- 
2.25.1



