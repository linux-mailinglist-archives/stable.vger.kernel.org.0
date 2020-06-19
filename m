Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D922010E5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404575AbgFSPfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404851AbgFSPbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2011520734;
        Fri, 19 Jun 2020 15:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580695;
        bh=+XUa+QkXIWQlTxrFkkvcAbe+hTh14HBih0M5FvU+b+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwoNEfvqaYt6hPspsPHDmpwRioGlQVLpwwhE+43OkqBCvK63Rt6mBBZrFLA16b5s0
         EwGV6n+LcNzqauHp8XWfrz9sZUuqKGDUCyBJd4RmzOtm7j0SYCiDgLaLW6CMINSOmz
         zBfc/75UdqnJjnuWmYX3vvY1R7DJNEmuvg/LtdRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Qiushi Wu <wu000273@umn.edu>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.7 317/376] power: supply: core: fix memory leak in HWMON error path
Date:   Fri, 19 Jun 2020 16:33:55 +0200
Message-Id: <20200619141725.337093073@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
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


