Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECE34FBAEA
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 13:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344742AbiDKLc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 07:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245270AbiDKLcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 07:32:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CA33EF3D
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 04:30:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81C8E61584
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 11:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884DBC385A4;
        Mon, 11 Apr 2022 11:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649676637;
        bh=bkUIk10vrOVoWZmafk837qUFVsGWOoSb6CwajV+KVUY=;
        h=Subject:To:Cc:From:Date:From;
        b=yHfJGWeNZPQ1TnYd3/p0yfCaChYoEu+V0C1Pu1E/gI4coq4w6VkcNHbO9s74Fc2/C
         eN0ayokveueCeJGpHz1ybwl1uZ31MVuAfAg62UQ7ib1dEKG4wVEhoQjzYcaS8+hXOf
         u0U0Po5jImgdJiIDlbitzHn3qF29UQT+b5f7Q0To=
Subject: FAILED: patch "[PATCH] bpf: Treat bpf_sk_lookup remote_port as a 2-byte field" failed to apply to 5.16-stable tree
To:     jakub@cloudflare.com, ast@kernel.org, kafai@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 13:30:34 +0200
Message-ID: <1649676634204182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 058ec4a7d9cf77238c73ad9f1e1a3ed9a29afcab Mon Sep 17 00:00:00 2001
From: Jakub Sitnicki <jakub@cloudflare.com>
Date: Sat, 19 Mar 2022 19:33:54 +0100
Subject: [PATCH] bpf: Treat bpf_sk_lookup remote_port as a 2-byte field

In commit 9a69e2b385f4 ("bpf: Make remote_port field in struct
bpf_sk_lookup 16-bit wide") the remote_port field has been split up and
re-declared from u32 to be16.

However, the accompanying changes to the context access converter have not
been well thought through when it comes big-endian platforms.

Today 2-byte wide loads from offsetof(struct bpf_sk_lookup, remote_port)
are handled as narrow loads from a 4-byte wide field.

This by itself is not enough to create a problem, but when we combine

 1. 32-bit wide access to ->remote_port backed by a 16-wide wide load, with
 2. inherent difference between litte- and big-endian in how narrow loads
    need have to be handled (see bpf_ctx_narrow_access_offset),

we get inconsistent results for a 2-byte loads from &ctx->remote_port on LE
and BE architectures. This in turn makes BPF C code for the common case of
2-byte load from ctx->remote_port not portable.

To rectify it, inform the context access converter that remote_port is
2-byte wide field, and only 1-byte loads need to be treated as narrow
loads.

At the same time, we special-case the 4-byte load from &ctx->remote_port to
continue handling it the same way as do today, in order to keep the
existing BPF programs working.

Fixes: 9a69e2b385f4 ("bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20220319183356.233666-2-jakub@cloudflare.com

diff --git a/net/core/filter.c b/net/core/filter.c
index 03655f2074ae..a7044e98765e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10989,13 +10989,24 @@ static bool sk_lookup_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
-	case offsetof(struct bpf_sk_lookup, remote_port) ...
-	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
 	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
 	case bpf_ctx_range(struct bpf_sk_lookup, ingress_ifindex):
 		bpf_ctx_record_field_size(info, sizeof(__u32));
 		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u32));
 
+	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
+		/* Allow 4-byte access to 2-byte field for backward compatibility */
+		if (size == sizeof(__u32))
+			return true;
+		bpf_ctx_record_field_size(info, sizeof(__be16));
+		return bpf_ctx_narrow_access_ok(off, size, sizeof(__be16));
+
+	case offsetofend(struct bpf_sk_lookup, remote_port) ...
+	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
+		/* Allow access to zero padding for backward compatibility */
+		bpf_ctx_record_field_size(info, sizeof(__u16));
+		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u16));
+
 	default:
 		return false;
 	}
@@ -11077,6 +11088,11 @@ static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
 						     sport, 2, target_size));
 		break;
 
+	case offsetofend(struct bpf_sk_lookup, remote_port):
+		*target_size = 2;
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+		break;
+
 	case offsetof(struct bpf_sk_lookup, local_port):
 		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
 				      bpf_target_off(struct bpf_sk_lookup_kern,

