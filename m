Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D682633BA3F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbhCOOIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234106AbhCOOC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDDC364EFC;
        Mon, 15 Mar 2021 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816976;
        bh=7Ed7Lo0sYVxjRJyJpTL+BGzpiKR79N2IVWEzt+StavU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwZtuiafGHOsNooNKIdClYsF6tSNKAHKg82QIDMxht9SG/XkqyXYxKj3YFDOJL+fi
         Ixu+3wmpJrCniAY1QMHlfy87uvTAIqY+OQdTrAhoZPdAhWDaWzzfv+omRrUGzB4b7q
         djSG1oY2qAGP8i5riu770EncqRlMTRFdfmcntZgo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Niethe <jniethe5@gmail.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 240/306] powerpc/sstep: Fix VSX instruction emulation
Date:   Mon, 15 Mar 2021 14:55:03 +0100
Message-Id: <20210315135515.759710381@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jordan Niethe <jniethe5@gmail.com>

[ Upstream commit 5c88a17e15795226b56d83f579cbb9b7a4864f79 ]

Commit af99da74333b ("powerpc/sstep: Support VSX vector paired storage
access instructions") added loading and storing 32 word long data into
adjacent VSRs. However the calculation used to determine if two VSRs
needed to be loaded/stored inadvertently prevented the load/storing
taking place for instructions with a data length less than 16 words.

This causes the emulation to not function correctly, which can be seen
by the alignment_handler selftest:

$ ./alignment_handler
[snip]
test: test_alignment_handler_vsx_207
tags: git_version:powerpc-5.12-1-0-g82d2c16b350f
VSX: 2.07B
        Doing lxsspx:   PASSED
        Doing lxsiwax:  FAILED: Wrong Data
        Doing lxsiwzx:  PASSED
        Doing stxsspx:  PASSED
        Doing stxsiwx:  PASSED
failure: test_alignment_handler_vsx_207
test: test_alignment_handler_vsx_300
tags: git_version:powerpc-5.12-1-0-g82d2c16b350f
VSX: 3.00B
        Doing lxsd:     PASSED
        Doing lxsibzx:  PASSED
        Doing lxsihzx:  PASSED
        Doing lxssp:    FAILED: Wrong Data
        Doing lxv:      PASSED
        Doing lxvb16x:  PASSED
        Doing lxvh8x:   PASSED
        Doing lxvx:     PASSED
        Doing lxvwsx:   FAILED: Wrong Data
        Doing lxvl:     PASSED
        Doing lxvll:    PASSED
        Doing stxsd:    PASSED
        Doing stxsibx:  PASSED
        Doing stxsihx:  PASSED
        Doing stxssp:   PASSED
        Doing stxv:     PASSED
        Doing stxvb16x: PASSED
        Doing stxvh8x:  PASSED
        Doing stxvx:    PASSED
        Doing stxvl:    PASSED
        Doing stxvll:   PASSED
failure: test_alignment_handler_vsx_300
[snip]

Fix this by making sure all VSX instruction emulation correctly
load/store from the VSRs.

Fixes: af99da74333b ("powerpc/sstep: Support VSX vector paired storage access instructions")
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
Reviewed-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210225031946.1458206-1-jniethe5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index bb5c20d4ca91..c6aebc149d14 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -904,7 +904,7 @@ static nokprobe_inline int do_vsx_load(struct instruction_op *op,
 	if (!address_ok(regs, ea, size) || copy_mem_in(mem, ea, size, regs))
 		return -EFAULT;
 
-	nr_vsx_regs = size / sizeof(__vector128);
+	nr_vsx_regs = max(1ul, size / sizeof(__vector128));
 	emulate_vsx_load(op, buf, mem, cross_endian);
 	preempt_disable();
 	if (reg < 32) {
@@ -951,7 +951,7 @@ static nokprobe_inline int do_vsx_store(struct instruction_op *op,
 	if (!address_ok(regs, ea, size))
 		return -EFAULT;
 
-	nr_vsx_regs = size / sizeof(__vector128);
+	nr_vsx_regs = max(1ul, size / sizeof(__vector128));
 	preempt_disable();
 	if (reg < 32) {
 		/* FP regs + extensions */
-- 
2.30.1



