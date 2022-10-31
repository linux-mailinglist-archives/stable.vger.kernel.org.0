Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42712613D4D
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 19:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiJaS11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 14:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJaS10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 14:27:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBC4D80;
        Mon, 31 Oct 2022 11:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9CDC61277;
        Mon, 31 Oct 2022 18:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB67C433C1;
        Mon, 31 Oct 2022 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667240844;
        bh=ysU1aPTGfdEz5odAft8BoDlg3O4d2ECMyJRKU6UM7+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X+4t9iQNAuMOp5R+kn5W0/iDMkNQ7Q5pAytUREOILT9TWByk3Iqsvlm9EApkzvKEF
         iz+0wfKJxETwZqiD1H9pGsBFaGrhZRl0g0aiL8zNZ5apLzLUexGpj7hjHgOutB1wvk
         AQc0Q6txql3vRJn7sITC0HeJMWcDV+nCL756jxvi2l0hJ/Tk/MwQe+A/rnShiutJSB
         CA9sRmRmQF9iAur4Y//KwrooT10Hg5YdVTwA/YlcAVcx+Q2Dfg/1l1O72uVntgxynw
         KuMlbMNyFHNtxbA8qSKKu7onaNIlLyIyPpTNc8H9Uk75UNO9uHWEZDVoBCGfVJy/NA
         vy3GckwVtzpjQ==
Date:   Mon, 31 Oct 2022 11:27:21 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     gregkh@linuxfoundation.org, christophe.leroy@csgroup.eu,
        davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, w@1wt.eu, llvm@lists.linux.dev
Subject: Re: [PATCH 5.4 086/255] once: add DO_ONCE_SLOW() for sleepable
 contexts
Message-ID: <Y2ATiXtpwPxfsOUD@dev-arch.thelio-3990X>
References: <20221024113005.376059449@linuxfoundation.org>
 <20221029011211.4049810-1-ovt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221029011211.4049810-1-ovt@google.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Oleksandr,

On Sat, Oct 29, 2022 at 01:12:11AM +0000, Oleksandr Tymoshenko wrote:
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

Thanks for the report! The reason this does not happen in mainline is
due to commit 33def8498fdd ("treewide: Convert macro and uses of
__section(foo) to __section("foo")"), which came as a result of these
issues:

https://github.com/ClangBuiltLinux/linux/issues/619
https://llvm.org/pr42950

To keep stable from diverging, it would probably be best to pick
33def8498fdd and fight through whatever conflicts there are. If that is
not a suitable solution, the next best thing would be to remove the
quotes like was done in commit bfafddd8de42 ("include/linux/compiler.h:
fix Oops for Clang-compiled kernels") for all instances of
__section(...) or __attribute__((__section__(...))), which should
resolve the specific problem you are seeing.

In the future, please feel free to cc issues that you see with clang to
llvm@lists.linux.dev so that we can chime in sooner :)

Cheers,
Nathan
