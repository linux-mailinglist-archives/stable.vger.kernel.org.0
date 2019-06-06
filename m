Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96BD370D5
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 11:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfFFJvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 05:51:53 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45450 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfFFJvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 05:51:52 -0400
Received: by mail-ot1-f66.google.com with SMTP id n2so377337otl.12
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 02:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AV8fJarscGYKje4gCjshW9wa5X9218dEb3ry+YcSgUQ=;
        b=Jc9qGVhmitFNrnLTYV/gy7MBxmU93AD5TgMKoWyFKakIoJjSiphSLnkeVRDiAeEV0O
         LGgMeKZ0FEBiBoqCgms1ngkWK9DRE/nxRp/eU0eXHCKLuB8Bf0A2ZIVnVxFsYEgegJFN
         wu286TM0/aFYDvDyaPtqwyzPIMI/GfdcD9+EQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AV8fJarscGYKje4gCjshW9wa5X9218dEb3ry+YcSgUQ=;
        b=ZOqhST4U5rsUrMT9QU/2oYcEB45XOLMyS313opfd/sqpipCEzerTDVrgOchMoPFOou
         dsRDESZZBXi/2uJwIHouCnoTFbm3dycNknFP/pyc8PGqV6wuNLr+vcAKfso/bqrG+rDl
         UYYrxvLx7f0FmFlRvh+cZpGpvdhq5VF3CyzhtLqjF+737bySYoQ8KznaSbry9CzANF0K
         rQFkVEZ/P9fKDi0sVby2JdJmSQVxEPI2iE1wM5aQm00+OI6MAj/k+MXzoWuSj4GGwOvQ
         bmjeF0RJvKtqNruzVpENwq6sfH93lexs+F4DPOt2dpHep8okEPNsS1czsWMXuMODi4ln
         lczg==
X-Gm-Message-State: APjAAAWDkq7Ynuj+iwdPj4Ou/yXRJem+QlGJcAMSaNCjE/SthWsJ9QkT
        5sPYaiYXInyx07zFkNO37WIFMKqgycNuleZjudcS+OIWI00=
X-Google-Smtp-Source: APXvYqzkMjpIHjQaJYvwGX9etPuorv7LAaYLAReyc8m5t5AKRS0vZI722h2f8O8koJYCS1TeMF1yUGmGfI1RBC+sGqQ=
X-Received: by 2002:a05:6830:2116:: with SMTP id i22mr14219692otc.318.1559814711167;
 Thu, 06 Jun 2019 02:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <CA+wXwBT6+zov5MyPH7XvVZX1JDzviisW2FHUu=G9jHpVCSfeeg@mail.gmail.com>
 <20190606011942.GH29739@sasha-vm>
In-Reply-To: <20190606011942.GH29739@sasha-vm>
From:   Daniel Dao <dqminh@cloudflare.com>
Date:   Thu, 6 Jun 2019 10:51:39 +0100
Message-ID: <CA+wXwBRqcU2Vrso1nDPOjbux970vddb2-96subT6ht2rcZXYhQ@mail.gmail.com>
Subject: Re: Kernel 4.19.47 with commit 8715ce033eb37f539e73b1570bf56404b21d46cd
 failed to execute NX-protected page
To:     Sasha Levin <sashal@kernel.org>
Cc:     namit@vmware.com, kernel-team <kernel-team@cloudflare.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 6, 2019 at 2:19 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, Jun 05, 2019 at 03:04:26PM +0100, Daniel Dao wrote:
> >Hi there,
> >
> >We are testing kernel 4.19.47 with some tools utilizing kprobe,
> >resulting in panics that look like:
> >
> >[ 1085.318031] kernel tried to execute NX-protected page - exploit
> >attempt? (uid: 65534)
> >[ 1085.334028] BUG: unable to handle kernel paging request at ffffffffc0428000
> >[ 1085.349128] PGD 13a3e10067 P4D 13a3e10067 PUD 13a3e12067 PMD
> >c1e860067 PTE 8000000bbd075061
> >[ 1085.365779] Oops: 0011 [#1] SMP KASAN PTI
> >[ 1085.377879] CPU: 30 PID: 29734 Comm: nginx-fl Tainted: G    B
> >O      4.19.47-cloudflare-kasan-2019.6.0 #2019.6.0
> >[ 1085.396652] Hardware name: Quanta Computer Inc QuantaPlex
> >T41S-2U/S2S-MB, BIOS S2S_3B10.03 06/21/2018
> >[ 1085.414041] RIP: 0010:0xffffffffc0428000
> >[ 1085.425965] Code: Bad RIP value.
> >[ 1085.436832] RSP: 0018:ffff88a015e2fb18 EFLAGS: 00010246
> >[ 1085.449853] RAX: 0000000000000003 RBX: ffff889f73448900 RCX: 0000000000000218
> >[ 1085.464719] RDX: ffff889fe4893c00 RSI: 0000000000000002 RDI: ffff889f73448900
> >[ 1085.479626] RBP: ffff88a015e2fe18 R08: 0000000000000006 R09: 0000000000000000
> >[ 1085.494677] R10: 000000008a08850a R11: 0000000000000000 R12: ffff889f7344890c
> >[ 1085.509890] R13: ffff889f73448c54 R14: ffff889f73448c7a R15: 0000000000002c19
> >[ 1085.525252] FS:  00007f51582f5680(0000) GS:ffff88a03fb80000(0000)
> >knlGS:0000000000000000
> >[ 1085.541810] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[ 1085.555812] CR2: ffffffffc0427fd6 CR3: 0000002039fee004 CR4: 00000000001606e0
> >[ 1085.571154] Call Trace:
> >[ 1085.581676]  ? tcp_set_state+0x5/0x5b0
> >[ 1085.593532]  ? tcp_v4_connect+0xbd7/0x2000
> >[ 1085.605809]  ? tcp_sk_init+0x1220/0x1220
> >[ 1085.617810]  ? selinux_socket_connect_helper.isra.55+0x277/0x400
> >[ 1085.631808]  ? sock_poll+0x218/0x300
> >[ 1085.643407]  ? selinux_netcache_avc_callback+0x30/0x30
> >[ 1085.656701]  ? __inet_stream_connect+0x630/0xbd0
> >[ 1085.669508]  ? expand_files.part.9+0x640/0x640
> >[ 1085.682145]  ? ipip_gro_complete+0x110/0x110
> >[ 1085.694627]  ? __inet_stream_connect+0xbd0/0xbd0
> >[ 1085.707397]  ? inet_stream_connect+0x53/0xa0
> >[ 1085.719830]  ? __sys_connect+0x1f6/0x270
> >[ 1085.731964]  ? __ia32_sys_accept+0xb0/0xb0
> >[ 1085.744201]  ? mutex_lock+0x85/0xe0
> >[ 1085.755815]  ? ep_show_fdinfo+0x3c0/0x3c0
> >[ 1085.767916]  ? syscall_trace_enter+0x566/0xc30
> >[ 1085.780429]  ? __x64_sys_epoll_ctl+0x237/0x1080
> >[ 1085.792883]  ? exit_to_usermode_loop+0x140/0x140
> >[ 1085.805425]  ? __audit_syscall_exit+0x73e/0xa30
> >[ 1085.817925]  ? __x64_sys_connect+0x6f/0xb0
> >[ 1085.829915]  ? do_syscall_64+0x8e/0x280
> >[ 1085.841539]  ? prepare_exit_to_usermode+0xe1/0x140
> >[ 1085.854067]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >[ 1085.867000] Modules linked in: xt_length xt_connlimit nf_conncount
> >xt_hashlimit iptable_security sch_fq md_mod dm_crypt algif_skcipher
> >af_alg dm_mod dax ip6table_nat nf_nat_ipv6 ip6table_mangle
> >ip6table_security ip6table_raw xt_nat iptable_nat nf_nat_ipv4 nf_nat
> >xt_TPROXY nf_tproxy_ipv6 nf_tproxy_ipv4 xt_connmark iptable_mangle
> >xt_owner ip6table_filter ip6_tables xt_CT xt_socket nf_socket_ipv4
> >nf_socket_ipv6 iptable_raw nfnetlink_log xt_NFLOG xt_bpf xt_comment
> >xt_conntrack xt_mark xt_multiport xt_set xt_tcpudp ipt_GLBREDIRECT(O)
> >nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 fou ip6_udp_tunnel
> >udp_tunnel iptable_filter bpfilter ip_set_hash_netport ip_set_hash_net
> >ip_set_hash_ip ip_set nfnetlink sit ipip tunnel4 ip_tunnel tun 8021q
> >garp stp mrp llc sb_edac x86_pkg_temp_thermal kvm_intel kvm irqbypass
> >[ 1085.996378]  crc32_pclmul crc32c_intel pcbc aesni_intel aes_x86_64
> >ipmi_ssif crypto_simd cryptd glue_helper intel_cstate intel_uncore
> >sfc(O) intel_rapl_perf tpm_tis tpm_tis_core mdio tpm ipmi_si
> >ipmi_devintf ipmi_msghandler efivarfs ip_tables x_tables
> >
> >Reproducible steps on my local machine are as follow:
> >1. Run kernel 4.19.47
> >2. We are going to test kprobe on tcp_set_state using
> >https://github.com/iovisor/bcc/blob/master/tools/tcplife.py. But
> >probably any workload utilizing kprobe would work
> >    - Run some workload that creating tcp connections. I'm runing
> >`python -m SimpleHTTPServer` and `wrk -d60s -c10
> >http://localhost:8000`
> >    - Run the script
> >https://github.com/iovisor/bcc/blob/master/tools/tcplife.py. Expect it
> >to not crash the kernel and producing some output
> >
> >Reverting commit 8715ce033eb37f539e73b1570bf56404b21d46cd makes it
> >work for me locally. I also tested kernel
> >5.2.0-rc3-00024-g788a024921c4 locally (latest Linus tree) and not
> >seeing the issue, so maybe somewhere along the backporting process, we
> >failed to backport all the required patches ?
>
> Uh, that might indeed be the case. Could you try cherry picking the
> following 3 patches on top of your 4.19 tree and trying again?
>
> git cherry-pick d2a68c4effd821f0871d20368f76b609349c8a3b 3c0dab44e22782359a0a706cbce72de99a22aa75 7298e24f904224fa79eb8fd7e0fbd78950ccf2db

I cant reproduce after cherry picking the 3 patches on top of 4.19.47.

Thanks,
Daniel.
