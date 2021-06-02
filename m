Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6107F397F7A
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 05:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhFBD3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 23:29:47 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45696 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230511AbhFBD3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 23:29:46 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH0O6+rZgh7MIAA--.9496S2;
        Wed, 02 Jun 2021 11:27:54 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 4.19 0/9] bpf: fix verifier selftests on inefficient unaligned access architectures
Date:   Wed,  2 Jun 2021 11:27:44 +0800
Message-Id: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxH0O6+rZgh7MIAA--.9496S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1fAF4kXFW7Xw13Cr17KFg_yoW8AF4rpa
        y8KFZ0kF4kt3Wxua47AF4UGrWrXwnYgw4UC3Wxtr1qyF18Ary8Jr4Iga45tr98Kr93Xr1F
        v34akFn3Gw13XFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk2b7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF04k2
        0xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUyHUqUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With the following patch series, all verifier selftests pass on the archs which
select HAVE_EFFICIENT_UNALIGNED_ACCESS.

[v2,4.19,00/19] bpf: fix verifier selftests, add CVE-2021-29155, CVE-2021-33200 fixes
https://patchwork.kernel.org/project/netdevbpf/cover/20210528103810.22025-1-ovidiu.panait@windriver.com/

But on inefficient unaligned access architectures, there still exist many failures,
so some patches about F_NEEDS_EFFICIENT_UNALIGNED_ACCESS are also needed, backport
to 4.19 with a minor context difference.

This patch series is based on the series (all now queued up by greg k-h):
"bpf: fix verifier selftests, add CVE-2021-29155, CVE-2021-33200 fixes".

Björn Töpel (2):
  selftests/bpf: add "any alignment" annotation for some tests
  selftests/bpf: Avoid running unprivileged tests with alignment
    requirements

Daniel Borkmann (2):
  bpf: fix test suite to enable all unpriv program types
  bpf: test make sure to run unpriv test cases in test_verifier

David S. Miller (4):
  bpf: Add BPF_F_ANY_ALIGNMENT.
  bpf: Adjust F_NEEDS_EFFICIENT_UNALIGNED_ACCESS handling in
    test_verifier.c
  bpf: Make more use of 'any' alignment in test_verifier.c
  bpf: Apply F_NEEDS_EFFICIENT_UNALIGNED_ACCESS to more ACCEPT test
    cases.

Joe Stringer (1):
  selftests/bpf: Generalize dummy program types

 include/uapi/linux/bpf.h                    |  14 ++
 kernel/bpf/syscall.c                        |   7 +-
 kernel/bpf/verifier.c                       |   3 +
 tools/include/uapi/linux/bpf.h              |  14 ++
 tools/lib/bpf/bpf.c                         |   8 +-
 tools/lib/bpf/bpf.h                         |   2 +-
 tools/testing/selftests/bpf/test_align.c    |   4 +-
 tools/testing/selftests/bpf/test_verifier.c | 224 ++++++++++++++++++++--------
 8 files changed, 206 insertions(+), 70 deletions(-)

-- 
2.1.0

