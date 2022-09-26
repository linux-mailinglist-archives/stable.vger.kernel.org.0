Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE85EA2E8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbiIZLQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiIZLPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:15:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B5865272;
        Mon, 26 Sep 2022 03:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3B3A60AD6;
        Mon, 26 Sep 2022 10:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E63C433C1;
        Mon, 26 Sep 2022 10:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188263;
        bh=Wz53GDp3LiDe5Ese3UeEQC6KNfIuFv1AJlJOKUOhKiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1YxNBtKcyepUMWRGi2qlwDUVdYWPlB8TR7oOIQV7USAEemS+zaDIZiD3ryYgOWu+
         QQcSyIQzu5A55OlBnGP/HCm/oG9JwMI9g0EflSy93z9JNPmMVDp3W9SvlPgpCYQnvE
         j2uvdt0R9jBvA1/0StVOBZln5g9iKpA+UQ8nvZEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.10 053/141] gpio: mockup: fix NULL pointer dereference when removing debugfs
Date:   Mon, 26 Sep 2022 12:11:19 +0200
Message-Id: <20220926100756.374155441@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>

commit b7df41a6f79dfb18ba2203f8c5f0e9c0b9b57f68 upstream.

We now remove the device's debugfs entries when unbinding the driver.
This now causes a NULL-pointer dereference on module exit because the
platform devices are unregistered *after* the global debugfs directory
has been recursively removed. Fix it by unregistering the devices first.

Fixes: 303e6da99429 ("gpio: mockup: remove gpio debugfs when remove device")
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -604,9 +604,9 @@ static int __init gpio_mockup_init(void)
 
 static void __exit gpio_mockup_exit(void)
 {
+	gpio_mockup_unregister_pdevs();
 	debugfs_remove_recursive(gpio_mockup_dbg_dir);
 	platform_driver_unregister(&gpio_mockup_driver);
-	gpio_mockup_unregister_pdevs();
 }
 
 module_init(gpio_mockup_init);


