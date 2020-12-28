Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5922E3E09
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502761AbgL1OWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502754AbgL1OWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F59F22B2E;
        Mon, 28 Dec 2020 14:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165355;
        bh=H1s/L3kciEiAKJWchESFS71nSiRSVzk+S0omDjp9yas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aL27IInzPx4dBbfkOH2mVIVm9KJVqmSoGslBXGr+XyNLPi/XqVcFb0jU2kwlAzYLf
         Izbiz1HJajnMMsHb2sEZD0HYQlCuax5yZtlEUMttSaJW8dQmNoVclb6ovgPJLPA8mv
         jSgTBaqXBn8ckEGl6pIEOxlcVIlU31mC3gog3LU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/717] powerpc/boot: Fix build of dts/fsl
Date:   Mon, 28 Dec 2020 13:48:19 +0100
Message-Id: <20201228125044.966377281@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit b36f835b636908e4122f2e17310b1dbc380a3b19 ]

The lkp robot reported that some configs fail to build, for example
mpc85xx_smp_defconfig, with:

  cc1: fatal error: opening output file arch/powerpc/boot/dts/fsl/.mpc8540ads.dtb.dts.tmp: No such file or directory

This bisects to:
  cc8a51ca6f05 ("kbuild: always create directories of targets")

Although that commit claims to be about in-tree builds, it somehow
breaks out-of-tree builds. But presumably it's just exposing a latent
bug in our Makefiles.

We can fix it by adding to targets for dts/fsl in the same way that we
do for dts.

Fixes: cc8a51ca6f05 ("kbuild: always create directories of targets")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201215032906.473460-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index f8ce6d2dde7b1..e4b364b5da9e7 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -368,6 +368,8 @@ initrd-y := $(filter-out $(image-y), $(initrd-y))
 targets	+= $(image-y) $(initrd-y)
 targets += $(foreach x, dtbImage uImage cuImage simpleImage treeImage, \
 		$(patsubst $(x).%, dts/%.dtb, $(filter $(x).%, $(image-y))))
+targets += $(foreach x, dtbImage uImage cuImage simpleImage treeImage, \
+		$(patsubst $(x).%, dts/fsl/%.dtb, $(filter $(x).%, $(image-y))))
 
 $(addprefix $(obj)/, $(initrd-y)): $(obj)/ramdisk.image.gz
 
-- 
2.27.0



