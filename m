Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D933A32843C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhCAQbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:31:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234546AbhCAQ06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:26:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4525764E12;
        Mon,  1 Mar 2021 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615727;
        bh=iPXy742P8sRdpLi3cQoN84MtFgXqylTY+KqIjcXKuNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLDfInZwEVvHmx0Cp/lYxgFpgDSN3A25pgPx1vgrT1/6n6VRqheg6HoWbMRMkYhZP
         +95VPCmRtaTnqBvgBC6g5twLPk4b+KiWDYalLO9/0/vXzW8jAxs/ofdP7u9dB7oebi
         9onmbxpdE2GCjAr22vTiYfTBPCUU+lHiLvxYWkDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 4.9 009/134] kdb: Make memory allocations more robust
Date:   Mon,  1 Mar 2021 17:11:50 +0100
Message-Id: <20210301161014.036724218@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
@@ -234,7 +234,7 @@ extern struct task_struct *kdb_curr_task
 #define	kdb_do_each_thread(g, p) do_each_thread(g, p)
 #define	kdb_while_each_thread(g, p) while_each_thread(g, p)
 
-#define GFP_KDB (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
+#define GFP_KDB (in_dbg_master() ? GFP_ATOMIC : GFP_KERNEL)
 
 extern void *debug_kmalloc(size_t size, gfp_t flags);
 extern void debug_kfree(void *);


