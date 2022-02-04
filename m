Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A064A9570
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 09:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiBDIrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 03:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiBDIrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 03:47:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB518C061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 00:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D58460F16
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 08:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8627C004E1;
        Fri,  4 Feb 2022 08:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643964423;
        bh=X3fZbEv8G7DF14ybADZhQna6yjOrw+3Hagh2ZawgI00=;
        h=Subject:To:Cc:From:Date:From;
        b=Plhp+dcDx5ekW9/UrJhQWsQF+899B+mKGNpW2kSrJ4xuOwYPk4muc7P7UlAe/VDGX
         hGX6E3o2v7taevflOhAt8dI9JlVJ64DzWs9UEu3N9oh7Klj29tN63v4B0ortAM/mQ9
         OFze5kT4nmzVgnYncZCXNBEE5W73Q/2WDi+nqTkQ=
Subject: FAILED: patch "[PATCH] bpf: Fix possible race in inc_misses_counter" failed to apply to 5.15-stable tree
To:     hefengqing@huawei.com, ast@kernel.org, john.fastabend@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Feb 2022 09:47:00 +0100
Message-ID: <164396442065149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0e3135d3bfa5dfb658145238d2bc723a8e30c3a3 Mon Sep 17 00:00:00 2001
From: He Fengqing <hefengqing@huawei.com>
Date: Sat, 22 Jan 2022 10:29:36 +0000
Subject: [PATCH] bpf: Fix possible race in inc_misses_counter

It seems inc_misses_counter() suffers from same issue fixed in
the commit d979617aa84d ("bpf: Fixes possible race in update_prog_stats()
for 32bit arches"):
As it can run while interrupts are enabled, it could
be re-entered and the u64_stats syncp could be mangled.

Fixes: 9ed9e9ba2337 ("bpf: Count the number of times recursion was prevented")
Signed-off-by: He Fengqing <hefengqing@huawei.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20220122102936.1219518-1-hefengqing@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 4b6974a195c1..5e7edf913060 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -550,11 +550,12 @@ static __always_inline u64 notrace bpf_prog_start_time(void)
 static void notrace inc_misses_counter(struct bpf_prog *prog)
 {
 	struct bpf_prog_stats *stats;
+	unsigned int flags;
 
 	stats = this_cpu_ptr(prog->stats);
-	u64_stats_update_begin(&stats->syncp);
+	flags = u64_stats_update_begin_irqsave(&stats->syncp);
 	u64_stats_inc(&stats->misses);
-	u64_stats_update_end(&stats->syncp);
+	u64_stats_update_end_irqrestore(&stats->syncp, flags);
 }
 
 /* The logic is similar to bpf_prog_run(), but with an explicit

