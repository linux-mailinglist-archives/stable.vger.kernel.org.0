Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146152839C0
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgJEP2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgJEP2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6623207BC;
        Mon,  5 Oct 2020 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911721;
        bh=xixnvO3ZAoLYxjGynhehrUkrbEGNJR4I9gkYSvak8F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybAnfordUrwnsCO8Ue4HBO8BbXNPXttQiSk25XSUHS39x6rV6IBZRWfiBcoqxJDtP
         y4Wx7FCVuXieSZ1TvlluYDZ3kcAFQ/d+20+Fv7ES35PfZQ8XG1FcbHOpwFG76TezSl
         0E+ePH9oEZH/2gcpFOWabEWwYcbrzViyH0LrOnaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 05/57] gpio: mockup: fix resource leak in error path
Date:   Mon,  5 Oct 2020 17:26:17 +0200
Message-Id: <20201005142110.065282704@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
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
@@ -497,6 +497,7 @@ static int __init gpio_mockup_init(void)
 	err = platform_driver_register(&gpio_mockup_driver);
 	if (err) {
 		gpio_mockup_err("error registering platform driver\n");
+		debugfs_remove_recursive(gpio_mockup_dbg_dir);
 		return err;
 	}
 
@@ -527,6 +528,7 @@ static int __init gpio_mockup_init(void)
 			gpio_mockup_err("error registering device");
 			platform_driver_unregister(&gpio_mockup_driver);
 			gpio_mockup_unregister_pdevs();
+			debugfs_remove_recursive(gpio_mockup_dbg_dir);
 			return PTR_ERR(pdev);
 		}
 


