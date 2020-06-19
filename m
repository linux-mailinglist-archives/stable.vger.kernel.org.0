Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95474200F05
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403773AbgFSPOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392305AbgFSPOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:14:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C0C21582;
        Fri, 19 Jun 2020 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579647;
        bh=+XUa+QkXIWQlTxrFkkvcAbe+hTh14HBih0M5FvU+b+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL48scrH3TzC5cgu4mIWwiIbdd/ecgCBJfHgOQ6dyNcJZUKgkIVg3u9/jfxH9mU4r
         faxniojekzqRrv+2lbsZL+/FAHRx4ManGKx1pzdnoloYDueWBlJp5W1iRmoqkON+vp
         8+QVhj81CS5iUIou3Cad0MjYDhAJeYIK3VC19//A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Qiushi Wu <wu000273@umn.edu>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 213/261] power: supply: core: fix memory leak in HWMON error path
Date:   Fri, 19 Jun 2020 16:33:44 +0200
Message-Id: <20200619141700.097472191@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit 1d7a7128a2e9e1f137c99b0a44e94d70a77343e3 upstream.

In function power_supply_add_hwmon_sysfs(), psyhw->props is
allocated by bitmap_zalloc(). But this pointer is not deallocated
when devm_add_action fail,  which lead to a memory leak bug. To fix
this, we replace devm_add_action with devm_add_action_or_reset.

Cc: stable@kernel.org
Fixes: e67d4dfc9ff19 ("power: supply: Add HWMON compatibility layer")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/power_supply_hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/power_supply_hwmon.c
+++ b/drivers/power/supply/power_supply_hwmon.c
@@ -304,7 +304,7 @@ int power_supply_add_hwmon_sysfs(struct
 		goto error;
 	}
 
-	ret = devm_add_action(dev, power_supply_hwmon_bitmap_free,
+	ret = devm_add_action_or_reset(dev, power_supply_hwmon_bitmap_free,
 			      psyhw->props);
 	if (ret)
 		goto error;


