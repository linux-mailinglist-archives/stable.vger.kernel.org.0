Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACE9328A9E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhCASUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:20:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239309AbhCASOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:14:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B06FF64E38;
        Mon,  1 Mar 2021 17:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620123;
        bh=EGQN54Ymvb8+0zhCacNLIY1ay2EdJOvFaCpwQ2xvMIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STh0GVFaP6Y6l9s6/Y2JS3113PaLeQ4ecmmVA5+U53QZa9y7DgUV0UhXWLyvm+c42
         kOKzsp5Uufacuv/0OGClQOD1vlaMycHhByJTJVWrmxqm7w0hyQmM4701BbaBP4CTBS
         VtxWnEYlbSdtcN8kFSrWqZaUotthKZfFHqELMrh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 5.11 008/775] kdb: Make memory allocations more robust
Date:   Mon,  1 Mar 2021 17:02:56 +0100
Message-Id: <20210301161202.118996226@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

commit 93f7a6d818deef69d0ba652d46bae6fbabbf365c upstream.

Currently kdb uses in_interrupt() to determine whether its library
code has been called from the kgdb trap handler or from a saner calling
context such as driver init. This approach is broken because
in_interrupt() alone isn't able to determine kgdb trap handler entry from
normal task context. This can happen during normal use of basic features
such as breakpoints and can also be trivially reproduced using:
echo g > /proc/sysrq-trigger

We can improve this by adding check for in_dbg_master() instead which
explicitly determines if we are running in debugger context.

Cc: stable@vger.kernel.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Link: https://lore.kernel.org/r/1611313556-4004-1-git-send-email-sumit.garg@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_private.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -230,7 +230,7 @@ extern struct task_struct *kdb_curr_task
 
 #define kdb_task_has_cpu(p) (task_curr(p))
 
-#define GFP_KDB (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
+#define GFP_KDB (in_dbg_master() ? GFP_ATOMIC : GFP_KERNEL)
 
 extern void *debug_kmalloc(size_t size, gfp_t flags);
 extern void debug_kfree(void *);


