Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557A812EE36
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgABWgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:36:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730914AbgABWgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:36:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E8B220866;
        Thu,  2 Jan 2020 22:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004571;
        bh=Z1qj7Do3EdfdXCrU8R22JG5kZqnt2C1f4Tn7aO0pYh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxP/mkpP6jq5jMoy1MkScKmN7qrexL2MzNPkC0NDGFpcbrvulNsfaSEplHbCdy7gz
         sfwQt2ujsvSevdB5kBFGOi4Jnf63sEFaw4m83C6f5QcWmz47hEz/waob85bv36UeID
         GznOenCa+7sRhSl2YZtafDcnDpg5xD8hU75vKLrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 063/137] crypto: vmx - Avoid weird build failures
Date:   Thu,  2 Jan 2020 23:07:16 +0100
Message-Id: <20200102220554.978002208@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d28ab96a2475..7663494809a0 100644
--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -2,13 +2,13 @@ obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
 vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o ghash.o
 
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
 
 $(src)/aesp8-ppc.S: $(src)/aesp8-ppc.pl
 	$(call cmd,perl)
-- 
2.20.1



