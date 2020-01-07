Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E853133205
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgAGVG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbgAGVGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36F052077B;
        Tue,  7 Jan 2020 21:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431182;
        bh=cqmuP6+aWyyH4B13fvBC7PZfi6hpHU/Y2FNOvIebqFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ji6oG3zQS2mN2Qh47fxo/T3AvCT+81QFvrl81ZzHKL1wRO6HnLak9JUx7HeHzWtKV
         xopzaU39DwKoWOa6baSqObf5nzCqP5juEO6VD5nnf7wrwd5DwB6C3JEfLGZXE7YUgq
         q1WqhP84ueNcgzC71Q2w+/nD6cV9PzMMM2W3oKmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zong Li <zong.li@sifive.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH 4.19 067/115] riscv: ftrace: correct the condition logic in function graph tracer
Date:   Tue,  7 Jan 2020 21:54:37 +0100
Message-Id: <20200107205303.691218306@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong Li <zong.li@sifive.com>

commit 1d8f65798240b6577d8c44d20c8ea8f1d429e495 upstream.

The condition should be logical NOT to assign the hook address to parent
address. Because the return value 0 of function_graph_enter upon
success.

Fixes: e949b6db51dc (riscv/function_graph: Simplify with function_graph_enter())
Signed-off-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/kernel/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -142,7 +142,7 @@ void prepare_ftrace_return(unsigned long
 	 */
 	old = *parent;
 
-	if (function_graph_enter(old, self_addr, frame_pointer, parent))
+	if (!function_graph_enter(old, self_addr, frame_pointer, parent))
 		*parent = return_hooker;
 }
 


