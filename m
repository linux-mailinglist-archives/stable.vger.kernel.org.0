Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A085EA4E8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238621AbiIZL4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbiIZLyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999A058083;
        Mon, 26 Sep 2022 03:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D418B8094E;
        Mon, 26 Sep 2022 10:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A1BC433D6;
        Mon, 26 Sep 2022 10:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189032;
        bh=rFFd39b08CJ6QS5q+IzM2CHll7mwEFUDzEmip5CHelw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pypL8grXo0T2u/pw5Hc8vMmE9ig2KTs3uc0Q1Nh1qtE+uXn9sjFDP3HboR2voh4C1
         XxJXJaDydHalqDC5ZGLfRcqpCxOcpcWIbMq0vKIXqY0VlyjKuoQZabWfwNZDLEdRgp
         v7D1PssWwMw4MWCGZ2WBDnov6/b7Nn5ObA/1GWdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.19 051/207] gpio: mockup: fix NULL pointer dereference when removing debugfs
Date:   Mon, 26 Sep 2022 12:10:40 +0200
Message-Id: <20220926100808.907992147@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
@@ -597,9 +597,9 @@ static int __init gpio_mockup_init(void)
 
 static void __exit gpio_mockup_exit(void)
 {
+	gpio_mockup_unregister_pdevs();
 	debugfs_remove_recursive(gpio_mockup_dbg_dir);
 	platform_driver_unregister(&gpio_mockup_driver);
-	gpio_mockup_unregister_pdevs();
 }
 
 module_init(gpio_mockup_init);


