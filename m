Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7492E395DF7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhEaNw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233247AbhEaNu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:50:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D591C6142A;
        Mon, 31 May 2021 13:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467917;
        bh=ghFzGTVOE/F8V/pJ6ebnAk16SWRHvbVtge8asoKoCoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GO0JJyi4n+zoEX58EpfhdVPVw6uEZ8VkLC/5wILKyz+XAA1w/JECfr5f+8J26iNcZ
         n8tJM4tDmP4b8D2qQPQgtLLrgLrQgaATX1KIUu8uD+cH2CQFZcp6mjkjEk7Ag7toxO
         XijQRUSLQ3+4+qpepPEZYSN/Jfpz4bk33FZYs1rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/252] selftests/gpio: Fix build when source tree is read only
Date:   Mon, 31 May 2021 15:11:54 +0200
Message-Id: <20210531130659.647165760@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit b68c1c65dec5fb5186ebd33ce52059b4c6db8500 ]

Currently the gpio selftests fail to build if the source tree is read
only:

  make -j 160 -C tools/testing/selftests TARGETS=gpio
  make[1]: Entering directory '/linux/tools/testing/selftests/gpio'
  make OUTPUT=/linux/tools/gpio/ -C /linux/tools/gpio
  make[2]: Entering directory '/linux/tools/gpio'
  mkdir -p /linux/tools/gpio/include/linux 2>&1 || true
  ln -sf /linux/tools/gpio/../../include/uapi/linux/gpio.h /linux/tools/gpio/include/linux/gpio.h
  ln: failed to create symbolic link '/linux/tools/gpio/include/linux/gpio.h': Read-only file system

This happens because we ask make to build ../../../gpio (tools/gpio)
without pointing OUTPUT away from the source directory.

To fix it we create a subdirectory of the existing OUTPUT directory,
called tools-gpio, and tell tools/gpio to build in there.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/gpio/Makefile | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/gpio/Makefile b/tools/testing/selftests/gpio/Makefile
index 615c8a953ade..acf4088a9891 100644
--- a/tools/testing/selftests/gpio/Makefile
+++ b/tools/testing/selftests/gpio/Makefile
@@ -17,14 +17,18 @@ KSFT_KHDR_INSTALL := 1
 include ../lib.mk
 
 GPIODIR := $(realpath ../../../gpio)
-GPIOOBJ := gpio-utils.o
+GPIOOUT := $(OUTPUT)/tools-gpio/
+GPIOOBJ := $(GPIOOUT)/gpio-utils.o
 
 override define CLEAN
 	$(RM) $(TEST_GEN_PROGS_EXTENDED)
-	$(MAKE) -C $(GPIODIR) OUTPUT=$(GPIODIR)/ clean
+	$(RM) -rf $(GPIOOUT)
 endef
 
-$(TEST_GEN_PROGS_EXTENDED): $(GPIODIR)/$(GPIOOBJ)
+$(TEST_GEN_PROGS_EXTENDED): $(GPIOOBJ)
 
-$(GPIODIR)/$(GPIOOBJ):
-	$(MAKE) OUTPUT=$(GPIODIR)/ -C $(GPIODIR)
+$(GPIOOUT):
+	mkdir -p $@
+
+$(GPIOOBJ): $(GPIOOUT)
+	$(MAKE) OUTPUT=$(GPIOOUT) -C $(GPIODIR)
-- 
2.30.2



