Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B1239C690
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 09:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFEHSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 03:18:44 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45960 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229850AbhFEHSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Jun 2021 03:18:43 -0400
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv0PcJLtgBoMKAA--.12002S3;
        Sat, 05 Jun 2021 15:16:44 +0800 (CST)
Subject: Re: [PATCH 4.19 0/9] bpf: fix verifier selftests on inefficient
 unaligned access architectures
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <70c92574-ab22-1a04-067e-4c933ef75a9a@loongson.cn>
Date:   Sat, 5 Jun 2021 15:16:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Dxv0PcJLtgBoMKAA--.12002S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJryrWry3JFW8ArWxJw1fWFg_yoW8Zry5pa
        y0gFZ8tr4kt3Wxua47AF4UuFWrZ3sYgw4UC3Wftr98AF18AryxJr4Iga4YyF9xKrZ3Wr1F
        v34aqFn5Gw1fXFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvqb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG
        8wCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0x
        ZFpf9x07bo-BiUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/02/2021 11:27 AM, Tiezhu Yang wrote:
> With the following patch series, all verifier selftests pass on the archs which
> select HAVE_EFFICIENT_UNALIGNED_ACCESS.
>
> [v2,4.19,00/19] bpf: fix verifier selftests, add CVE-2021-29155, CVE-2021-33200 fixes
> https://patchwork.kernel.org/project/netdevbpf/cover/20210528103810.22025-1-ovidiu.panait@windriver.com/
>
> But on inefficient unaligned access architectures, there still exist many failures,
> so some patches about F_NEEDS_EFFICIENT_UNALIGNED_ACCESS are also needed, backport
> to 4.19 with a minor context difference.
>
> This patch series is based on the series (all now queued up by greg k-h):
> "bpf: fix verifier selftests, add CVE-2021-29155, CVE-2021-33200 fixes".
>
> Björn Töpel (2):
>    selftests/bpf: add "any alignment" annotation for some tests
>    selftests/bpf: Avoid running unprivileged tests with alignment
>      requirements
>
> Daniel Borkmann (2):
>    bpf: fix test suite to enable all unpriv program types
>    bpf: test make sure to run unpriv test cases in test_verifier
>
> David S. Miller (4):
>    bpf: Add BPF_F_ANY_ALIGNMENT.
>    bpf: Adjust F_NEEDS_EFFICIENT_UNALIGNED_ACCESS handling in
>      test_verifier.c
>    bpf: Make more use of 'any' alignment in test_verifier.c
>    bpf: Apply F_NEEDS_EFFICIENT_UNALIGNED_ACCESS to more ACCEPT test
>      cases.
>
> Joe Stringer (1):
>    selftests/bpf: Generalize dummy program types
>
>   include/uapi/linux/bpf.h                    |  14 ++
>   kernel/bpf/syscall.c                        |   7 +-
>   kernel/bpf/verifier.c                       |   3 +
>   tools/include/uapi/linux/bpf.h              |  14 ++
>   tools/lib/bpf/bpf.c                         |   8 +-
>   tools/lib/bpf/bpf.h                         |   2 +-
>   tools/testing/selftests/bpf/test_align.c    |   4 +-
>   tools/testing/selftests/bpf/test_verifier.c | 224 ++++++++++++++++++++--------
>   8 files changed, 206 insertions(+), 70 deletions(-)
>

Hi Greg and Sasha,

Could you please apply this series to 4.19?
Any comments will be much appreciated.

Thanks,
Tiezhu

