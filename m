Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBAE328600
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbhCARCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235818AbhCAQzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:55:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DFC164FCE;
        Mon,  1 Mar 2021 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616550;
        bh=sWE1SduLLJSPrceN1LVedSKU/+Ma1lYMQ93v7yKlYdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sj2uO1M+Ttw7WZt9hogIydQajKgZ2mGFXxgTTkgsFprLjS78+QAYX55rAvBdH1uBF
         hoYRmv5m8FF/uEyEJ+xtLqdQ7Q2oe/WTWJxEMOkbptPChHuxkKvaL+7DtlJU3jYmmu
         MfgMkHEvLqx5VvLqMtNJIh0WXbr1oY+GpDf+AN5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rong Chen <rong.a.chen@intel.com>,
        kernel test robot <lkp@intel.com>,
        Yoshinori Sato <ysato@users.osdn.me>,
        Rich Felker <dalias@libc.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/247] scripts/recordmcount.pl: support big endian for ARCH sh
Date:   Mon,  1 Mar 2021 17:10:34 +0100
Message-Id: <20210301161032.386093807@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rong Chen <rong.a.chen@intel.com>

[ Upstream commit 93ca696376dd3d44b9e5eae835ffbc84772023ec ]

The kernel test robot reported the following issue:

    CC [M]  drivers/soc/litex/litex_soc_ctrl.o
  sh4-linux-objcopy: Unable to change endianness of input file(s)
  sh4-linux-ld: cannot find drivers/soc/litex/.tmp_gl_litex_soc_ctrl.o: No such file or directory
  sh4-linux-objcopy: 'drivers/soc/litex/.tmp_mx_litex_soc_ctrl.o': No such file

The problem is that the format of input file is elf32-shbig-linux, but
sh4-linux-objcopy wants to output a file which format is elf32-sh-linux:

  $ sh4-linux-objdump -d drivers/soc/litex/litex_soc_ctrl.o | grep format
  drivers/soc/litex/litex_soc_ctrl.o:     file format elf32-shbig-linux

Link: https://lkml.kernel.org/r/20210210150435.2171567-1-rong.a.chen@intel.com
Link: https://lore.kernel.org/linux-mm/202101261118.GbbYSlHu-lkp@intel.com
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/recordmcount.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -263,7 +263,11 @@ if ($arch eq "x86_64") {
 
     # force flags for this arch
     $ld .= " -m shlelf_linux";
-    $objcopy .= " -O elf32-sh-linux";
+    if ($endian eq "big") {
+        $objcopy .= " -O elf32-shbig-linux";
+    } else {
+        $objcopy .= " -O elf32-sh-linux";
+    }
 
 } elsif ($arch eq "powerpc") {
     my $ldemulation;


