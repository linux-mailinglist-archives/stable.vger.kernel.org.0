Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D65647017
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 13:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiLHMxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 07:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLHMxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 07:53:02 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7673A37F8F;
        Thu,  8 Dec 2022 04:53:01 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NSYwW0f9hz4xDn;
        Thu,  8 Dec 2022 23:52:59 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        linuxppc-dev@lists.ozlabs.org,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        linux-kernel@vger.kernel.org, Hao Luo <haoluo@google.com>,
        stable@vger.kernel.org, KP Singh <kpsingh@kernel.org>,
        Song Liu <song@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
In-Reply-To: <757acccb7fbfc78efa42dcf3c974b46678198905.1669278887.git.christophe.leroy@csgroup.eu>
References: <757acccb7fbfc78efa42dcf3c974b46678198905.1669278887.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v2] powerpc/bpf/32: Fix Oops on tail call tests
Message-Id: <167050396505.1462730.10974040872245094646.b4-ty@ellerman.id.au>
Date:   Thu, 08 Dec 2022 23:52:45 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 24 Nov 2022 09:37:27 +0100, Christophe Leroy wrote:
> test_bpf tail call tests end up as:
> 
>   test_bpf: #0 Tail call leaf jited:1 85 PASS
>   test_bpf: #1 Tail call 2 jited:1 111 PASS
>   test_bpf: #2 Tail call 3 jited:1 145 PASS
>   test_bpf: #3 Tail call 4 jited:1 170 PASS
>   test_bpf: #4 Tail call load/store leaf jited:1 190 PASS
>   test_bpf: #5 Tail call load/store jited:1
>   BUG: Unable to handle kernel data access on write at 0xf1b4e000
>   Faulting instruction address: 0xbe86b710
>   Oops: Kernel access of bad area, sig: 11 [#1]
>   BE PAGE_SIZE=4K MMU=Hash PowerMac
>   Modules linked in: test_bpf(+)
>   CPU: 0 PID: 97 Comm: insmod Not tainted 6.1.0-rc4+ #195
>   Hardware name: PowerMac3,1 750CL 0x87210 PowerMac
>   NIP:  be86b710 LR: be857e88 CTR: be86b704
>   REGS: f1b4df20 TRAP: 0300   Not tainted  (6.1.0-rc4+)
>   MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 28008242  XER: 00000000
>   DAR: f1b4e000 DSISR: 42000000
>   GPR00: 00000001 f1b4dfe0 c11d2280 00000000 00000000 00000000 00000002 00000000
>   GPR08: f1b4e000 be86b704 f1b4e000 00000000 00000000 100d816a f2440000 fe73baa8
>   GPR16: f2458000 00000000 c1941ae4 f1fe2248 00000045 c0de0000 f2458030 00000000
>   GPR24: 000003e8 0000000f f2458000 f1b4dc90 3e584b46 00000000 f24466a0 c1941a00
>   NIP [be86b710] 0xbe86b710
>   LR [be857e88] __run_one+0xec/0x264 [test_bpf]
>   Call Trace:
>   [f1b4dfe0] [00000002] 0x2 (unreliable)
>   Instruction dump:
>   XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>   XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>   ---[ end trace 0000000000000000 ]---
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/bpf/32: Fix Oops on tail call tests
      https://git.kernel.org/powerpc/c/89d21e259a94f7d5582ec675aa445f5a79f347e4

cheers
