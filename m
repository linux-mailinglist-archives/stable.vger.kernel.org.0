Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A178CA4EB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390163AbfJCQ3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391374AbfJCQ3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C4842054F;
        Thu,  3 Oct 2019 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120157;
        bh=eMPlCWxTQpyconOk0Sr//jZgoyEkKBpyv80QPkFVPI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyrrpRpZ0mKF2JGcHSGdoBPWIPmv8KSFlQJyQDcBFA1My8q2dj6nznTVlU7ofyWmu
         p+gJnjHZZzu10O2SJKv3Rj98LdI7YdGpswO1L5hEf/Kjn4oDzsQ4lH7s46CJ/2BQzV
         Vxfrvz1Xwm1uJ9rrMQ/g+IpEMj5Do7bEkbhBrnbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Peter Collingbourne <pcc@google.com>
Subject: [PATCH 5.2 116/313] powerpc/Makefile: Always pass --synthetic to nm if supported
Date:   Thu,  3 Oct 2019 17:51:34 +0200
Message-Id: <20191003154544.299239130@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 117acf5c29dd89e4c86761c365b9724dba0d9763 ]

Back in 2004 we added logic to arch/ppc64/Makefile to pass
the --synthetic option to nm, if it was supported by nm.

Then in 2005 when arch/ppc64 and arch/ppc were merged, the logic to
add --synthetic was moved inside an #ifdef CONFIG_PPC64 block within
arch/powerpc/Makefile, and has remained there since.

That was fine, though crufty, until recently when a change to
init/Kconfig added a config time check that uses $(NM). On powerpc
that leads to an infinite loop because Kconfig uses $(NM) to calculate
some values, then the powerpc Makefile changes $(NM), which Kconfig
notices and restarts.

The original commit that added --synthetic simply said:
  On new toolchains we need to use nm --synthetic or we miss code
  symbols.

And the nm man page says that the --synthetic option causes nm to:
  Include synthetic symbols in the output. These are special symbols
  created by the linker for various purposes.

So it seems safe to always pass --synthetic if nm supports it, ie. on
32-bit and 64-bit, it just means 32-bit kernels might have more
symbols reported (and in practice I see no extra symbols). Making it
unconditional avoids the #ifdef CONFIG_PPC64, which in turn avoids the
infinite loop.

Debugged-by: Peter Collingbourne <pcc@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index c345b79414a96..403f7e193833a 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -39,13 +39,11 @@ endif
 uname := $(shell uname -m)
 KBUILD_DEFCONFIG := $(if $(filter ppc%,$(uname)),$(uname),ppc64)_defconfig
 
-ifdef CONFIG_PPC64
 new_nm := $(shell if $(NM) --help 2>&1 | grep -- '--synthetic' > /dev/null; then echo y; else echo n; fi)
 
 ifeq ($(new_nm),y)
 NM		:= $(NM) --synthetic
 endif
-endif
 
 # BITS is used as extension for files which are available in a 32 bit
 # and a 64 bit version to simplify shared Makefiles.
-- 
2.20.1



