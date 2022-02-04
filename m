Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C334A96BB
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357612AbiBDJ26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358126AbiBDJ1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:27:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EE6C061396;
        Fri,  4 Feb 2022 01:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA2AB817E5;
        Fri,  4 Feb 2022 09:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EBEC004E1;
        Fri,  4 Feb 2022 09:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966784;
        bh=K9TQuAKmn9gn136ka9eVPS6oux3fxlfTkn6mn0Acqxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dY+EqGkdKQNx2aF/ZJHwVwSdUdvEw/zFHMJLpmd7Xo1gl/QFgFJPUnFpef60r6Zlz
         gi6G2FTn0ij8vy0nV7REivn0gLs43tVHSmVPDOSz+2taknPcAkO1/bP7D3A/3Ly14f
         cWWqyYCMDcUW9ZywWPkwg13Kxc9HyVdHKUUssShg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Fengqing <hefengqing@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.16 38/43] bpf: Fix possible race in inc_misses_counter
Date:   Fri,  4 Feb 2022 10:22:45 +0100
Message-Id: <20220204091918.402198487@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Fengqing <hefengqing@huawei.com>

commit 0e3135d3bfa5dfb658145238d2bc723a8e30c3a3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/trampoline.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -542,11 +542,12 @@ static __always_inline u64 notrace bpf_p
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


