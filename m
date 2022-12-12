Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C78764A1BE
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiLLNo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbiLLNoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:44:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2862BEB
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:44:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3630D61074
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56CAC433EF;
        Mon, 12 Dec 2022 13:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852639;
        bh=KMXaX480Rg55ZVKIIZw2olW1c2VZcr6JGuyc2jJSFfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZdGRsT/aLjvYuCk68VEAHc43iv5JkKGG7E2am3mpFhDjtCfd37OPSEgRdNtUbjTk
         i/803Fjm+uClA2hKv88YgQmtA5T9Hx9O/EDOZbwPGVQfTuBDkPDWPmSb4Go60jpdT+
         XV1W24T+RBUPX7LOYc9F7t4rFGtnIzrqnHVyUics=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 096/157] gpio: amd8111: Fix PCI device reference count leak
Date:   Mon, 12 Dec 2022 14:17:24 +0100
Message-Id: <20221212130938.676287213@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 45fecdb9f658d9c82960c98240bc0770ade19aca ]

for_each_pci_dev() is implemented by pci_get_device(). The comment of
pci_get_device() says that it will increase the reference count for the
returned pci_dev and also decrease the reference count for the input
pci_dev @from if it is not NULL.

If we break for_each_pci_dev() loop with pdev not NULL, we need to call
pci_dev_put() to decrease the reference count. Add the missing
pci_dev_put() after the 'out' label. Since pci_dev_put() can handle NULL
input parameter, there is no problem for the 'Device not found' branch.
For the normal path, add pci_dev_put() in amd_gpio_exit().

Fixes: f942a7de047d ("gpio: add a driver for GPIO pins found on AMD-8111 south bridge chips")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-amd8111.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpio/gpio-amd8111.c b/drivers/gpio/gpio-amd8111.c
index 14e6b3e64add..6f3ded619c8b 100644
--- a/drivers/gpio/gpio-amd8111.c
+++ b/drivers/gpio/gpio-amd8111.c
@@ -226,7 +226,10 @@ static int __init amd_gpio_init(void)
 		ioport_unmap(gp.pm);
 		goto out;
 	}
+	return 0;
+
 out:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -234,6 +237,7 @@ static void __exit amd_gpio_exit(void)
 {
 	gpiochip_remove(&gp.chip);
 	ioport_unmap(gp.pm);
+	pci_dev_put(gp.pdev);
 }
 
 module_init(amd_gpio_init);
-- 
2.35.1



