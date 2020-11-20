Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52F92BA826
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgKTLFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgKTLFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:05:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5396A2245A;
        Fri, 20 Nov 2020 11:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870300;
        bh=bG11z9d9Iux42UdMLwXXlg6Ly5O/9t6T0TpysOcERLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Un8wmgwk/WC0vxHXVOSNJZVhJ6dXizBAUnRw5dX/6fgkYoAfhCOGa/j4Xv3/GG5ZU
         JpCE9n14cegbOv+/W4I7Ju0LL00NjehXqOm6UQgkzJ6OVxDLG1hVKL/0KZxmmmvHy2
         zS2GZLNiTbrTQrQ3tM1s+azeGll9gyXHAjvdVB50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 11/17] gpio: mockup: fix resource leak in error path
Date:   Fri, 20 Nov 2020 12:03:22 +0100
Message-Id: <20201120104540.973074513@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104540.414709708@linuxfoundation.org>
References: <20201120104540.414709708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

commit 1b02d9e770cd7087f34c743f85ccf5ea8372b047 upstream

If the module init function fails after creating the debugs directory,
it's never removed. Add proper cleanup calls to avoid this resource
leak.

Fixes: 9202ba2397d1 ("gpio: mockup: implement event injecting over debugfs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mockup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -350,6 +350,7 @@ static int __init mock_device_init(void)
 	err = platform_driver_register(&gpio_mockup_driver);
 	if (err) {
 		platform_device_unregister(pdev);
+		debugfs_remove_recursive(gpio_mockup_dbg_dir);
 		return err;
 	}
 


