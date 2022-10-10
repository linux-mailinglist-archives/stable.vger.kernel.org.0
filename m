Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C2C5F9965
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiJJHLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiJJHLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:11:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAF05E550;
        Mon, 10 Oct 2022 00:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2947560E75;
        Mon, 10 Oct 2022 07:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB90C433D6;
        Mon, 10 Oct 2022 07:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385615;
        bh=x0fo3YqqUYZJis+tob3naJg9hU3t1zBGM7M3bSodLh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdgOOdPnwNc3HufrXVxGp+Wcf+LaerSeOz1CB3HxwnWmwfZH2i9sBgVP2qN7WZyy6
         b6FQQoRogvj30Al1g3cFeUTLtMoaBs1P09jvLUh7ViO/f6omp6Tmh6oxBdCyXS/5fS
         XuXCi6gfH7zLIVAQ/idzTdua1T9B2J4eTDBXRx9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.19 45/48] bpf: Gate dynptr API behind CAP_BPF
Date:   Mon, 10 Oct 2022 09:05:43 +0200
Message-Id: <20221010070334.864403313@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 8addbfc7b308d591f8a5f2f6bb24d08d9d79dfbb upstream.

This has been enabled for unprivileged programs for only one kernel
release, hence the expected annoyances due to this move are low. Users
using ringbuf can stick to non-dynptr APIs. The actual use cases dynptr
is meant to serve may not make sense in unprivileged BPF programs.

Hence, gate these helpers behind CAP_BPF and limit use to privileged
BPF programs.

Fixes: 263ae152e962 ("bpf: Add bpf_dynptr_from_mem for local dynptrs")
Fixes: bc34dee65a65 ("bpf: Dynptr support for ring buffers")
Fixes: 13bbbfbea759 ("bpf: Add bpf_dynptr_read and bpf_dynptr_write")
Fixes: 34d4ef5775f7 ("bpf: Add dynptr data slices")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220921143550.30247-1-memxor@gmail.com
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/helpers.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1f961f9982d2..3814b0fd3a2c 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1627,26 +1627,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ringbuf_discard_proto;
 	case BPF_FUNC_ringbuf_query:
 		return &bpf_ringbuf_query_proto;
-	case BPF_FUNC_ringbuf_reserve_dynptr:
-		return &bpf_ringbuf_reserve_dynptr_proto;
-	case BPF_FUNC_ringbuf_submit_dynptr:
-		return &bpf_ringbuf_submit_dynptr_proto;
-	case BPF_FUNC_ringbuf_discard_dynptr:
-		return &bpf_ringbuf_discard_dynptr_proto;
 	case BPF_FUNC_for_each_map_elem:
 		return &bpf_for_each_map_elem_proto;
 	case BPF_FUNC_loop:
 		return &bpf_loop_proto;
 	case BPF_FUNC_strncmp:
 		return &bpf_strncmp_proto;
-	case BPF_FUNC_dynptr_from_mem:
-		return &bpf_dynptr_from_mem_proto;
-	case BPF_FUNC_dynptr_read:
-		return &bpf_dynptr_read_proto;
-	case BPF_FUNC_dynptr_write:
-		return &bpf_dynptr_write_proto;
-	case BPF_FUNC_dynptr_data:
-		return &bpf_dynptr_data_proto;
 	default:
 		break;
 	}
@@ -1675,6 +1661,20 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_timer_cancel_proto;
 	case BPF_FUNC_kptr_xchg:
 		return &bpf_kptr_xchg_proto;
+	case BPF_FUNC_ringbuf_reserve_dynptr:
+		return &bpf_ringbuf_reserve_dynptr_proto;
+	case BPF_FUNC_ringbuf_submit_dynptr:
+		return &bpf_ringbuf_submit_dynptr_proto;
+	case BPF_FUNC_ringbuf_discard_dynptr:
+		return &bpf_ringbuf_discard_dynptr_proto;
+	case BPF_FUNC_dynptr_from_mem:
+		return &bpf_dynptr_from_mem_proto;
+	case BPF_FUNC_dynptr_read:
+		return &bpf_dynptr_read_proto;
+	case BPF_FUNC_dynptr_write:
+		return &bpf_dynptr_write_proto;
+	case BPF_FUNC_dynptr_data:
+		return &bpf_dynptr_data_proto;
 	default:
 		break;
 	}
-- 
2.38.0



