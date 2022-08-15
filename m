Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2387594908
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355280AbiHOXrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354287AbiHOXoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:44:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1547586C00;
        Mon, 15 Aug 2022 13:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37824B80EA9;
        Mon, 15 Aug 2022 20:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A53C433D6;
        Mon, 15 Aug 2022 20:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594441;
        bh=FiWPRepBVlrOCz8sETsw5mhm5qijt3xISAdoOf8lMx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoCaXMUxiL2QDD0u6ambXfpv2ppLFGduAE3RYKe/XZy7ZgUvQeztF1/Ym/XQvzYre
         lUcLbgj09Vf7F77JhL3vPFqPMXYK6R2C9pty4Ag3HaQWf9BGUYGGsLHG8aLRicXDj0
         xJxqn4Um+UkBqYg/iwmZC1AyB+Ior/+r8mZgJ2TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixun Lan <dlan@gentoo.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Amjad OULED-AMEUR <ouledameur.amjad@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0449/1157] libbpf, riscv: Use a0 for RC register
Date:   Mon, 15 Aug 2022 19:56:45 +0200
Message-Id: <20220815180457.555616682@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yixun Lan <dlan@gentoo.org>

[ Upstream commit 935dc35c75318fa213d26808ad8bb130fb0b486e ]

According to the RISC-V calling convention register usage here [0], a0
is used as return value register, so rename it to make it consistent
with the spec.

  [0] section 18.2, table 18.2
      https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf

Fixes: 589fed479ba1 ("riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h")
Signed-off-by: Yixun Lan <dlan@gentoo.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Amjad OULED-AMEUR <ouledameur.amjad@gmail.com>
Link: https://lore.kernel.org/bpf/20220706140204.47926-1-dlan@gentoo.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 01ce121c302d..11f9096407fc 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -233,7 +233,7 @@ struct pt_regs___arm64 {
 #define __PT_PARM5_REG a4
 #define __PT_RET_REG ra
 #define __PT_FP_REG s0
-#define __PT_RC_REG a5
+#define __PT_RC_REG a0
 #define __PT_SP_REG sp
 #define __PT_IP_REG pc
 /* riscv does not select ARCH_HAS_SYSCALL_WRAPPER. */
-- 
2.35.1



