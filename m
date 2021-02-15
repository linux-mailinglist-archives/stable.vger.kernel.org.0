Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1634F31C1AD
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 19:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhBOSim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 13:38:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230464AbhBOSiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 13:38:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8010164E27;
        Mon, 15 Feb 2021 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414219;
        bh=BjnqRSgTghxHTC/Y2mXgCFEH6teFqCdVhUhL3nlqKnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nU+Jq+U0F4wzrYMLtldEL1oPAY+Jjr+5rvdjuY8dTMoCDHfRVQI9a4Vb5yETMEgu4
         zrVwcmM8hQyP2zBRKrpzbzJmrPloXEJhiowLrOs6QXdJgBVjvRI7/j5vsYncePMp8r
         yF2ho362rT2u0ruflpodeNJq2Sf/+q10qtSd19sT93QbgqWhohbq1vjgWKQIFSnCol
         T6LVE75OxVcKtT7l3gJnBsZv7tOnrH+UY5NJn3ekkVhAiRcUoei4VQhXmdC9mm0xHQ
         SLnhQTwdIFO3TO2fLTNsqZQ02dTBkCZmclpBPGHfPWV2+5tTtYeY6XrXsSPIXVnega
         U463lJroV74yQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rong Chen <rong.a.chen@intel.com>,
        kernel test robot <lkp@intel.com>,
        Yoshinori Sato <ysato@users.osdn.me>,
        Rich Felker <dalias@libc.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 6/6] scripts/recordmcount.pl: support big endian for ARCH sh
Date:   Mon, 15 Feb 2021 13:36:51 -0500
Message-Id: <20210215183651.122001-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210215183651.122001-1-sashal@kernel.org>
References: <20210215183651.122001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 scripts/recordmcount.pl | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 3f77a5d695c13..0bafed857e171 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -268,7 +268,11 @@ if ($arch eq "x86_64") {
 
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
-- 
2.27.0

