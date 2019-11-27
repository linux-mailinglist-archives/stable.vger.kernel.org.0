Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1E810B823
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfK0UkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbfK0UkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:40:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0301215A5;
        Wed, 27 Nov 2019 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887209;
        bh=7m1VKE82npjS1QBKundjQGelVxKoyCd7NyC2hrGZzgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkHvEfEYWGfVRh29KjTgqAydwviggfZDvWtaE1/pocTd/OhkTBefyTYV00yA/K8vE
         WGWq22vxCOWv2SBseS3WSFd7L8XB5dPevl6xlaSzlKBBWW06BaudUC1107ydRxRUzU
         n0mk398K6/Kn5XfNlWjFrtGonh7N+ou0+4EvQizE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.9 007/151] tools: gpio: Correctly add make dependencies for gpio_utils
Date:   Wed, 27 Nov 2019 21:29:50 +0100
Message-Id: <20191127203004.992049196@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

commit 0161a94e2d1c713bd34d72bc0239d87c31747bf7 upstream.

gpio tools fail to build correctly with make parallelization:

$ make -s -j24
ld: gpio-utils.o: file not recognized: file truncated
make[1]: *** [/home/labbott/linux_upstream/tools/build/Makefile.build:145: lsgpio-in.o] Error 1
make: *** [Makefile:43: lsgpio-in.o] Error 2
make: *** Waiting for unfinished jobs....

This is because gpio-utils.o is used across multiple targets.
Fix this by making gpio-utios.o a proper dependency.

Cc: <stable@vger.kernel.org>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/gpio/Build    |    1 +
 tools/gpio/Makefile |   10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/tools/gpio/Build
+++ b/tools/gpio/Build
@@ -1,3 +1,4 @@
+gpio-utils-y += gpio-utils.o
 lsgpio-y += lsgpio.o gpio-utils.o
 gpio-hammer-y += gpio-hammer.o gpio-utils.o
 gpio-event-mon-y += gpio-event-mon.o gpio-utils.o
--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -32,11 +32,15 @@ $(OUTPUT)include/linux/gpio.h: ../../inc
 
 prepare: $(OUTPUT)include/linux/gpio.h
 
+GPIO_UTILS_IN := $(output)gpio-utils-in.o
+$(GPIO_UTILS_IN): prepare FORCE
+	$(Q)$(MAKE) $(build)=gpio-utils
+
 #
 # lsgpio
 #
 LSGPIO_IN := $(OUTPUT)lsgpio-in.o
-$(LSGPIO_IN): prepare FORCE
+$(LSGPIO_IN): prepare FORCE $(OUTPUT)gpio-utils-in.o
 	$(Q)$(MAKE) $(build)=lsgpio
 $(OUTPUT)lsgpio: $(LSGPIO_IN)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
@@ -45,7 +49,7 @@ $(OUTPUT)lsgpio: $(LSGPIO_IN)
 # gpio-hammer
 #
 GPIO_HAMMER_IN := $(OUTPUT)gpio-hammer-in.o
-$(GPIO_HAMMER_IN): prepare FORCE
+$(GPIO_HAMMER_IN): prepare FORCE $(OUTPUT)gpio-utils-in.o
 	$(Q)$(MAKE) $(build)=gpio-hammer
 $(OUTPUT)gpio-hammer: $(GPIO_HAMMER_IN)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
@@ -54,7 +58,7 @@ $(OUTPUT)gpio-hammer: $(GPIO_HAMMER_IN)
 # gpio-event-mon
 #
 GPIO_EVENT_MON_IN := $(OUTPUT)gpio-event-mon-in.o
-$(GPIO_EVENT_MON_IN): prepare FORCE
+$(GPIO_EVENT_MON_IN): prepare FORCE $(OUTPUT)gpio-utils-in.o
 	$(Q)$(MAKE) $(build)=gpio-event-mon
 $(OUTPUT)gpio-event-mon: $(GPIO_EVENT_MON_IN)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@


