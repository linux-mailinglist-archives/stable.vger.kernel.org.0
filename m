Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE427797C9
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390011AbfG2Tpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389995AbfG2Tpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82215205F4;
        Mon, 29 Jul 2019 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429546;
        bh=Bmj3arK8osb3gcfKp7r6VApdlAo2Uep41Ao0G+q59xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbWWcKIEIhAqnuq9lASb2uE77oxAzqHkhRjqcE7nyN922wput2RpmDwlwwQ8H4TF0
         V6PdaQfx1S4U1NlSdSPEHNWxpc2hai4FpTQkmy4LQBl1Zgew6fbYdJF8pmaRDi6pZm
         aeyWdtHeWFxruxprjZKZDeUJUWQmpcHtG5uUSKJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 019/215] ipmi_ssif: fix unexpected driver unregister warning
Date:   Mon, 29 Jul 2019 21:20:15 +0200
Message-Id: <20190729190743.029001920@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



