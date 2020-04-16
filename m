Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1721AC28C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896064AbgDPN3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896056AbgDPN3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:29:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7B99208E4;
        Thu, 16 Apr 2020 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043783;
        bh=79z7BDql8stYOus3GTROCiSx/mTNrMJNRyoDBHRU8TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAp+quYAmlkpHIl6yjlrtilIHz8idXSpXdxwFiHtNsBBnBvLyjzgJE6sKr1hhDdTb
         dR3CgNEWZ8ZjuqRbKoXmai7ZXKn2W8QhmANE9CL9iXvYkctMutBurXwu/JgjZnPRFW
         OU7JnZXMqpRd36EWzkml89lRLhOYhzyKNkCVZ+J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 098/146] tools: gpio: Fix out-of-tree build regression
Date:   Thu, 16 Apr 2020 15:23:59 +0200
Message-Id: <20200416131256.157696583@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
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
 


