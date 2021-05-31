Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0729B395DF0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhEaNwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233130AbhEaNuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6A2613C8;
        Mon, 31 May 2021 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467914;
        bh=dDO8IvkNPOq4l1134DqE7t1K1s+XGFot/hxwoHQv+W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ4rNZ0/4sutzQRLdxjeCu5f4Yi9VOvpJQYQ/pcGD06iVqIttFhEmxFwuzxfuKR9N
         xfmOrLbHMqQP9r83GsMRd8HMi0t8UheHygMt5SLHH0QJ9rgeaMCW/oz5KNzBSdyPc3
         2qjCHZmUlU/XJI0ZnfzTNmzArKfd40Qf8MzU/dR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/252] selftests/gpio: Move include of lib.mk up
Date:   Mon, 31 May 2021 15:11:53 +0200
Message-Id: <20210531130659.617139127@linuxfoundation.org>
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

[ Upstream commit 449539da2e237336bc750b41f1736a77f9aca25c ]

Move the include of lib.mk up so that in a subsequent patch we can use
OUTPUT, which is initialised by lib.mk, in the definition of the GPIO
variables.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/gpio/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/gpio/Makefile b/tools/testing/selftests/gpio/Makefile
index c85fb5acf5f4..615c8a953ade 100644
--- a/tools/testing/selftests/gpio/Makefile
+++ b/tools/testing/selftests/gpio/Makefile
@@ -13,6 +13,9 @@ TEST_PROGS := gpio-mockup.sh
 TEST_FILES := gpio-mockup-sysfs.sh
 TEST_GEN_PROGS_EXTENDED := gpio-mockup-chardev
 
+KSFT_KHDR_INSTALL := 1
+include ../lib.mk
+
 GPIODIR := $(realpath ../../../gpio)
 GPIOOBJ := gpio-utils.o
 
@@ -21,9 +24,6 @@ override define CLEAN
 	$(MAKE) -C $(GPIODIR) OUTPUT=$(GPIODIR)/ clean
 endef
 
-KSFT_KHDR_INSTALL := 1
-include ../lib.mk
-
 $(TEST_GEN_PROGS_EXTENDED): $(GPIODIR)/$(GPIOOBJ)
 
 $(GPIODIR)/$(GPIOOBJ):
-- 
2.30.2



