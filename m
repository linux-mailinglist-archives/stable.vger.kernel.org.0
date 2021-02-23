Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9547D32258A
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 06:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhBWFvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 00:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhBWFvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 00:51:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFD3964E60;
        Tue, 23 Feb 2021 05:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614059434;
        bh=IPkD+572EaUq/Ouy9LtIH5yCNhFOhkYfrxu8FFiUTRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stGgyRsuhqDn1KY3wVlD82Jr93tvHhs6l6I2q1NPz5eBsWWPldliFJ3gHhLiew/f2
         1QsogMswaYaz1/BUKkKGo98IxBbY3JUcFRyf/W9fxrhbO9l9PuAWgp9p7DwgQmfCXN
         1kbl0IsKdkxB+BFPEPCckDwZBdikUAjPhydSd0xwxdrz65y+GOlZhJX3hul1cMpGfO
         jgcZRgcm+haCHQt9iFHSnDR1bzrMnF6Q8bBz9u5GLEss7nIKzbf5GizLZRDFMtZUk0
         91eQaW3r6WpGHbQqeUx+geojFYxnr/iXHSeamApQ0d3hBjQjyqpFbQ7tKzrgjNZ09m
         EXATPoakyyGMw==
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/3] x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls
Date:   Mon, 22 Feb 2021 21:50:28 -0800
Message-Id: <a0025117242488a30621fb9858918802532f9ee9.1614059335.git.luto@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614059335.git.luto@kernel.org>
References: <cover.1614059335.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On a 32-bit fast syscall that fails to read its arguments from user
memory, the kernel currently does syscall exit work but not
syscall exit work.  This would confuse audit and ptrace.

This is a minimal fix intended for ease of backporting.  A more
complete cleanup is coming.

Cc: stable@vger.kernel.org
Fixes: 0b085e68f407 ("x86/entry: Consolidate 32/64 bit syscall entry")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 0904f5676e4d..cf4dcf346ca8 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -128,7 +128,8 @@ static noinstr bool __do_fast_syscall_32(struct pt_regs *regs)
 		regs->ax = -EFAULT;
 
 		instrumentation_end();
-		syscall_exit_to_user_mode(regs);
+		local_irq_disable();
+		exit_to_user_mode();
 		return false;
 	}
 
-- 
2.29.2

