Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D8C261C58
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbgIHTSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731137AbgIHQCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65EE2419B;
        Tue,  8 Sep 2020 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579534;
        bh=PvPPG3nMBDVF9kyjupiA0DfWma9fnhZtAJj0a4ZnnTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvUoAUgz2c5/riLh12k8uGqPu/RTlUjbeepWVjfPn0+vfINrC05FlVVgYeK8reCAX
         jitXCN5IJi/LdxN6UBxAjXqaq13/ywYI9KMqiI5zoi/q1vn3vl0x5uiMLHQ4n0KDqo
         ifbFEpT6DxIhI4SXyGVz2UchzobwOwwBf2saPjJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.8 118/186] tracing/kprobes, x86/ptrace: Fix regs argument order for i386
Date:   Tue,  8 Sep 2020 17:24:20 +0200
Message-Id: <20200908152247.355631145@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>

commit 2356bb4b8221d7dc8c7beb810418122ed90254c9 upstream.

On i386, the order of parameters passed on regs is eax,edx,and ecx
(as per regparm(3) calling conventions).

Change the mapping in regs_get_kernel_argument(), so that arg1=ax
arg2=dx, and arg3=cx.

Running the selftests testcase kprobes_args_use.tc shows the result
as passed.

Fixes: 3c88ee194c28 ("x86: ptrace: Add function argument access API")
Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200828113242.GA1424@cosmos
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -322,8 +322,8 @@ static inline unsigned long regs_get_ker
 	static const unsigned int argument_offs[] = {
 #ifdef __i386__
 		offsetof(struct pt_regs, ax),
-		offsetof(struct pt_regs, cx),
 		offsetof(struct pt_regs, dx),
+		offsetof(struct pt_regs, cx),
 #define NR_REG_ARGUMENTS 3
 #else
 		offsetof(struct pt_regs, di),


