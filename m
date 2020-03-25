Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE6E1925FC
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 11:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCYKmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 06:42:10 -0400
Received: from mail.bitwise.fi ([109.204.228.163]:34558 "EHLO mail.bitwise.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgCYKmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 06:42:10 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2020 06:42:09 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.bitwise.fi (Postfix) with ESMTP id A2E5160054;
        Wed, 25 Mar 2020 12:33:10 +0200 (EET)
X-Virus-Scanned: Debian amavisd-new at mail.bitwise.fi
Received: from mail.bitwise.fi ([127.0.0.1])
        by localhost (mail.bitwise.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q1tYnBd_Bn1G; Wed, 25 Mar 2020 12:33:07 +0200 (EET)
Received: from localhost.localdomain (fw1.dmz.bitwise.fi [192.168.69.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: anssiha)
        by mail.bitwise.fi (Postfix) with ESMTPSA id 443EA6004B;
        Wed, 25 Mar 2020 12:33:07 +0200 (EET)
From:   Anssi Hannula <anssi.hannula@bitwise.fi>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        Laura Abbott <labbott@redhat.com>
Subject: [PATCH] tools: gpio: Fix out-of-tree build regression
Date:   Wed, 25 Mar 2020 12:31:54 +0200
Message-Id: <20200325103154.32235-1-anssi.hannula@bitwise.fi>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 0161a94e2d1c7 ("tools: gpio: Correctly add make dependencies for
gpio_utils") added a make rule for gpio-utils-in.o but used $(output)
instead of the correct $(OUTPUT) for the output directory, breaking
out-of-tree build (O=xx) with the following error:

  No rule to make target 'out/tools/gpio/gpio-utils-in.o', needed by 'out/tools/gpio/lsgpio-in.o'.  Stop.

Fix that.

Fixes: 0161a94e2d1c ("tools: gpio: Correctly add make dependencies for gpio_utils")
Cc: <stable@vger.kernel.org>
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
---

The 0161a94e2d1c was also applied to stable releases, which is where I
got hit by the issue.

 tools/gpio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/gpio/Makefile b/tools/gpio/Makefile
index 842287e42c83..440434027557 100644
--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -35,7 +35,7 @@ $(OUTPUT)include/linux/gpio.h: ../../include/uapi/linux/gpio.h
 
 prepare: $(OUTPUT)include/linux/gpio.h
 
-GPIO_UTILS_IN := $(output)gpio-utils-in.o
+GPIO_UTILS_IN := $(OUTPUT)gpio-utils-in.o
 $(GPIO_UTILS_IN): prepare FORCE
 	$(Q)$(MAKE) $(build)=gpio-utils
 
-- 
2.21.1

