Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9EA0611EFB
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 03:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiJ2BSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 21:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiJ2BSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 21:18:50 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EB120FB15
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 18:18:49 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id i127so7906967ybc.11
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 18:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=slDZbTLn5r+CoQsZvxjlRQM4l7ZQz2W3wx+JfLaqr98=;
        b=cIlLq6PAwkqiXXXn6c67z8whCKspaofSQ/9DWTDJQvK9tl5rsZ/BjJCsTbNWj0w5iP
         odlwi1BYuuFhculoBCwUEQXqvn1i3jcwqNEyFdwQt6kukql6v0f3MXml9zinWlHV5h7h
         8IgowAWu8xfEK6tc19cHWbymkcn1GswMfHHyVE6kjK0O9KIaq0FMjmCbO5vK1LxSwkyT
         wWXoLSrpgHUZJIbKKsOxaZULSoq2cv4Yhn2nrOY/tKU9LRE3bP6RLhD/lnxaRewMSpqQ
         xHuR2BgB3dHcbpvXj4v5mJz41KiejJ6gLOjX/YbgvQJXTuyIV22UtuaLgePvYWjOa3NS
         OL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=slDZbTLn5r+CoQsZvxjlRQM4l7ZQz2W3wx+JfLaqr98=;
        b=5ty3mEdMKuxSsQAccdLL+51FSGbS31LMjDyfExp8nUq35dEUKicDBCj3blMdpct+86
         lWYq1c7BSmDdsWMeIc/DHe2mKjBlBC3G0kUwa2UX78MN0im9E7d63voSBfEQZWRGJHWG
         fwo52U0c/tZPeHqvO3beKBCJTMvE79AHVFHuDiG5IbsScjJtXRdrS37JHxOuhWtO5FEO
         5t5OhxAgkLt4Iswm4HF4Pb0XBZhJayZx5y5xHchDQAt84Y/uyWuXCJXpwJxt3K+Ya1r3
         jOb1J0x+zHIpMOFEMTpao94Smh3Rujj0nMGk0l1TvVQowLEju16xkKSJdsCL0aMnQ5vm
         zACw==
X-Gm-Message-State: ACrzQf0NP2BFztbtdb4CrsgUUi+abUqVyyaB+/tQo6ErjmVNzU5/3Q7I
        TCtGp5h5seA4apij5oV1kgexqWgAUETf4Su+GysaWA==
X-Google-Smtp-Source: AMsMyM4My+8are69qRAY9S2gtxp8RO+EhLpWtO0plmEiR5VvpH6Qbugf5IG3Oz6ORHJlrHJl0CCrBjx6WpNavq9iVVg=
X-Received: by 2002:a25:e207:0:b0:6ca:268b:10c3 with SMTP id
 h7-20020a25e207000000b006ca268b10c3mr1763060ybe.407.1667006328347; Fri, 28
 Oct 2022 18:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20221024113005.376059449@linuxfoundation.org> <20221029011211.4049810-1-ovt@google.com>
In-Reply-To: <20221029011211.4049810-1-ovt@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 28 Oct 2022 18:18:36 -0700
Message-ID: <CANn89iLVb+zHBXhPrD7JAdawLwAAYP_Fc3Vt3YB1AAy1fj=F4w@mail.gmail.com>
Subject: Re: [PATCH 5.4 086/255] once: add DO_ONCE_SLOW() for sleepable contexts
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     gregkh@linuxfoundation.org, christophe.leroy@csgroup.eu,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 6:12 PM Oleksandr Tymoshenko <ovt@google.com> wrote:
>
> Hello,
>
> This commit causes the following panic in kernel built with clang
> (GCC build is not affected):
>
> [    8.320308] BUG: unable to handle page fault for address: ffffffff97216c6a                                        [26/4066]
> [    8.330029] #PF: supervisor write access in kernel mode
> [    8.337263] #PF: error_code(0x0003) - permissions violation
> [    8.344816] PGD 12e816067 P4D 12e816067 PUD 12e817063 PMD 800000012e2001e1
> [    8.354337] Oops: 0003 [#1] SMP PTI
> [    8.359178] CPU: 2 PID: 437 Comm: curl Not tainted 5.4.220 #15
> [    8.367241] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> [    8.378529] RIP: 0010:__do_once_slow_done+0xf/0xa0
> [    8.384962] Code: 1b 84 db 74 0c 48 c7 c7 80 ce 8d 97 e8 fa e9 4a 00 84 db 0f 94 c0 5b 5d c3 66 90 55 48 89 e5 41 57 41 56
> 53 49 89 d7 49 89 f6 <c6> 07 01 48 c7 c7 80 ce 8d 97 e8 d2 e9 4a 00 48 8b 3d 9b de c9 00
> [    8.409066] RSP: 0018:ffffb764c02d3c90 EFLAGS: 00010246
> [    8.415697] RAX: 4f51d3d06bc94000 RBX: d474b86ddf7162eb RCX: 000000007229b1d6
> [    8.424805] RDX: 0000000000000000 RSI: ffffffff9791b4a0 RDI: ffffffff97216c6a
> [    8.434108] RBP: ffffb764c02d3ca8 R08: 0e81c130f1159fc1 R09: 1d19d60ce0b52c77
> [    8.443408] R10: 8ea59218e6892b1f R11: d5260237a3c1e35c R12: ffff9c3dadd42600
> [    8.452468] R13: ffffffff97910f80 R14: ffffffff9791b4a0 R15: 0000000000000000
> [    8.461416] FS:  00007eff855b40c0(0000) GS:ffff9c3db7a80000(0000) knlGS:0000000000000000
> [    8.471632] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    8.478763] CR2: ffffffff97216c6a CR3: 000000022ded0000 CR4: 00000000000006a0
> [    8.487789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    8.496684] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    8.505443] Call Trace:
> [    8.508568]  __inet_hash_connect+0x523/0x530
> [    8.513839]  ? inet_hash_connect+0x50/0x50
> [    8.518818]  ? secure_ipv4_port_ephemeral+0x69/0xe0
> [    8.525003]  tcp_v4_connect+0x2c5/0x410
> [    8.529858]  __inet_stream_connect+0xd7/0x360
> [    8.535329]  ? _raw_spin_unlock+0xe/0x10
> ... skipped ...
>
>
> The root cause is the difference in __section macro semantics between 5.4 and
> later LTS releases. On 5.4 it stringifies the argument so the ___done
> symbol is created in a bogus section ".data.once", with double quotes:
>
> % readelf -S vmlinux | grep data.once
>   [ 5] ".data.once"      PROGBITS         ffffffff82216c6a  01416c6a

Yes, this has been discovered earlier today.

Look at Google-Bug-Id 256204637

(include/linux/mmdebug.h has a similar issue)

Thanks.
