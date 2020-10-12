Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B5A28B8BB
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390396AbgJLNyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389696AbgJLNps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5913021BE5;
        Mon, 12 Oct 2020 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510273;
        bh=87vBj+uHV7nk6yoGej2Hcm8LlmoOilfSL1aaEibYHqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjHh3xxbWbxv0ySlDk/bpAdct1UAh6Y8krcNU98qxsV8fBHd1OPTHrw1T05dFFB2R
         ssFg3lp4hpe4DjW+oZzg8P78C+ti/j/ipuyz3U4wjESCWlZEwk1zhf4nafP3TjUQcB
         PceRkxDFwXEglz0EFDR4+yAKclVS4dTpNw8DXrmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.8 029/124] gpiolib: Disable compat ->read() code in UML case
Date:   Mon, 12 Oct 2020 15:30:33 +0200
Message-Id: <20201012133148.257019902@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 47e538d86d5776ac8152146c3ed3d22326243190 upstream.

It appears that UML (arch/um) has no compat.h header defined and hence
can't compile a recently provided piece of code in GPIO library.

Disable compat ->read() code in UML case to avoid compilation errors.

While at it, use pattern which is already being used in the kernel elsewhere.

Fixes: 5ad284ab3a01 ("gpiolib: Fix line event handling in syscall compatible mode")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20201005131044.87276-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -838,7 +838,7 @@ static __poll_t lineevent_poll(struct fi
 
 static ssize_t lineevent_get_size(void)
 {
-#ifdef __x86_64__
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 	/* i386 has no padding after 'id' */
 	if (in_ia32_syscall()) {
 		struct compat_gpioeevent_data {


