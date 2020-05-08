Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E391CAF4B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgEHMol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729202AbgEHMok (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A174A208D6;
        Fri,  8 May 2020 12:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941880;
        bh=1o0gSLN65wnBazfUXKQMQspxu1GQn+XKikflHRodYxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8zn79nSSqkld8jKcZwafPW5byxD2kQtcglSQebkylxcdSUokhkeGyj317B0kmvQJ
         g6cyH0IoVJmckqN6DxYtU326JHEWKMNTQFBN1+m19OpjRQsprrzOgIGO/dJPNEPdvM
         k1noeB9qJVdgkvkt8nR6CymRVHmueyuDxMJsfSno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zi Shen Lim <zlim.lnx@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Yang Shi <yang.shi@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 209/312] arm64: bpf: jit JMP_JSET_{X,K}
Date:   Fri,  8 May 2020 14:33:20 +0200
Message-Id: <20200508123139.110546969@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zi Shen Lim <zlim.lnx@gmail.com>

commit 98397fc547e3f4553553a30ea56fa34d613f0a4c upstream.

Original implementation commit e54bcde3d69d ("arm64: eBPF JIT compiler")
had the relevant code paths, but due to an oversight always fail jiting.

As a result, we had been falling back to BPF interpreter whenever a BPF
program has JMP_JSET_{X,K} instructions.

With this fix, we confirm that the corresponding tests in lib/test_bpf
continue to pass, and also jited.

...
[    2.784553] test_bpf: #30 JSET jited:1 188 192 197 PASS
[    2.791373] test_bpf: #31 tcpdump port 22 jited:1 325 677 625 PASS
[    2.808800] test_bpf: #32 tcpdump complex jited:1 323 731 991 PASS
...
[    3.190759] test_bpf: #237 JMP_JSET_K: if (0x3 & 0x2) return 1 jited:1 110 PASS
[    3.192524] test_bpf: #238 JMP_JSET_K: if (0x3 & 0xffffffff) return 1 jited:1 98 PASS
[    3.211014] test_bpf: #249 JMP_JSET_X: if (0x3 & 0x2) return 1 jited:1 120 PASS
[    3.212973] test_bpf: #250 JMP_JSET_X: if (0x3 & 0xffffffff) return 1 jited:1 89 PASS
...

Fixes: e54bcde3d69d ("arm64: eBPF JIT compiler")
Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Yang Shi <yang.shi@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/net/bpf_jit_comp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -482,6 +482,7 @@ emit_cond_jmp:
 		case BPF_JGE:
 			jmp_cond = A64_COND_CS;
 			break;
+		case BPF_JSET:
 		case BPF_JNE:
 			jmp_cond = A64_COND_NE;
 			break;


