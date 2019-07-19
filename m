Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E21B6D9A9
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfGSD5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbfGSD5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4677E21852;
        Fri, 19 Jul 2019 03:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508644;
        bh=Wo4zMwNeFCaCiuVGaxn4quODQXtKSbgms1sZcupcT7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/AGhMYfRBeIZ9HLIa7H1A8MczZap6XzQqsdxUp3Or7xVAaJgri5RWxKNAjdfuYqL
         oYedsjMiQcPYpc7nz9+SRpxmyyjc53TtxsRBvZ52EtUIpdX2K+/XTsqF5rZ74RIUlQ
         XS4UxUWjuQpSyYU76Dsfaq/XmJFtLZ2bz8SwyEJY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 017/171] ipmi_ssif: fix unexpected driver unregister warning
Date:   Thu, 18 Jul 2019 23:54:08 -0400
Message-Id: <20190719035643.14300-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 2cd0e54489e65b8e22124a8b053aff40815487f7 ]

If platform_driver_register() fails from init_ipmi_ssif(),
platform_driver_unregister() called unconditionally will
trigger following warning,

ipmi_ssif: Unable to register driver: -12
------------[ cut here ]------------
Unexpected driver unregister!
WARNING: CPU: 1 PID: 6305 at drivers/base/driver.c:193 driver_unregister+0x60/0x70 drivers/base/driver.c:193

Fix it by adding platform_registered variable, only unregister platform
driver when it is already successfully registered.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-Id: <20190524143724.43218-1-wangkefeng.wang@huawei.com>

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index cf8156d6bc07..305fa5054274 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -303,6 +303,7 @@ struct ssif_info {
 	((unsigned int) atomic_read(&(ssif)->stats[SSIF_STAT_ ## stat]))
 
 static bool initialized;
+static bool platform_registered;
 
 static void return_hosed_msg(struct ssif_info *ssif_info,
 			     struct ipmi_smi_msg *msg);
@@ -2088,6 +2089,8 @@ static int init_ipmi_ssif(void)
 		rv = platform_driver_register(&ipmi_driver);
 		if (rv)
 			pr_err("Unable to register driver: %d\n", rv);
+		else
+			platform_registered = true;
 	}
 
 	ssif_i2c_driver.address_list = ssif_address_list();
@@ -2111,7 +2114,7 @@ static void cleanup_ipmi_ssif(void)
 
 	kfree(ssif_i2c_driver.address_list);
 
-	if (ssif_trydmi)
+	if (ssif_trydmi && platform_registered)
 		platform_driver_unregister(&ipmi_driver);
 
 	free_ssif_clients();
-- 
2.20.1

