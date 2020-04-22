Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9381B4167
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgDVKKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbgDVKKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:10:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20AFB2077D;
        Wed, 22 Apr 2020 10:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550248;
        bh=79z7BDql8stYOus3GTROCiSx/mTNrMJNRyoDBHRU8TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6GnO5j5wT5v8kunH3gK4PcNRi9hkYJ8gjyWwR1OnNZVPcy/y4GyRJ+H5xcz6ammB
         qfjeSDVLjJdE4Ys/sTQ552r7RzYBKpbzTGZ4235MJO3ewpp7bLO4zBkeS4M0eYreye
         5tC7UHjHp9gyTq8PdFKywB2IE4+2fSbWWSvweZGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 070/199] tools: gpio: Fix out-of-tree build regression
Date:   Wed, 22 Apr 2020 11:56:36 +0200
Message-Id: <20200422095105.183592978@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit 82f04bfe2aff428b063eefd234679b2d693228ed upstream.

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
Link: https://lore.kernel.org/r/20200325103154.32235-1-anssi.hannula@bitwise.fi
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/gpio/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -35,7 +35,7 @@ $(OUTPUT)include/linux/gpio.h: ../../inc
 
 prepare: $(OUTPUT)include/linux/gpio.h
 
-GPIO_UTILS_IN := $(output)gpio-utils-in.o
+GPIO_UTILS_IN := $(OUTPUT)gpio-utils-in.o
 $(GPIO_UTILS_IN): prepare FORCE
 	$(Q)$(MAKE) $(build)=gpio-utils
 


