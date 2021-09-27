Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D4B419AF9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbhI0ROo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236914AbhI0RNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E20961207;
        Mon, 27 Sep 2021 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762556;
        bh=2GYkAt9O173YpfmLkfPRMwMe6/y4lGTtCkxDYWyHzvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4O3OLNkpyJYG2uISz5ioGb2oDzGe2J2IDhxjk/jEleeHqLmGW6SMg0Fd3IZtADyu
         y6hzrionh5jr9U61yEhHjj2ujHC9MpqnyPg06y3lZz2pFeCiCTJKx0uWN4uf/lfa4s
         PeKdJsj7fHakUnX7bM3EDL3bU2MnIxgNf10GyYLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/103] x86/asm: Add a missing __iomem annotation in enqcmds()
Date:   Mon, 27 Sep 2021 19:02:41 +0200
Message-Id: <20210927170228.160144092@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 5c99720b28381bb400d4f546734c34ddaf608761 ]

Add a missing __iomem annotation to address a sparse warning. The caller
is expected to pass an __iomem annotated pointer to this function. The
current usages send a 64-bytes command descriptor to an MMIO location
(portal) on a device for consumption.

Also, from the comment in movdir64b(), which also applies to enqcmds(),
@__dst must be supplied as an lvalue because this tells the compiler
what the object is (its size) the instruction accesses. I.e., not the
pointers but what they point to, thus the deref'ing '*'."

The actual sparse warning is:

  drivers/dma/idxd/submit.c: note: in included file (through arch/x86/include/asm/processor.h, \
	arch/x86/include/asm/timex.h, include/linux/timex.h, include/linux/time32.h, \
	include/linux/time.h, include/linux/stat.h, ...):
  ./arch/x86/include/asm/special_insns.h:289:41: warning: incorrect type in initializer (different address spaces)
  ./arch/x86/include/asm/special_insns.h:289:41:    expected struct <noident> *__dst
  ./arch/x86/include/asm/special_insns.h:289:41:    got void [noderef] __iomem *dst

 [ bp: Massage commit message. ]

Fixes: 7f5933f81bd8 ("x86/asm: Add an enqcmds() wrapper for the ENQCMDS instruction")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lkml.kernel.org/r/161003789741.4062451.14362269365703761223.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/special_insns.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index cc177b4431ae..0cf19684dd20 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -286,7 +286,7 @@ static inline void movdir64b(void *dst, const void *src)
 static inline int enqcmds(void __iomem *dst, const void *src)
 {
 	const struct { char _[64]; } *__src = src;
-	struct { char _[64]; } *__dst = dst;
+	struct { char _[64]; } __iomem *__dst = dst;
 	int zf;
 
 	/*
-- 
2.33.0



