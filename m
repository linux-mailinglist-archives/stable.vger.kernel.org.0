Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1265511945D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbfLJVPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:15:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbfLJVNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 812B222464;
        Tue, 10 Dec 2019 21:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012417;
        bh=pEEjz3Ac7oHki0v/6nYWxfjSb4k9VlXfoHypBWSLk2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUJXmGHq2Ue/EwC8f+oDfg9JckVdrDUJDOGeGQKtMufjCXS4qktCofR04MBmHXwHd
         s6KAm1VZ+YztltygrMrE6Af1VeczM7euMehXPTA7V1HgejYvrrpZqtsz+bXW34h5zW
         lCpdkyRkIoQdcrgTv9Q6W1pY/GYSJOqVP4WiZXNM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 333/350] crypto: vmx - Avoid weird build failures
Date:   Tue, 10 Dec 2019 16:07:18 -0500
Message-Id: <20191210210735.9077-294-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 4ee812f6143d78d8ba1399671d78c8d78bf2817c ]

In the vmx crypto Makefile we assign to a variable called TARGET and
pass that to the aesp8-ppc.pl and ghashp8-ppc.pl scripts.

The variable is meant to describe what flavour of powerpc we're
building for, eg. either 32 or 64-bit, and big or little endian.

Unfortunately TARGET is a fairly common name for a make variable, and
if it happens that TARGET is specified as a command line parameter to
make, the value specified on the command line will override our value.

In particular this can happen if the kernel Makefile is driven by an
external Makefile that uses TARGET for something.

This leads to weird build failures, eg:
  nonsense  at /build/linux/drivers/crypto/vmx/ghashp8-ppc.pl line 45.
  /linux/drivers/crypto/vmx/Makefile:20: recipe for target 'drivers/crypto/vmx/ghashp8-ppc.S' failed

Which shows that we passed an empty value for $(TARGET) to the perl
script, confirmed with make V=1:

  perl /linux/drivers/crypto/vmx/ghashp8-ppc.pl  > drivers/crypto/vmx/ghashp8-ppc.S

We can avoid this confusion by using override, to tell make that we
don't want anything to override our variable, even a value specified
on the command line. We can also use a less common name, given the
script calls it "flavour", let's use that.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/vmx/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
index cab32cfec9c45..709670d2b553a 100644
--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -3,13 +3,13 @@ obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
 vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o aes_xts.o ghash.o
 
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
-TARGET := linux-ppc64le
+override flavour := linux-ppc64le
 else
-TARGET := linux-ppc64
+override flavour := linux-ppc64
 endif
 
 quiet_cmd_perl = PERL $@
-      cmd_perl = $(PERL) $(<) $(TARGET) > $(@)
+      cmd_perl = $(PERL) $(<) $(flavour) > $(@)
 
 targets += aesp8-ppc.S ghashp8-ppc.S
 
-- 
2.20.1

