Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7014A683137
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjAaPSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbjAaPSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:18:17 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998BF45BEA;
        Tue, 31 Jan 2023 07:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1675178186;
        bh=ef9Tt/UsbJRvNjzO4j1FZEBc8SF5MQJAlbohpOz9LEI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mfaZkS72+7A/jP2ZUGIQ8OiWNGvRhGmszDMYeYUPQup65pFCOaflsUVm9zc1yPYij
         WcEjgefJvQldTY9xUXbCx7DTvd9NDnpkH69xV/wBdNdjFN5Q0G5JHvhmgkIyxupkHe
         krREaYFVi0pd9775S+4YVrpgkYqY/R5O+agZN0EWfKZv/JG6VS9u/v0oPnbUZs1bEl
         phVt25kx3PLFoJGEH0BKLMF3P2eZBVSu3NsRmGBnh6Z0JA8NX/6ov/QXomrfiDJVYr
         udsOGn3rdavNiiBhjsn7jTvIhkT1xWivwkI9MwMSheUPXbLfcANp7uivetdt+hyLul
         4zUZVoqCSSI9A==
Received: from [172.16.0.188] (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P5pY55k65zhyZ;
        Tue, 31 Jan 2023 10:16:25 -0500 (EST)
Message-ID: <edad4f4d-f19e-34dc-06f5-7d30fd5d058f@efficios.com>
Date:   Tue, 31 Jan 2023 10:17:05 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH bpf-next 1/2] selftests: bpf: Fix incorrect kernel headers
 search path
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        bpf <bpf@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        stable <stable@vger.kernel.org>
References: <20230130183549.85471-1-mathieu.desnoyers@efficios.com>
 <CAADnVQLve5je3GKesCjn5HhuxgOe2u1OX7GQnx-58dsuUFWbZQ@mail.gmail.com>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <CAADnVQLve5je3GKesCjn5HhuxgOe2u1OX7GQnx-58dsuUFWbZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-30 16:03, Alexei Starovoitov wrote:
> On Mon, Jan 30, 2023 at 10:36 AM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
>> building against kernel headers from the build environment in scenarios
>> where kernel headers are installed into a specific output directory
>> (O=...).
>>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>> Cc: <bpf@vger.kernel.org>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Cc: linux-kselftest@vger.kernel.org
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Alexei Starovoitov <ast@kernel.org>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Andrii Nakryiko <andrii@kernel.org>
>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>> Cc: Song Liu <song@kernel.org>
>> Cc: Yonghong Song <yhs@fb.com>
>> Cc: John Fastabend <john.fastabend@gmail.com>
>> Cc: KP Singh <kpsingh@kernel.org>
>> Cc: Stanislav Fomichev <sdf@google.com>
>> Cc: Hao Luo <haoluo@google.com>
>> Cc: Jiri Olsa <jolsa@kernel.org>
>> Cc: Mykola Lysenko <mykolal@fb.com>
>> Cc: <stable@vger.kernel.org>    [5.18+]
>> ---
>>   tools/testing/selftests/bpf/Makefile | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>> index c22c43bbee19..6998c816afef 100644
>> --- a/tools/testing/selftests/bpf/Makefile
>> +++ b/tools/testing/selftests/bpf/Makefile
>> @@ -327,7 +327,7 @@ endif
>>   CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
>>   BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)          \
>>               -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
>> -            -I$(abspath $(OUTPUT)/../usr/include)
>> +            $(KHDR_INCLUDES)
> 
> It breaks the build:
> https://github.com/kernel-patches/bpf/actions/runs/4047075637/jobs/6960655246
> 
> make[1]: *** No rule to make target '/linux/bpf.h', needed by
> '/tmp/work/bpf/bpf/tools/testing/selftests/bpf/bpf-helpers.rst'. Stop.

I finally figured out why I did not catch it in my own testing: it appears
that the bpf selftest is special: it's not built when issuing "make" from
tools/testing/selftests/. Perhaps that's also why Shuah did not see any
issues with my bpf patches:

tools/testing/selftests/Makefile:

# User can optionally provide a TARGETS skiplist.  By default we skip
# BPF since it has cutting edge build time dependencies which require
# more effort to install.
SKIP_TARGETS ?= bpf

It appears that the baseline bpf selftest on v6.2-rc6 does not build on
my system:

   CLNG-BPF [test_maps] test_bpf_nf.bpf.o
progs/test_bpf_nf.c:156:7: error: no member named 'mark' in 'struct nf_conn'
                 ct->mark = 77;
                 ~~  ^
progs/test_bpf_nf.c:160:42: error: use of undeclared identifier 'NF_NAT_MANIP_SRC'
                 bpf_ct_set_nat_info(ct, &saddr, sport, NF_NAT_MANIP_SRC);
                                                        ^
progs/test_bpf_nf.c:163:42: error: use of undeclared identifier 'NF_NAT_MANIP_DST'
                 bpf_ct_set_nat_info(ct, &daddr, dport, NF_NAT_MANIP_DST);
                                                        ^
progs/test_bpf_nf.c:187:38: error: no member named 'mark' in 'struct nf_conn'
                                 test_insert_lookup_mark = ct_lk->mark;
                                                           ~~~~~  ^
progs/test_bpf_nf.c:189:12: error: use of undeclared identifier 'IPS_CONFIRMED'
                                                      IPS_CONFIRMED | IPS_SEEN_REPLY);
                                                      ^
progs/test_bpf_nf.c:189:28: error: use of undeclared identifier 'IPS_SEEN_REPLY'
                                                      IPS_CONFIRMED | IPS_SEEN_REPLY);
                                                                      ^
progs/test_bpf_nf.c:209:11: error: no member named 'mark' in 'struct nf_conn'
                 if (ct->mark == 42) {
                     ~~  ^
progs/test_bpf_nf.c:210:8: error: no member named 'mark' in 'struct nf_conn'
                         ct->mark++;
                         ~~  ^
progs/test_bpf_nf.c:211:33: error: no member named 'mark' in 'struct nf_conn'
                         test_exist_lookup_mark = ct->mark;
                                                  ~~  ^
9 errors generated.

Based on this:
https://lore.kernel.org/bpf/37649bee-5eb3-93a2-ac57-56eb375ef8cd@iogearbox.net/

It appears that NF_CONNTRACK_MARK should be set to =y. Perhaps it should be
detected at selftest build time and skipped rather than failing to build ? It
appears to be a case where a user-space selftest depends on internal kernel data
structures:

Ref. include/net/netfilter/nf_conntrack.h:struct nf_conn

After setting this config option, it fails at:

   GEN-SKEL [test_progs] test_kfunc_dynptr_param.skel.h
libbpf: sec '?lsm.s/bpf': corrupted program 'not_ptr_to_stack', offset 48, size 0
Error: failed to open BPF object file: Invalid argument
make: *** [Makefile:546: /home/efficios/git/linux/tools/testing/selftests/bpf/test_kfunc_dynptr_param.skel.h] Error 234
make: *** Deleting file '/home/efficios/git/linux/tools/testing/selftests/bpf/test_kfunc_dynptr_param.skel.h'

Based on this issue: https://github.com/libbpf/libbpf-bootstrap/issues/12 it appears
that bpf selftests are only meant to be used against a set of pre-specified kernel configurations.
README.rst confirms that. So let's use tools/testing/selftests/bpf/config.x86_64
with make olddefconfig for my kernel build then. It would have been less unexpected for the
bpf selftests to report incorrect or missing kernel config options rather than limiting the
supported set to specific configuration files provided by the bpf selftests. This limits
the testing coverage to very few kernel configurations.

It still does not work. I need to explicitly enable BPF_SYSCALL=y which is not present in
the bpf selftests config.x86_64. Then I can explicitly reenable DEBUG_INFO_BTF=y. It appears
that config.x86_64 is outdated in the bpf selftests. It also misses NF_CONNTRACK_MARK=y.
So let's assume that config.x86_64 is outdated and broken and go with
tools/testing/selftests/bpf/config followed by make olddefconfig.

No more luck, this time the bpf kernel config misses the DEBUG_KERNEL=y, which is needed
for DEBUG_INFO and DEBUG_INFO_BTF.

Now it's:

   CLANG   /home/efficios/git/linux/tools/testing/selftests/bpf/tools/build/bpftool/profiler.bpf.o
skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof' to an incomplete type 'struct bpf_perf_event_value'
         __uint(value_size, sizeof(struct bpf_perf_event_value));
[...]

And that's where I give up. Has anyone else succeeded in building bpf selftests locally ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

