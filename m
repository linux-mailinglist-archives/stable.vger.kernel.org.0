Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6EB28C10E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388035AbgJLTIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbgJLTDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE77D214D8;
        Mon, 12 Oct 2020 19:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529385;
        bh=qIcFeA+fGiwcihUVhIK+KK5uybAa7QnSrfNH0fopBZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9keOqMkNgjGUa2tWFg+1oY02uo8ZJ3RgndMyv4JAnuMz7pi/69NcWavTnSoLzg8s
         v1EJTfJJyIldAr53pLEB8cA28d3NOZa+HAM77WhgCVTbjh8hihv6xo3JDix74k75dc
         /4AwDdmIKovNVhMfoIv6QbYii0xbMCeyPppkva+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Ren <guoren@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 20/24] riscv: Fixup bootup failure with HARDENED_USERCOPY
Date:   Mon, 12 Oct 2020 15:02:35 -0400
Message-Id: <20201012190239.3279198-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 84814460eef9af0fb56a4698341c9cb7996a6312 ]

6184358da000 ("riscv: Fixup static_obj() fail") attempted to elide a lockdep
failure by rearranging our kernel image to place all initdata within [_stext,
_end], thus triggering lockdep to treat these as static objects.  These objects
are released and eventually reallocated, causing check_kernel_text_object() to
trigger a BUG().

This backs out the change to make [_stext, _end] all-encompassing, instead just
moving initdata.  This results in initdata being outside of [__init_begin,
__init_end], which means initdata can't be freed.

Link: https://lore.kernel.org/linux-riscv/1593266228-61125-1-git-send-email-guoren@kernel.org/T/#t
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Reported-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Aurelien Jarno <aurelien@aurel32.net>
[Palmer: Clean up commit text]
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vmlinux.lds.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index f3586e31ed1ec..34d00d9e6eac0 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -22,13 +22,11 @@ SECTIONS
 	/* Beginning of code and text segment */
 	. = LOAD_OFFSET;
 	_start = .;
-	_stext = .;
 	HEAD_TEXT_SECTION
 	. = ALIGN(PAGE_SIZE);
 
 	__init_begin = .;
 	INIT_TEXT_SECTION(PAGE_SIZE)
-	INIT_DATA_SECTION(16)
 	. = ALIGN(8);
 	__soc_early_init_table : {
 		__soc_early_init_table_start = .;
@@ -55,6 +53,7 @@ SECTIONS
 	. = ALIGN(SECTION_ALIGN);
 	.text : {
 		_text = .;
+		_stext = .;
 		TEXT_TEXT
 		SCHED_TEXT
 		CPUIDLE_TEXT
@@ -67,6 +66,8 @@ SECTIONS
 		_etext = .;
 	}
 
+	INIT_DATA_SECTION(16)
+
 	/* Start of data section */
 	_sdata = .;
 	RO_DATA(SECTION_ALIGN)
-- 
2.25.1

