Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6378283A3B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgJEPch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728007AbgJEPc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03E2C206DD;
        Mon,  5 Oct 2020 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911945;
        bh=O15I/+Z/+JPT3BAXDOV6pJdp2PVPM0kT4ckTDeRQjKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYyiX436+XVeEfGzoBDAxYTZsIpWL1qIi30TMIromPcTst4JMRHNU6CFxqBcJRF+6
         5lXRoKMaTRA69JSjy3GMTXtNlhN35QnKZJJz4a6wuPygCPWJbL37KtcoJgTI+WpoLI
         nMnonZEMmuNXW0b60KmeVlm1t65za2UvMXuJ+UzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.8 10/85] gpio: mockup: fix resource leak in error path
Date:   Mon,  5 Oct 2020 17:26:06 +0200
Message-Id: <20201005142115.230551011@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

commit 1b02d9e770cd7087f34c743f85ccf5ea8372b047 upstream.

If the module init function fails after creating the debugs directory,
it's never removed. Add proper cleanup calls to avoid this resource
leak.

Fixes: 9202ba2397d1 ("gpio: mockup: implement event injecting over debugfs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-mockup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -552,6 +552,7 @@ static int __init gpio_mockup_init(void)
 	err = platform_driver_register(&gpio_mockup_driver);
 	if (err) {
 		gpio_mockup_err("error registering platform driver\n");
+		debugfs_remove_recursive(gpio_mockup_dbg_dir);
 		return err;
 	}
 
@@ -582,6 +583,7 @@ static int __init gpio_mockup_init(void)
 			gpio_mockup_err("error registering device");
 			platform_driver_unregister(&gpio_mockup_driver);
 			gpio_mockup_unregister_pdevs();
+			debugfs_remove_recursive(gpio_mockup_dbg_dir);
 			return PTR_ERR(pdev);
 		}
 


