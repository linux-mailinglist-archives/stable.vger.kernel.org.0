Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F1B64ED5A
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 16:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLPPC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 10:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiLPPCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 10:02:53 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551BE4A5AC;
        Fri, 16 Dec 2022 07:02:52 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EDD6322458;
        Fri, 16 Dec 2022 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671202970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6aRkfe1bTqRS1JPzQ3SDJHlo2i2kaQZrj/hihrh+G8=;
        b=PoUnqlNQZk8IMe3QpeoajQIb3WIQNrVS+gQjdoMw634TvN6XTVOyK/nsgINnEI66IYhKru
        2GyetKaxQs3hhXYSybpzqEUyMEudVFHmZliYyGZTdYXMLLFypl5zqgnxTbJBNrvZPFmGve
        YVpud/ZrbQ1gsi1nxLJpSIYaAkaV3Fw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671202970;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6aRkfe1bTqRS1JPzQ3SDJHlo2i2kaQZrj/hihrh+G8=;
        b=96Q5AqJ8J6/V7Fn25nE3EZlbSAbDKdijqoln75k1sxnwbOK+nJMwOc/MR8ClzOkR9rlktF
        z0zvwWQ4Q9s+6LCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C825B138FD;
        Fri, 16 Dec 2022 15:02:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hkrRMJqInGMhewAAMHmgww
        (envelope-from <jwiesner@suse.de>); Fri, 16 Dec 2022 15:02:50 +0000
Received: by incl.suse.cz (Postfix, from userid 1000)
        id 196C829793; Fri, 16 Dec 2022 16:02:50 +0100 (CET)
Date:   Fri, 16 Dec 2022 16:02:50 +0100
From:   Jiri Wiesner <jwiesner@suse.de>
To:     Waiman Long <longman@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        linux-kernel@vger.kernel.org, john.p.donnelly@oracle.com,
        Hillf Danton <hdanton@sina.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Ting11 Wang =?utf-8?B?546L5am3?= <wangting11@xiaomi.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 1/6] locking/rwsem: Prevent non-first waiter from
 spinning in down_write() slowpath
Message-ID: <20221216150250.GA18361@incl>
References: <20221118022016.462070-1-longman@redhat.com>
 <20221118022016.462070-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118022016.462070-2-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 09:20:11PM -0500, Waiman Long wrote:
> A non-first waiter can potentially spin in the for loop of
> rwsem_down_write_slowpath() without sleeping but fail to acquire the
> lock even if the rwsem is free if the following sequence happens:
> 
>   Non-first RT waiter    First waiter      Lock holder
>   -------------------    ------------      -----------
>   Acquire wait_lock
>   rwsem_try_write_lock():
>     Set handoff bit if RT or
>       wait too long
>     Set waiter->handoff_set
>   Release wait_lock
>                          Acquire wait_lock
>                          Inherit waiter->handoff_set
>                          Release wait_lock
> 					   Clear owner
>                                            Release lock
>   if (waiter.handoff_set) {
>     rwsem_spin_on_owner(();
>     if (OWNER_NULL)
>       goto trylock_again;
>   }
>   trylock_again:
>   Acquire wait_lock
>   rwsem_try_write_lock():
>      if (first->handoff_set && (waiter != first))
>      	return false;
>   Release wait_lock
> 
> A non-first waiter cannot really acquire the rwsem even if it mistakenly
> believes that it can spin on OWNER_NULL value. If that waiter happens
> to be an RT task running on the same CPU as the first waiter, it can
> block the first waiter from acquiring the rwsem leading to live lock.
> Fix this problem by making sure that a non-first waiter cannot spin in
> the slowpath loop without sleeping.
> 
> Fixes: d257cc8cb8d5 ("locking/rwsem: Make handoff bit handling more consistent")
> Reviewed-and-tested-by: Mukesh Ojha <quic_mojha@quicinc.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> Cc: stable@vger.kernel.org
> ---

I was checking if commit 6eebd5fb2083 ("locking/rwsem: Allow slowpath writer to ignore handoff bit if not set by first waiter") resolves the issue that was discussed in [1]. I modified the program and script slighly:
fsim.c:
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
void sig_handle(int sig) { exit(0); }
int main(void)
{
        unsigned long c;
        signal(SIGALRM, sig_handle);
        alarm(3);
        while (1)
                c++;
}

run-fsim.sh:
#!/bin/bash
if [ ! -e fsim ]; then
        gcc -o fsim fsim.c
        if [ $? -ne 0 ]; then
                echo Failed to compile fsim
                exit -1
        fi
fi
MAX_ITERATIONS=20000
#The fsim processes are meant to run on both logical CPUs belonging to a CPU core, e.g. 1 and 129.
CPU_RANGE1="${1:-1 11}"
CPU_RANGE2="${1:-129 139}"
for i in `seq 1 $MAX_ITERATIONS`; do
        echo "Start $i/$MAX_ITERATIONS: `date`"
        for CPU in `seq $CPU_RANGE1` `seq $CPU_RANGE2`; do
                taskset -c $CPU chrt -r 10 ./fsim &>/dev/null &
                taskset -c $CPU chrt -r 20 ./fsim &>/dev/null &
                taskset -c $CPU chrt -r 30 ./fsim &>/dev/null &
                taskset -c $CPU chrt -r 40 ./fsim &>/dev/null &
        done
        echo "Wait  $i/$MAX_ITERATIONS: `date`"
        wait
done

No soft lockups were triggered but after 1.5 hours of testing, the fsim processes got stuck and only one of them was visible in the output of top:
> top - 18:45:01 up 44 min,  3 users,  load average: 72.00, 71.04, 54.81
> Tasks: 2226 total,   4 running, 2222 sleeping,   0 stopped,   0 zombie
> %Cpu(s):  0.0 us,  0.4 sy,  0.0 ni, 99.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> MiB Mem : 239777.1+total, 235671.7+free, 4332.156 used, 1435.641 buff/cache
> MiB Swap: 1023.996 total, 1023.996 free,    0.000 used. 235444.9+avail Mem
>    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
> 100666 root     -31   0       0      0      0 D 94.84 0.000  14:59.40 fsim
>  98193 root      20   0   42224   6844   3484 R 0.794 0.003   0:07.05 top
>      1 root      20   0   79220  12544   9124 S 0.000 0.005   0:11.95 systemd

All of the fsim processes got stuck at the same code path - while exiting:
> [ 2462.649033] INFO: task fsim:100600 blocked for more than 491 seconds.
> [ 2462.649036]       Tainted: G            E     N 5.14.21-sle15-sp5-221214-hoff3-7 #8
> [ 2462.649038] task:fsim            state:D stack:    0 pid:100600 ppid: 95456 flags:0x00000000
> [ 2462.649042] Call Trace:
> [ 2462.649045]  <TASK>
> [ 2462.649046]  __schedule+0x2cd/0x1140
> [ 2462.649059]  schedule+0x5c/0xc0
> [ 2462.649061]  rwsem_down_write_slowpath+0x349/0x5d0
> [ 2462.649070]  unlink_file_vma+0x2d/0x60
> [ 2462.649074]  free_pgtables+0x67/0x110
> [ 2462.649083]  exit_mmap+0xaf/0x1f0
> [ 2462.649088]  mmput+0x56/0x120
> [ 2462.649090]  do_exit+0x306/0xb50
> [ 2462.649095]  do_group_exit+0x3a/0xa0
> [ 2462.649098]  __x64_sys_exit_group+0x14/0x20
> [ 2462.649102]  do_syscall_64+0x5b/0x80
> [ 2462.649116]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> [ 2462.649120] RIP: 0033:0x7f90abae6c46
> [ 2462.649122] RSP: 002b:00007ffc0ca21638 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> [ 2462.649124] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f90abae6c46
> [ 2462.649125] RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> [ 2462.649127] RBP: 00007f90abdf5970 R08: 00000000000000e7 R09: ffffffffffffff80
> [ 2462.649128] R10: 0000000000000002 R11: 0000000000000246 R12: 00007f90abdf5970
> [ 2462.649129] R13: 0000000000000001 R14: 00007f90abdf9328 R15: 0000000000000000
> [ 2462.649132]  </TASK>
> [ 2462.649133] INFO: task fsim:100601 blocked for more than 491 seconds.
> [ 2462.649216] INFO: task fsim:100603 blocked for more than 491 seconds.
> [ 2462.649295] INFO: task fsim:100604 blocked for more than 491 seconds.
> [ 2462.649371] INFO: task fsim:100605 blocked for more than 491 seconds.
> [ 2462.649449] INFO: task fsim:100606 blocked for more than 491 seconds.
> [ 2462.649526] INFO: task fsim:100607 blocked for more than 491 seconds.
> [ 2462.649606] INFO: task fsim:100608 blocked for more than 491 seconds.
> [ 2462.649676] INFO: task fsim:100609 blocked for more than 491 seconds.

So, I tested these fixes all together added on top of 6eebd5fb2083:
* locking/rwsem: Prevent non-first waiter from spinning in down_write() slowpath
* locking/rwsem: Disable preemption at all down_read*() and up_read() code paths
* locking/rwsem: Disable preemption at all down_write*() and up_write() code paths

After 20 hours of runtime, none of the fsim processes got stuck nor any soft lockups occurred. AFAICT, it works.
Tested-by: Jiri Wiesner <jwiesner@suse.de>

[1] https://lore.kernel.org/lkml/20220617134325.GC30825@techsingularity.net/

-- 
Jiri Wiesner
SUSE Labs
