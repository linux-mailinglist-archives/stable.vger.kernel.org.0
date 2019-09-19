Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D716BB853B
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406599AbfISWS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404703AbfISWS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:18:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDF7E21D6C;
        Thu, 19 Sep 2019 22:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931537;
        bh=ATTSTQNzeM8sUDrhqGjI62uCRviZbT7bue9ppOoviPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ciy1WpbJFohKxi6fZdnqOeMg7v/YF42jtnwpsNSEsq83m6514z1oMeu1OV0JjewKZ
         NVCEb2/nL35LSZ/NjMg9rRrRcOjc7RQ4iuC8hY5QoNr1MVwAmMvrCYYMA5bdMQ+h2w
         P60UvQa5QJcyAvTXg7Mn27LMo7INsjdjbZnUN1TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        linux-mips@vger.kernel.org
Subject: [PATCH 4.9 22/74] MIPS: VDSO: Use same -m%-float cflag as the kernel proper
Date:   Fri, 20 Sep 2019 00:03:35 +0200
Message-Id: <20190919214806.913155402@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

commit 0648e50e548d881d025b9419a1a168753c8e2bf7 upstream.

The MIPS VDSO build currently doesn't provide the -msoft-float flag to
the compiler as the kernel proper does. This results in an attempt to
use the compiler's default floating point configuration, which can be
problematic in cases where this is incompatible with the target CPU's
-march= flag. For example decstation_defconfig fails to build using
toolchains in which gcc was configured --with-fp-32=xx with the
following error:

    LDS     arch/mips/vdso/vdso.lds
  cc1: error: '-march=r3000' requires '-mfp32'
  make[2]: *** [scripts/Makefile.build:379: arch/mips/vdso/vdso.lds] Error 1

The kernel proper avoids this error because we build with the
-msoft-float compiler flag, rather than using the compiler's default.
Pass this flag through to the VDSO build so that it too becomes agnostic
to the toolchain's floating point configuration.

Note that this is filtered out from KBUILD_CFLAGS rather than simply
always using -msoft-float such that if we switch the kernel to use
-mno-float in the future the VDSO will automatically inherit the change.

The VDSO doesn't actually include any floating point code, and its
.MIPS.abiflags section is already manually generated to specify that
it's compatible with any floating point ABI. As such this change should
have no effect on the resulting VDSO, apart from fixing the build
failure for affected toolchains.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Reported-by: Kevin Hilman <khilman@baylibre.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: linux-mips@vger.kernel.org
Cc: stable@vger.kernel.org # v4.4+
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/vdso/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -7,6 +7,7 @@ ccflags-vdso := \
 	$(filter -E%,$(KBUILD_CFLAGS)) \
 	$(filter -mmicromips,$(KBUILD_CFLAGS)) \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
+	$(filter -m%-float,$(KBUILD_CFLAGS)) \
 	-D__VDSO__
 cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \


