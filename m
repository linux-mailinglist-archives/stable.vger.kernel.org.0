Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D24064339F
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbiLETiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbiLEThr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:37:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E8F25E9A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:34:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FF13B81157
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D33BC433C1;
        Mon,  5 Dec 2022 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268878;
        bh=LNwKC9H6fFmnsHVuI5+dKR/faf6ur31AcxhBeRPaJiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOHydUX8AvmyjoKs6QGctD6DQxEPa260BUvdCRXRo63BUYTAm5/DB8NhpUrBXDhKK
         riFRQVbAUtAxk1Ue9LDo+iwJXA+IGGNwlQ13EyKUnJb/kPWpdmX/ADQJ8eqEhZ4xGJ
         IQaYgf9pomthWGlHzUUnheNOyVlAGKAIyw6jXlBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hou Tao <houtao1@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/120] bpf, perf: Use subprog name when reporting subprog ksymbol
Date:   Mon,  5 Dec 2022 20:09:17 +0100
Message-Id: <20221205190807.096590249@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 47df8a2f78bc34ff170d147d05b121f84e252b85 ]

Since commit bfea9a8574f3 ("bpf: Add name to struct bpf_ksym"), when
reporting subprog ksymbol to perf, prog name instead of subprog name is
used. The backtrace of bpf program with subprogs will be incorrect as
shown below:

  ffffffffc02deace bpf_prog_e44a3057dcb151f8_overwrite+0x66
  ffffffffc02de9f7 bpf_prog_e44a3057dcb151f8_overwrite+0x9f
  ffffffffa71d8d4e trace_call_bpf+0xce
  ffffffffa71c2938 perf_call_bpf_enter.isra.0+0x48

overwrite is the entry program and it invokes the overwrite_htab subprog
through bpf_loop, but in above backtrace, overwrite program just jumps
inside itself.

Fixing it by using subprog name when reporting subprog ksymbol. After
the fix, the output of perf script will be correct as shown below:

  ffffffffc031aad2 bpf_prog_37c0bec7d7c764a4_overwrite_htab+0x66
  ffffffffc031a9e7 bpf_prog_c7eb827ef4f23e71_overwrite+0x9f
  ffffffffa3dd8d4e trace_call_bpf+0xce
  ffffffffa3dc2938 perf_call_bpf_enter.isra.0+0x48

Fixes: bfea9a8574f3 ("bpf: Add name to struct bpf_ksym")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20221114095733.158588-1-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 60cb300fa0d0..44f982b73640 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9077,7 +9077,7 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
 				PERF_RECORD_KSYMBOL_TYPE_BPF,
 				(u64)(unsigned long)subprog->bpf_func,
 				subprog->jited_len, unregister,
-				prog->aux->ksym.name);
+				subprog->aux->ksym.name);
 		}
 	}
 }
-- 
2.35.1



