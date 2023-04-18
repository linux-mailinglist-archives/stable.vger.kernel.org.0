Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C34F6E63C8
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjDRMnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbjDRMnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:43:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E241446D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CDDD63321
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D77C433EF;
        Tue, 18 Apr 2023 12:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821789;
        bh=T56x003GmgG+Wn2UewwsZMQpg9ril0zeHstqYDHIV2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ce614aL4y6/9p/6Cdk2w9YxpbAFBh9LWaHhp4oFxJ8CU+U70FJdsXz2sDtYnR56zF
         I/YJG+CdGamBO/dNI+5ZODYjPMM2h+u3pmWGIiDdn4UtVw6fAhK7mmdOgMAAKw4mK9
         cbPwO1kL8ukpPuNIM7fXakK8YWH1o06mFWTH5CnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, George Guo <guodongtai@kylinos.cn>,
        Daniel Borkmann <daniel@iogearbox.net>,
        WANG Xuerui <git@xen0n.name>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/134] LoongArch, bpf: Fix jit to skip speculation barrier opcode
Date:   Tue, 18 Apr 2023 14:21:36 +0200
Message-Id: <20230418120314.335916209@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Guo <guodongtai@kylinos.cn>

[ Upstream commit a6f6a95f25803500079513780d11a911ce551d76 ]

Just skip the opcode(BPF_ST | BPF_NOSPEC) in the BPF JIT instead of
failing to JIT the entire program, given LoongArch currently has no
couterpart of a speculation barrier instruction. To verify the issue,
use the ltp testcase as shown below.

Also, Wang says:

  I can confirm there's currently no speculation barrier equivalent
  on LonogArch. (Loongson says there are builtin mitigations for
  Spectre-V1 and V2 on their chips, and AFAIK efforts to port the
  exploits to mips/LoongArch have all failed a few years ago.)

Without this patch:

  $ ./bpf_prog02
  [...]
  bpf_common.c:123: TBROK: Failed verification: ??? (524)
  [...]
  Summary:
  passed   0
  failed   0
  broken   1
  skipped  0
  warnings 0

With this patch:

  $ ./bpf_prog02
  [...]
  Summary:
  passed   0
  failed   0
  broken   0
  skipped  0
  warnings 0

Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: WANG Xuerui <git@xen0n.name>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/bpf/20230328071335.2664966-1-guodongtai@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index 2467bfb8889a9..82b4402810da0 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -955,6 +955,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 		emit_atomic(insn, ctx);
 		break;
 
+	/* Speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
+
 	default:
 		pr_err("bpf_jit: unknown opcode %02x\n", code);
 		return -EINVAL;
-- 
2.39.2



