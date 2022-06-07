Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D45854181D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379092AbiFGVJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378603AbiFGVHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:07:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D56B212C87;
        Tue,  7 Jun 2022 11:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F52C6176D;
        Tue,  7 Jun 2022 18:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB88C385A2;
        Tue,  7 Jun 2022 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627843;
        bh=1Nut9CRMqLigdsqkyxIk7KKSPWoZoP6lmxG2cVbPM1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYQnOHrhLIq2+c4/yFezJuNf2cWfOTGpaQ2P0vtdbJLmJPOLev2IsHfB/BV2sFTc9
         QdjuR32RtJ7WaZF3d0fSMS1kk547jX7/0fmGT7M02TtVsAflAbXh6oyE195UZ2GGgq
         HI1NWHTwd0Z+YsKMQBTdaHzFv97KyV/7JCfgpgG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Runqing Yang <rainkin1993@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 073/879] libbpf: Fix a bug with checking bpf_probe_read_kernel() support in old kernels
Date:   Tue,  7 Jun 2022 18:53:11 +0200
Message-Id: <20220607165004.810672935@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Runqing Yang <rainkin1993@gmail.com>

[ Upstream commit d252a4a499a07bec21c65873f605c3a1ef52ffed ]

Background:
Libbpf automatically replaces calls to BPF bpf_probe_read_{kernel,user}
[_str]() helpers with bpf_probe_read[_str](), if libbpf detects that
kernel doesn't support new APIs. Specifically, libbpf invokes the
probe_kern_probe_read_kernel function to load a small eBPF program into
the kernel in which bpf_probe_read_kernel API is invoked and lets the
kernel checks whether the new API is valid. If the loading fails, libbpf
considers the new API invalid and replaces it with the old API.

static int probe_kern_probe_read_kernel(void)
{
	struct bpf_insn insns[] = {
		BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),	/* r1 = r10 (fp) */
		BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),	/* r1 += -8 */
		BPF_MOV64_IMM(BPF_REG_2, 8),		/* r2 = 8 */
		BPF_MOV64_IMM(BPF_REG_3, 0),		/* r3 = 0 */
		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_probe_read_kernel),
		BPF_EXIT_INSN(),
	};
	int fd, insn_cnt = ARRAY_SIZE(insns);

	fd = bpf_prog_load(BPF_PROG_TYPE_KPROBE, NULL,
                           "GPL", insns, insn_cnt, NULL);
	return probe_fd(fd);
}

Bug:
On older kernel versions [0], the kernel checks whether the version
number provided in the bpf syscall, matches the LINUX_VERSION_CODE.
If not matched, the bpf syscall fails. eBPF However, the
probe_kern_probe_read_kernel code does not set the kernel version
number provided to the bpf syscall, which causes the loading process
alwasys fails for old versions. It means that libbpf will replace the
new API with the old one even the kernel supports the new one.

Solution:
After a discussion in [1], the solution is using BPF_PROG_TYPE_TRACEPOINT
program type instead of BPF_PROG_TYPE_KPROBE because kernel does not
enfoce version check for tracepoint programs. I test the patch in old
kernels (4.18 and 4.19) and it works well.

  [0] https://elixir.bootlin.com/linux/v4.19/source/kernel/bpf/syscall.c#L1360
  [1] Closes: https://github.com/libbpf/libbpf/issues/473

Signed-off-by: Runqing Yang <rainkin1993@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220409144928.27499-1-rainkin1993@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 809fe209cdcc..dabf9a1451c3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4587,7 +4587,7 @@ static int probe_kern_probe_read_kernel(void)
 	};
 	int fd, insn_cnt = ARRAY_SIZE(insns);
 
-	fd = bpf_prog_load(BPF_PROG_TYPE_KPROBE, NULL, "GPL", insns, insn_cnt, NULL);
+	fd = bpf_prog_load(BPF_PROG_TYPE_TRACEPOINT, NULL, "GPL", insns, insn_cnt, NULL);
 	return probe_fd(fd);
 }
 
-- 
2.35.1



