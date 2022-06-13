Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E7A54953F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbiFMM5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355306AbiFMM4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFB012756;
        Mon, 13 Jun 2022 04:16:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE6EF608C3;
        Mon, 13 Jun 2022 11:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69D2C34114;
        Mon, 13 Jun 2022 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119012;
        bh=N3txV4yHwqjSWgO5zKiV3UT5OkRIaAkmgOgP1nAZgNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yh7gMQag6poBKtCuWrQaRThKdHxX9jZipzyqRVGbm97IWMGg5vhYjc5GCraNe1FGE
         slsBsFGIwaX0hUxFLbGttr4PglHwpu2zeNaSkX7XFzgBtgpVTjlyMD6q5QPjd5HOVB
         IH1IBwtoX7iBI+497L+EZeJLUDLfYq0HmXheLExM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <imagedong@tencent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/247] bpf: Fix probe read error in ___bpf_prog_run()
Date:   Mon, 13 Jun 2022 12:09:44 +0200
Message-Id: <20220613094925.443589455@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit caff1fa4118cec4dfd4336521ebd22a6408a1e3e ]

I think there is something wrong with BPF_PROBE_MEM in ___bpf_prog_run()
in big-endian machine. Let's make a test and see what will happen if we
want to load a 'u16' with BPF_PROBE_MEM.

Let's make the src value '0x0001', the value of dest register will become
0x0001000000000000, as the value will be loaded to the first 2 byte of
DST with following code:

  bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));

Obviously, the value in DST is not correct. In fact, we can compare
BPF_PROBE_MEM with LDX_MEM_H:

  DST = *(SIZE *)(unsigned long) (SRC + insn->off);

If the memory load is done by LDX_MEM_H, the value in DST will be 0x1 now.

And I think this error results in the test case 'test_bpf_sk_storage_map'
failing:

  test_bpf_sk_storage_map:PASS:bpf_iter_bpf_sk_storage_map__open_and_load 0 nsec
  test_bpf_sk_storage_map:PASS:socket 0 nsec
  test_bpf_sk_storage_map:PASS:map_update 0 nsec
  test_bpf_sk_storage_map:PASS:socket 0 nsec
  test_bpf_sk_storage_map:PASS:map_update 0 nsec
  test_bpf_sk_storage_map:PASS:socket 0 nsec
  test_bpf_sk_storage_map:PASS:map_update 0 nsec
  test_bpf_sk_storage_map:PASS:attach_iter 0 nsec
  test_bpf_sk_storage_map:PASS:create_iter 0 nsec
  test_bpf_sk_storage_map:PASS:read 0 nsec
  test_bpf_sk_storage_map:FAIL:ipv6_sk_count got 0 expected 3
  $10/26 bpf_iter/bpf_sk_storage_map:FAIL

The code of the test case is simply, it will load sk->sk_family to the
register with BPF_PROBE_MEM and check if it is AF_INET6. With this patch,
now the test case 'bpf_iter' can pass:

  $10  bpf_iter:OK

Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/bpf/20220524021228.533216-1-imagedong@tencent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 6e3ae90ad107..48eb9c329da6 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1652,6 +1652,11 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		CONT;							\
 	LDX_MEM_##SIZEOP:						\
 		DST = *(SIZE *)(unsigned long) (SRC + insn->off);	\
+		CONT;							\
+	LDX_PROBE_MEM_##SIZEOP:						\
+		bpf_probe_read_kernel(&DST, sizeof(SIZE),		\
+				      (const void *)(long) (SRC + insn->off));	\
+		DST = *((SIZE *)&DST);					\
 		CONT;
 
 	LDST(B,   u8)
@@ -1659,15 +1664,6 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 	LDST(W,  u32)
 	LDST(DW, u64)
 #undef LDST
-#define LDX_PROBE(SIZEOP, SIZE)							\
-	LDX_PROBE_MEM_##SIZEOP:							\
-		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));	\
-		CONT;
-	LDX_PROBE(B,  1)
-	LDX_PROBE(H,  2)
-	LDX_PROBE(W,  4)
-	LDX_PROBE(DW, 8)
-#undef LDX_PROBE
 
 #define ATOMIC_ALU_OP(BOP, KOP)						\
 		case BOP:						\
-- 
2.35.1



