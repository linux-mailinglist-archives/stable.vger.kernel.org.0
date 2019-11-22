Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C177510701B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfKVLUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbfKVKp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6795D20721;
        Fri, 22 Nov 2019 10:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419555;
        bh=DuCIBAqhdSOob/5HkZMdAhgQxPJHm9GEVLYGMGLpj1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w86FkkepnUtIBAUAgCBRxNY02ieV6Ea3Ps404fGEqBe/QyjZIGvlKSrQ6Z83l4OW6
         /osV3H1M6069vz8af7jlBkuRh3LhJGAdvq7DMHyRZmdlFIZOIHjU9eH9ldAYVuoGdL
         pTHmJADWKKXgLDVve7CodShmswvULIqsont5JStw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Francis Deslauriers <francis.deslauriers@efficios.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Yonghong Song <yhs@fb.com>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 151/222] uprobes/x86: Prohibit probing on MOV SS instruction
Date:   Fri, 22 Nov 2019 11:28:11 +0100
Message-Id: <20191122100913.646743449@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 13ebe18c94f5b0665c01ae7fad2717ae959f4212 upstream.

Since MOV SS and POP SS instructions will delay the exceptions until the
next instruction is executed, single-stepping on it by uprobes must be
prohibited.

uprobe already rejects probing on POP SS (0x1f), but allows probing on MOV
SS (0x8e and reg == 2).  This checks the target instruction and if it is
MOV SS or POP SS, returns -ENOTSUPP to reject probing.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc: Francis Deslauriers <francis.deslauriers@efficios.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S . Miller" <davem@davemloft.net>
Link: https://lkml.kernel.org/r/152587072544.17316.5950935243917346341.stgit@devbox
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/uprobes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -296,6 +296,10 @@ static int uprobe_init_insn(struct arch_
 	if (is_prefix_bad(insn))
 		return -ENOTSUPP;
 
+	/* We should not singlestep on the exception masking instructions */
+	if (insn_masking_exception(insn))
+		return -ENOTSUPP;
+
 	if (x86_64)
 		good_insns = good_insns_64;
 	else


