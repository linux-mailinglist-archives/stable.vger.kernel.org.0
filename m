Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039496B40F2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCJNr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjCJNrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:47:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D2128E58
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:47:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F871B822B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED793C4339B;
        Fri, 10 Mar 2023 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456071;
        bh=6k/HhNsnH/lT4EmMAQnzHkROL1C8ldJ2w93wWqbYNQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyKZRP6WvUjvUhUTS0HLItfmJrFUvh8ldjt4S+/n1+PPkmVOSW1FXGiINbaI4hi7Z
         9dufCBqeM7gLG8ogg3qs3B6j15/u/5yK1xm68AGnTlrdPnxpjtYsSiUNkksKjpz0XY
         r8cHhkecpYYW0nOT7i0n/Lit3zsp2jJcP9vNLirI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 041/193] s390/bpf: Add expoline to tail calls
Date:   Fri, 10 Mar 2023 14:37:03 +0100
Message-Id: <20230310133712.342108970@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit bb4ef8fc3d193ed8d5583fb47cbeff5d8fb8302f ]

All the indirect jumps in the eBPF JIT already use expolines, except
for the tail call one.

Fixes: de5cb6eb514e ("s390: use expoline thunks in the BPF JIT")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20230129190501.1624747-3-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 60029baaa72ad..f2b516f8a3a64 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1119,8 +1119,16 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		/* lg %r1,bpf_func(%r1) */
 		EMIT6_DISP_LH(0xe3000000, 0x0004, REG_1, REG_1, REG_0,
 			      offsetof(struct bpf_prog, bpf_func));
-		/* bc 0xf,tail_call_start(%r1) */
-		_EMIT4(0x47f01000 + jit->tail_call_start);
+		if (nospec_uses_trampoline()) {
+			jit->seen |= SEEN_FUNC;
+			/* aghi %r1,tail_call_start */
+			EMIT4_IMM(0xa70b0000, REG_1, jit->tail_call_start);
+			/* brcl 0xf,__s390_indirect_jump_r1 */
+			EMIT6_PCREL_RILC(0xc0040000, 0xf, jit->r1_thunk_ip);
+		} else {
+			/* bc 0xf,tail_call_start(%r1) */
+			_EMIT4(0x47f01000 + jit->tail_call_start);
+		}
 		/* out: */
 		jit->labels[0] = jit->prg;
 		break;
-- 
2.39.2



