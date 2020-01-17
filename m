Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C331B140BF9
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgAQOCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:02:46 -0500
Received: from mail.dlink.ru ([178.170.168.18]:55836 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbgAQOCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 09:02:45 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 6EE6F1B21576; Fri, 17 Jan 2020 17:02:42 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 6EE6F1B21576
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579269762; bh=5ylIyyrZHlzb5tLPn4yy5E0L0D4VwPrmEFZ7BGuuHO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=EWBPsPwsX/FBRAeYsYwLjo7CLzvkeykEkH6W4hPSin3x4nVpHbx8dB0zBAd3+ybfw
         lPzxQX4Y/M5STsdDec+7dQ7JLXXIQuEPYvS6W8a3nFCJoj8oitsGYK/lorWNkw2e4c
         OB+UNMEDAhllfdOQFY64LqnJ0WuHq5oyN2/1aP4k=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 0A6A61B214CE;
        Fri, 17 Jan 2020 17:02:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 0A6A61B214CE
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 5DADB1B20AE9;
        Fri, 17 Jan 2020 17:02:31 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri, 17 Jan 2020 17:02:31 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paul Burton <paulburton@kernel.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Alexander Lobakin <alobakin@dlink.ru>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH mips-fixes 3/3] MIPS: syscalls: fix indentation of the 'SYSNR' message
Date:   Fri, 17 Jan 2020 17:02:09 +0300
Message-Id: <20200117140209.17672-4-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200117140209.17672-1-alobakin@dlink.ru>
References: <20200117140209.17672-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It also lacks a whitespace (copy'n'paste error?) and also messes up the
output:

  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n32.h
  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n64.h
  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_o32.h
  SYSNR  arch/mips/include/generated/uapi/asm/unistd_nr_n32.h
  SYSNR  arch/mips/include/generated/uapi/asm/unistd_nr_n64.h
  SYSNR  arch/mips/include/generated/uapi/asm/unistd_nr_o32.h
  WRAP    arch/mips/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/mips/include/generated/uapi/asm/ipcbuf.h

After:

  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n32.h
  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n64.h
  SYSHDR  arch/mips/include/generated/uapi/asm/unistd_o32.h
  SYSNR   arch/mips/include/generated/uapi/asm/unistd_nr_n32.h
  SYSNR   arch/mips/include/generated/uapi/asm/unistd_nr_n64.h
  SYSNR   arch/mips/include/generated/uapi/asm/unistd_nr_o32.h
  WRAP    arch/mips/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/mips/include/generated/uapi/asm/ipcbuf.h

Present since day 0 of syscall table generation introduction for MIPS.

Fixes: 9bcbf97c6293 ("mips: add system call table generation support")
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 arch/mips/kernel/syscalls/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/syscalls/Makefile b/arch/mips/kernel/syscalls/Makefile
index a3d4bec695c6..6efb2f6889a7 100644
--- a/arch/mips/kernel/syscalls/Makefile
+++ b/arch/mips/kernel/syscalls/Makefile
@@ -18,7 +18,7 @@ quiet_cmd_syshdr = SYSHDR  $@
 		   '$(syshdr_pfx_$(basetarget))'		\
 		   '$(syshdr_offset_$(basetarget))'
 
-quiet_cmd_sysnr = SYSNR  $@
+quiet_cmd_sysnr = SYSNR   $@
       cmd_sysnr = $(CONFIG_SHELL) '$(sysnr)' '$<' '$@'		\
 		  '$(sysnr_abis_$(basetarget))'			\
 		  '$(sysnr_pfx_$(basetarget))'			\
-- 
2.25.0

