Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DBA6AEE7C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbjCGSM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjCGSMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:12:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCE5B1EDF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:07:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DFAAB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94185C433D2;
        Tue,  7 Mar 2023 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212443;
        bh=i9g6zKE+Wtd2csyMjTlCwKpkgabrcx4AQVnLJ+7ATS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgdjHCDXjzY47/x2S/NLC/sTXPufh50wSFPcUFUT0nf1rpyA8/zEmqMnogKpikwjI
         z4aAhrS/XhFfluaXzjr7oi4mDZkJO2Q+GQcFypDTlVUw477Rg71hIiJmmKokSRqc74
         oG8UiqFoGVY6xlXT1bWYibdg/8WrJkeQxbNrLv0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/885] s390/bpf: Add expoline to tail calls
Date:   Tue,  7 Mar 2023 17:52:00 +0100
Message-Id: <20230307170010.085031885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index af35052d06ed6..fbdba4c306bea 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1393,8 +1393,16 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
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
 		if (jit->prg_buf) {
 			*(u16 *)(jit->prg_buf + patch_1_clrj + 2) =
-- 
2.39.2



