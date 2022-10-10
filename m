Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6245F98FF
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiJJHFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiJJHEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:04:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B502558B78;
        Mon, 10 Oct 2022 00:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF0F860E7F;
        Mon, 10 Oct 2022 07:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3935C433D7;
        Mon, 10 Oct 2022 07:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385456;
        bh=Jaz0AY+s7g0Ayj++Xk/Qjt2WzNkoORlTkMLlmVWP6jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahiCzZEMVvLwwo6G2msOO/DNVlP/fTBjpzrMF5Yf5GZGc3tAy4POWpUXdpUuSXI6v
         FGFe/O7+SLKEkDAbX+T/45+ADUv/jF0oZreAVifcRoYwK3SpV1WShajhnwcItBHSWh
         DM+UFy39DrV7hovaLW9lkfk1i19QGO3GmHVMCW8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 14/17] bpf: Gate dynptr API behind CAP_BPF
Date:   Mon, 10 Oct 2022 09:04:37 +0200
Message-Id: <20221010070330.633241098@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
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
 kernel/bpf/helpers.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1627,26 +1627,12 @@ bpf_base_func_proto(enum bpf_func_id fun
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
@@ -1675,6 +1661,20 @@ bpf_base_func_proto(enum bpf_func_id fun
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


