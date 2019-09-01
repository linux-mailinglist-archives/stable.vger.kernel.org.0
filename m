Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9858A4BFC
	for <lists+stable@lfdr.de>; Sun,  1 Sep 2019 22:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfIAUnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Sep 2019 16:43:14 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:44544 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbfIAUnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Sep 2019 16:43:13 -0400
Received: by mail-lf1-f54.google.com with SMTP id y4so2051320lfe.11
        for <stable@vger.kernel.org>; Sun, 01 Sep 2019 13:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=raD+86qs5kVN5LoP1TMOn4NsXqANMvUOehLQyHQ9tVw=;
        b=t7FcRMjrRi0KeslxjDzJici4sUcAwFrqxIPIdrLa2FaE/yDq6kN8/asrkNVlYFe7dE
         a7L8pOqAakKjIHghdP0mcLmyMG7TLz4oi68jvvKRtOLIhNjsu+oHqCP70W5b4lOb5+/N
         sPNcODomAQaVd8pNGVp9BMXKH5q2Ndx2d5lJpfjrRZODiWM9gCWqIxhmH7ddp0CrBEao
         i4GYU09q7xhWEIueTfXIcFLfN/IvJV1QZ6ijioHvYeUzPFTsIWHCq25OPx8aMu3I4hE1
         N149Y2o4MK+EvkbFBCFKyMiES7SydTuWvJVzfqe1L+oobWu7+thD+QdIqh8BiWOo6A6U
         Yelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=raD+86qs5kVN5LoP1TMOn4NsXqANMvUOehLQyHQ9tVw=;
        b=ho5jcJfQeUnfYP3xCh/NSUX1M2msO76y+TDh8+53VzUfQZnm45L9f1VvN8M2m+QEYL
         zRfjpTHlEsbyTkpZB3boM73zlbrsUESQ6gMo0xl8c7fjVjDsNOXCA9NenTk22RhAIpC7
         AT91aD5BMgqHkGJirp3Dc7AsQcXyVxo2vEAkgn62b7RoCVYHWIlG0u5dAyThbXXwS6tJ
         n2/Z0ALftUFc9oxjqSSo3OTlX2TEdCewNjqpgTtWnA0TAB725v2JB2xZFIPTQq29KB7i
         ezbAeSJY42je01Za9+2chG9H9QnHCu98dwLewrGU0OGOVDqdVCr9xLpPk053G5uOOSTz
         mxZQ==
X-Gm-Message-State: APjAAAWm13MF4uuVVM0h5htnPqp3frVaOckTK1nuXH8GHzoHgyf61B+V
        4bkbpcdN9yVPFK7t1u2LB1HitCuH
X-Google-Smtp-Source: APXvYqy01byxHTZpiIKgl61wl+iSTCx5+XdpGuSEKLqNK09qZz5kZWooQbqMJ6v7gZ4IEpUyKk5yHA==
X-Received: by 2002:a19:4b4a:: with SMTP id y71mr11023431lfa.118.1567370587208;
        Sun, 01 Sep 2019 13:43:07 -0700 (PDT)
Received: from [84.217.166.181] (c-8caed954.51034-0-757473696b74.bbcust.telenor.se. [84.217.166.181])
        by smtp.gmail.com with ESMTPSA id u10sm1013647lfk.34.2019.09.01.13.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Sep 2019 13:43:06 -0700 (PDT)
To:     linux-mm@kvack.org
Cc:     stable@vger.kernel.org
From:   Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: [BUG] Early OOM and kernel NULL pointer dereference in 4.19.69
Message-ID: <31131c2d-a936-8bbf-e58d-a3baaa457340@gmail.com>
Date:   Sun, 1 Sep 2019 22:43:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After upgrading to the 4.19 series I've started getting problems with
early OOM.

I run a Gentoo system and do large compiles like the chromium browser in a
v1 memory cgroup. When I build chromium in the memory cgroup the OOM killer
runs and kills programs outside of the cgroup. This happens even when there
is plenty of free memory both in and outside of the cgroup.

The memory cgroup is named "12G" and is setup like this:
   /sys/fs/cgroup/memory/12G/memory.kmem.limit_in_bytes:1073741824
   /sys/fs/cgroup/memory/12G/memory.kmem.tcp.limit_in_bytes:1073741824
   /sys/fs/cgroup/memory/12G/memory.limit_in_bytes:12884901888
   /sys/fs/cgroup/memory/12G/memory.memsw.limit_in_bytes:12884901888
   /sys/fs/cgroup/memory/12G/memory.soft_limit_in_bytes:9223372036854771712

The system has MemTotal: 16244996 kB

I run the chromium compile job using Gentoo's package manager like this:
cgexec -g memory:12G emerge -1 www-client/chromium

That compile job usually fails and dmesg looks like this:

[ 1084.634827] SLUB: Unable to allocate memory on node -1, gfp=0x6000c0(GFP_KERNEL)
[ 1084.634836]   cache: dentry(100:12G), object size: 192, buffer size: 192, default order: 0, min order: 0
[ 1084.634838]   node 0: slabs: 26888, objs: 564648, free: 0
[ 1084.634857] SLUB: Unable to allocate memory on node -1, gfp=0x6000c0(GFP_KERNEL)
[ 1084.634860]   cache: dentry(100:12G), object size: 192, buffer size: 192, default order: 0, min order: 0
[ 1084.634861]   node 0: slabs: 26888, objs: 564648, free: 0
[ 1084.648583] SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
[ 1084.648593]   cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
[ 1084.648595]   node 0: slabs: 19132, objs: 592952, free: 0
[ 1084.648695] SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
[ 1084.648700]   cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
[ 1084.648702]   node 0: slabs: 19132, objs: 592952, free: 0
[ 1084.648794] SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
[ 1084.648799]   cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
[ 1084.648801]   node 0: slabs: 19132, objs: 592952, free: 0
[ 1084.648898] SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
[ 1084.648900]   cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
[ 1084.648908]   node 0: slabs: 19132, objs: 592952, free: 0
[ 1084.649000] SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
[ 1084.649004]   cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
[ 1084.649006]   node 0: slabs: 19132, objs: 592952, free: 0
[ 1084.649103] SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
[ 1084.649107]   cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
[ 1084.649109]   node 0: slabs: 19132, objs: 592952, free: 0
[ 1084.649198] SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
[ 1084.649199]   cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
[ 1084.649199]   node 0: slabs: 19132, objs: 592952, free: 0
[ 1084.649293] SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
[ 1084.649299]   cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
[ 1084.649299]   node 0: slabs: 19132, objs: 592952, free: 0
[ 1146.798499] Purging GPU memory, 41040 pages freed, 6933 pages still pinned.
[ 1146.798512] 4 and 0 pages still available in the bound and unbound GPU page lists.
[ 1146.798649] Purging GPU memory, 0 pages freed, 6933 pages still pinned.
[ 1146.798653] 4 and 0 pages still available in the bound and unbound GPU page lists.
[ 1146.798696] emerge invoked oom-killer: gfp_mask=0x0(), nodemask=(null), order=0, oom_score_adj=0
[ 1146.798699] emerge cpuset=
[ 1146.798701] /
[ 1146.798703]  mems_allowed=0
[ 1146.798705] CPU: 4 PID: 16719 Comm: emerge Not tainted 4.19.69 #43
[ 1146.798707] Hardware name: Gigabyte Technology Co., Ltd. Z97X-Gaming G1/Z97X-Gaming G1, BIOS F9 07/31/2015
[ 1146.798708] Call Trace:
[ 1146.798713]  dump_stack+0x46/0x60
[ 1146.798718]  dump_header+0x67/0x28d
[ 1146.798721]  oom_kill_process.cold.31+0xb/0x1f3
[ 1146.798723]  out_of_memory+0x129/0x250
[ 1146.798728]  pagefault_out_of_memory+0x64/0x77
[ 1146.798732]  __do_page_fault+0x3c1/0x3d0
[ 1146.798735]  do_page_fault+0x2c/0x123
[ 1146.798738]  ? page_fault+0x8/0x30
[ 1146.798740]  page_fault+0x1e/0x30
[ 1146.798743] RIP: 0033:0x7f3745ccf628
[ 1146.798744] Code: 43 68 48 8b 40 08 48 89 44 24 08 48 8b 83 00 03 00 00 48 85 c0 0f 84 ff 00 00 00 48 8b 74 24 20 8b 54 24 30 23 93 f8 02 00 00 <48> 8b 14 d0 8b 83 fc 02 00 00 89 f7 c4 e2 fb f7 c6 c4 e2 fb f7 c2
[ 1146.798746] RSP: 002b:00007ffd34c11460 EFLAGS: 00010202
[ 1146.798748] RAX: 000056439d3e5288 RBX: 00007f3745cf0130 RCX: 0000000000000013
[ 1146.798750] RDX: 0000000000000001 RSI: 00000000777f2f73 RDI: 00007f37458c7303
[ 1146.798752] RBP: 0000000000000000 R08: 00007ffd34c11590 R09: 00007f3745cf03f0
[ 1146.798754] R10: 00007f3745c91000 R11: 00007f374557b5c0 R12: 0000000000000000
[ 1146.798756] R13: 0000000000000001 R14: 0000000000000000 R15: 00007f3745c92f58
[ 1146.798758] Mem-Info:
[ 1146.798761] active_anon:438779 inactive_anon:41657 isolated_anon:0
                 active_file:591199 inactive_file:2307684 isolated_file:0
                 unevictable:1 dirty:499 writeback:0 unstable:0
                 slab_reclaimable:299846 slab_unreclaimable:22656
                 mapped:134859 shmem:51982 pagetables:5460 bounce:0
                 free:311407 free_pcp:4594 free_cma:0
[ 1146.798765] Node 0 active_anon:1755116kB inactive_anon:166628kB active_file:2364796kB inactive_file:9230736kB unevictable:4kB isolated(anon):0kB isolated(file):0kB mapped:539436kB dirty:1996kB writeback:0kB shmem:207928kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 598016kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
[ 1146.798770] DMA free:15900kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15984kB managed:15900kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1146.798772] lowmem_reserve[]:
[ 1146.798773]  0
[ 1146.798774]  3030
[ 1146.798775]  15777
[ 1146.798776]  15777
[ 1146.798780] DMA32 free:1111400kB min:12968kB low:16208kB high:19448kB active_anon:253352kB inactive_anon:1160kB active_file:48104kB inactive_file:1489456kB unevictable:0kB writepending:0kB present:3172224kB managed:3172224kB mlocked:0kB kernel_stack:16kB pagetables:248kB bounce:0kB free_pcp:10952kB local_pcp:1356kB free_cma:0kB
[ 1146.798782] lowmem_reserve[]:
[ 1146.798783]  0
[ 1146.798784]  0
[ 1146.798786]  12746
[ 1146.798787]  12746
[ 1146.798791] Normal free:118328kB min:54544kB low:68180kB high:81816kB active_anon:1501764kB inactive_anon:165596kB active_file:2316692kB inactive_file:7741280kB unevictable:4kB writepending:1996kB present:13367296kB managed:13056872kB mlocked:4kB kernel_stack:9216kB pagetables:21592kB bounce:0kB free_pcp:7412kB local_pcp:1320kB free_cma:0kB
[ 1146.798793] lowmem_reserve[]:
[ 1146.798794]  0
[ 1146.798795]  0
[ 1146.798796]  0
[ 1146.798797]  0
[ 1146.798799] DMA:
[ 1146.798800] 1*4kB
[ 1146.798802] (U)
[ 1146.798803] 1*8kB
[ 1146.798805] (U)
[ 1146.798806] 1*16kB
[ 1146.798807] (U)
[ 1146.798808] 0*32kB
[ 1146.798810] 2*64kB
[ 1146.798811] (U)
[ 1146.798812] 1*128kB
[ 1146.798813] (U)
[ 1146.798815] 1*256kB
[ 1146.798816] (U)
[ 1146.798817] 0*512kB
[ 1146.798818] 1*1024kB
[ 1146.798819] (U)
[ 1146.798821] 1*2048kB
[ 1146.798822] (M)
[ 1146.798823] 3*4096kB
[ 1146.798824] (M)
[ 1146.798826] = 15900kB
[ 1146.798828] DMA32:
[ 1146.798829] 6346*4kB
[ 1146.798831] (UME)
[ 1146.798977] 2650*8kB
[ 1146.798980] (UME)
[ 1146.798981] 1118*16kB
[ 1146.799118] (UME)
[ 1146.799119] 774*32kB
[ 1146.799121] (UME)
[ 1146.799122] 367*64kB
[ 1146.799123] (UME)
[ 1146.799125] 191*128kB
[ 1146.799126] (UME)
[ 1146.799128] 64*256kB
[ 1146.799290] (UME)
[ 1146.799291] 37*512kB
[ 1146.799291] (UM)
[ 1146.799291] 21*1024kB
[ 1146.799292] (UME)
[ 1146.799292] 194*2048kB
[ 1146.799292] (UM)
[ 1146.799292] 127*4096kB
[ 1146.799293] (M)
[ 1146.799293] = 1111512kB
[ 1146.799293] Normal:
[ 1146.799294] 2360*4kB
[ 1146.799294] (UME)
[ 1146.799294] 1483*8kB
[ 1146.799295] (UME)
[ 1146.799295] 506*16kB
[ 1146.799295] (UME)
[ 1146.799295] 377*32kB
[ 1146.799296] (UME)
[ 1146.799296] 171*64kB
[ 1146.799296] (UME)
[ 1146.799296] 59*128kB
[ 1146.799297] (UME)
[ 1146.799297] 46*256kB
[ 1146.799297] (UME)
[ 1146.799297] 7*512kB
[ 1146.799298] (UME)
[ 1146.799298] 4*1024kB
[ 1146.799298] (UE)
[ 1146.799299] 5*2048kB
[ 1146.799299] (ME)
[ 1146.799299] 7*4096kB
[ 1146.799299] (M)
[ 1146.799300] = 118328kB
[ 1146.799301] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1146.799301] 2950857 total pagecache pages
[ 1146.799303] 0 pages in swap cache
[ 1146.799576] Swap cache stats: add 0, delete 0, find 0/0
[ 1146.799578] Free swap  = 4194300kB
[ 1146.799579] Total swap = 4194300kB
[ 1146.799581] 4138876 pages RAM
[ 1146.799582] 0 pages HighMem/MovableOnly
[ 1146.799584] 77627 pages reserved
[ 1146.799585] Tasks state (memory values in pages):
[ 1146.799586] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[ 1146.799601] [    971]     0   971     3161      967    57344        0             0 systemd-udevd
[ 1146.799605] [   2152]   103  2152      902      692    40960        0             0 dbus-daemon
[ 1146.799607] [   2185]     0  2185     3040      597    57344        0             0 syslog-ng
[ 1146.799609] [   2186]     0  2186    77434     1839    94208        0             0 syslog-ng
[ 1146.799611] [   2187]     0  2187     3299     1286    69632        0             0 syslog_redirect
[ 1146.799798] [   2222]     0  2222    96102     1318   110592        0             0 console-kit-dae
[ 1146.799800] [   2239]   119  2239   486941     5736   237568        0             0 polkitd
[ 1146.799801] [   2259]     0  2259      612       23    45056        0             0 gpm
[ 1146.799802] [   2735]     0  2735      691       66    45056        0             0 dhcpcd
[ 1146.799803] [   2806]   123  2806      983      412    45056        0             0 ntpd
[ 1146.799805] [   2807]   123  2807      999      483    49152        0             0 ntpd
[ 1146.799814] [   2817]     0  2817      945       54    45056        0             0 ntpd
[ 1146.799815] [   2847]     0  2847    18576      902   118784        0             0 virtlogd
[ 1146.799817] [   2878]     0  2878    18577      885   110592        0             0 virtlockd
[ 1146.799822] [   2912]     0  2912   352359     5586   299008        0             0 libvirtd
[ 1146.799823] [   3055]     0  3055     1917      374    53248        0             0 smartd
[ 1146.799824] [   3084]     0  3084     2010      454    53248        0             0 cron
[ 1146.799977] [   3159]     0  3159    78172     1652   106496        0             0 lightdm
[ 1146.799978] [   3178]     0  3178   223859    45920   868352        0             0 X
[ 1146.799984] [   3218]     0  3218    42557     1645    98304        0             0 lightdm
[ 1146.799985] [   3230]  1000  3230     2302      795    61440        0             0 sh
[ 1146.799986] [   3238]  1000  3238     2160      559    57344        0             0 dbus-launch
[ 1146.799992] [   3239]  1000  3239     1023      705    49152        0             0 dbus-daemon
[ 1146.799994] [   3245]  1000  3245    47306     4073   274432        0             0 xfce4-session
[ 1146.799998] [   3247]  1000  3247     3564     1246    73728        0             0 xfconfd
[ 1146.799999] [   3250]  1000  3250     1776       82    49152        0             0 ssh-agent
[ 1146.800000] [   3252]  1000  3252    40853      214    73728        0             0 gpg-agent
[ 1146.800001] [   3255]  1000  3255    37070     6711   294912        0             0 xfwm4
[ 1146.800002] [   3257]  1000  3257    29454     4047   266240        0             0 Thunar
[ 1146.800004] [   3259]  1000  3259    56521     6429   315392        0             0 xfce4-panel
[ 1146.800005] [   3260]  1000  3260    76198     5296   307200        0             0 xfsettingsd
[ 1146.800006] [   3264]  1000  3264   164200    15514   430080        0             0 xfdesktop
[ 1146.800007] [   3269]     0  3269    61046     1602   102400        0             0 upowerd
[ 1146.800008] [   3285]  1000  3285    66179     4569   290816        0             0 panel-2-actions
[ 1146.800009] [   3287]  1000  3287    36585     5112   278528        0             0 panel-8-quickla
[ 1146.800010] [   3288]  1000  3288   633361    62058  1359872        0             0 akregator
[ 1146.800011] [   3290]  1000  3290    71292     7355   294912        0             0 gkrellm
[ 1146.800012] [   3292]  1000  3292    60506     1728   102400        0             0 gvfsd
[ 1146.800013] [   3294]  1000  3294    28673     3873   262144        0             0 panel-6-systray
[ 1146.800014] [   3295]  1000  3295   155110    18850   507904        0             0 konversation
[ 1146.800015] [   3296]  1000  3296    35017     5801   274432        0             0 panel-1-genmon
[ 1146.800016] [   3297]  1000  3297    95199     7413   335872        0             0 panel-4-xfce4-t
[ 1146.800018] [   3298]  1000  3298   118574    21860   516096        0             0 kate
[ 1146.800045] [   3300]  1000  3300    35016     5745   278528        0             0 panel-7-datetim
[ 1146.800046] [   3301]  1000  3301   116227    18944   458752        0             0 konsole
[ 1146.800047] [   3303]  1000  3303   389058    54055   917504        0             0 clementine
[ 1146.800048] [   3372]  1000  3372    77563     1551   102400        0             0 at-spi-bus-laun
[ 1146.800201] [   3381]  1000  3381      865      687    49152        0             0 dbus-daemon
[ 1146.800203] [   3383]  1000  3383    41371     1516    90112        0             0 at-spi2-registr
[ 1146.800205] [   3399]  1000  3399   150830     9120   372736        0             0 kactivitymanage
[ 1146.800212] [   3418]  1000  3418    34971     4175   126976        0             0 clementine-tagr
[ 1146.800214] [   3419]  1000  3419    34971     4210   131072        0             0 clementine-tagr
[ 1146.800218] [   3420]  1000  3420    34971     4198   126976        0             0 clementine-tagr
[ 1146.800219] [   3421]  1000  3421    34971     4193   126976        0             0 clementine-tagr
[ 1146.800220] [   3422]  1000  3422    34971     4166   135168        0             0 clementine-tagr
[ 1146.800222] [   3427]  1000  3427    72028     6718   278528        0             0 kglobalaccel5
[ 1146.800228] [   3428]  1000  3428    34971     4195   126976        0             0 clementine-tagr
[ 1146.800229] [   3429]  1000  3429    34971     4215   131072        0             0 clementine-tagr
[ 1146.800231] [   3431]  1000  3431    34971     4219   126976        0             0 clementine-tagr
[ 1146.800236] [   3444]  1000  3444     6474     5049    98304        0             0 bash
[ 1146.800237] [   3447]  1000  3447    90666    12645   548864        0             0 QtWebEngineProc
[ 1146.800242] [   3452]  1000  3452   149454      569   122880        0             0 mergerfs
[ 1146.800243] [   3487]     0  3487   100615     3753   151552        0             0 udisksd
[ 1146.800244] [   3512]  1000  3512     8823     1162   102400        0             0 sd_cicero
[ 1146.800246] [   3516]  1000  3516     8823     1123    98304        0             0 sd_dummy
[ 1146.800247] [   3519]  1000  3519     8829     1121    94208        0             0 sd_generic
[ 1146.800251] [   3521]  1000  3521    31475     2098   131072        0             0 sd_espeak
[ 1146.800252] [   3523]  1000  3523    74986     7943   311296        0             0 kiod5
[ 1146.800253] [   3546]     0  3546     1992      411    53248        0             0 agetty
[ 1146.800258] [   3547]     0  3547     2025      601    53248        0             0 agetty
[ 1146.800259] [   3548]     0  3548     2025      588    57344        0             0 agetty
[ 1146.800264] [   3549]     0  3549     2025      649    49152        0             0 agetty
[ 1146.800265] [   3550]     0  3550     2025      608    49152        0             0 agetty
[ 1146.800269] [   3551]     0  3551     2025      604    49152        0             0 agetty
[ 1146.800270] [   3559]  1000  3559    39834      554    81920        0             0 speech-dispatch
[ 1146.800274] [   3569]  1000  3569    60094     2084    94208        0             0 gvfs-udisks2-vo
[ 1146.800276] [   3574]  1000  3574    24587     2321   172032        0             0 kdeinit5
[ 1146.800279] [   3575]  1000  3575    76563     9081   331776        0             0 klauncher
[ 1146.800280] [   3596]  1000  3596    74713     9413   311296        0             0 kded5
[ 1146.800281] [   3623]  1000  3623    46085     4836   212992        0             0 kio_http_cache_
[ 1146.800282] [   3653]  1000  3653   138832    11871   372736        0             0 easystroke
[ 1146.800289] [   3654]  1000  3654    83783    12054   348160        0             0 redshift-gtk
[ 1146.800290] [   3655]  1000  3655    41365     7457   294912        0             0 orage
[ 1146.800291] [   3661]  1000  3661    60416     5023   249856        0             0 polkit-gnome-au
[ 1146.800292] [   3664]  1000  3664    60900     4510   245760        0             0 parcellite
[ 1146.800293] [   3680]  1000  3680    21790     2021   122880        0             0 xbindkeys
[ 1146.800297] [   3695]  1000  3695     3987      390    69632        0             0 redshift
[ 1146.800298] [   3696]  1000  3696     2198      691    57344        0             0 su
[ 1146.800299] [   3701]  1000  3701    57610     9559   380928        0             0 fcitx
[ 1146.800305] [   3706]  1000  3706      934      551    53248        0             0 dbus-daemon
[ 1146.800306] [   3711]  1000  3711     1224       28    49152        0             0 fcitx-dbus-watc
[ 1146.800307] [   3713]  1000  3713    89866     7908   303104        0             0 xfce4-notifyd
[ 1146.800433] [   3719]  1000  3719    27953     3652   196608        0             0 file.so
[ 1146.800435] [   3722]     0  3722     6339     4921    90112        0             0 bash
[ 1146.800436] [   3754]     0  3754     2899      865    65536        0             0 tmux: client
[ 1146.800437] [   3756]     0  3756     3593     1512    65536        0             0 tmux: server
[ 1146.800438] [   3760]     0  3760     1256      492    49152        0             0 tomoyo-queryd
[ 1146.800439] [   3764]     0  3764     6369     4973    90112        0             0 bash
[ 1146.800440] [   3771]  1000  3771     6473     5063    94208        0             0 bash
[ 1146.800441] [   3831]  1000  3831     6474     5057    90112        0             0 bash
[ 1146.800442] [   3847]  1000  3847     2084      226    57344        0             0 dmesg
[ 1146.800444] [   4187]  1000  4187   726438   221563  3211264        0             0 firefox
[ 1146.800459] [  23437]  1000 23437   416243    18201  1122304        0           300 QtWebEngineProc
[ 1146.800460] [  16704]     0 16704    69439    48429   610304        0             0 emerge
[ 1146.800462] [  16719]     0 16719    69439    46469   585728        0             0 emerge
[ 1146.800467] [  16724]     0 16724     1764      316    53248        0             0 rssnotify.pl
[ 1146.800468] Out of memory: Kill process 23437 (QtWebEngineProc) score 303 or sacrifice child
[ 1146.800491] Killed process 23437 (QtWebEngineProc) total-vm:1664972kB, anon-rss:16924kB, file-rss:55892kB, shmem-rss:0kB
[ 1146.803320] oom_reaper: reaped process 23437 (QtWebEngineProc), now anon-rss:0kB, file-rss:0kB, shmem-rss:8kB
[ 1146.837984] emerge: vmalloc: allocation failure, allocated 8192 of 20480 bytes, mode:0x7080c0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), nodemask=(null)
[ 1146.837993] emerge cpuset=
[ 1146.837995] /
[ 1146.837997]  mems_allowed=0
[ 1146.837999] CPU: 4 PID: 16742 Comm: emerge Not tainted 4.19.69 #43
[ 1146.838001] Hardware name: Gigabyte Technology Co., Ltd. Z97X-Gaming G1/Z97X-Gaming G1, BIOS F9 07/31/2015
[ 1146.838002] Call Trace:
[ 1146.838008]  dump_stack+0x46/0x60
[ 1146.838013]  warn_alloc.cold.133+0x68/0xe8
[ 1146.838016]  ? __alloc_pages_nodemask+0x1f7/0x290
[ 1146.838019]  __vmalloc_node_range+0x148/0x220
[ 1146.838023]  copy_process+0xaab/0x27b0
[ 1146.838025]  ? _do_fork+0xb2/0x390
[ 1146.838028]  _do_fork+0xb2/0x390
[ 1146.838030]  do_syscall_64+0x59/0x180
[ 1146.838033]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1146.838036] RIP: 0033:0x7f3745793aae
[ 1146.838038] Code: db 0f 85 25 01 00 00 64 4c 8b 0c 25 10 00 00 00 45 31 c0 4d 8d 91 d0 02 00 00 31 d2 31 f6 bf 11 00 20 01 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 a6 00 00 00 41 89 c4 85 c0 0f 85 b3 00 00
[ 1146.838040] RSP: 002b:00007ffd34c12ed0 EFLAGS: 00000246
[ 1146.838041]  ORIG_RAX: 0000000000000038
[ 1146.838045] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3745793aae
[ 1146.838046] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
[ 1146.838048] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f374557b5c0
[ 1146.838050] R10: 00007f374557b890 R11: 0000000000000246 R12: 00007f3744cb17b0
[ 1146.838051] R13: 00007f3745545ad4 R14: 00007f373a32d168 R15: 00007f3745538050
[ 1146.838053] Mem-Info:
[ 1146.838056] active_anon:439660 inactive_anon:41529 isolated_anon:0
                 active_file:591639 inactive_file:2307377 isolated_file:0
                 unevictable:1 dirty:500 writeback:0 unstable:0
                 slab_reclaimable:299846 slab_unreclaimable:22643
                 mapped:133960 shmem:51818 pagetables:5302 bounce:0
                 free:310992 free_pcp:4130 free_cma:0
[ 1146.838060] Node 0 active_anon:1758640kB inactive_anon:166116kB active_file:2366556kB inactive_file:9229508kB unevictable:4kB isolated(anon):0kB isolated(file):0kB mapped:535840kB dirty:2000kB writeback:0kB shmem:207272kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 598016kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
[ 1146.838063] DMA free:15900kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15984kB managed:15900kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1146.838064] lowmem_reserve[]:
[ 1146.838065]  0
[ 1146.838067]  3030
[ 1146.838068]  15777
[ 1146.838069]  15777
[ 1146.838071] DMA32 free:1115072kB min:12968kB low:16208kB high:19448kB active_anon:250368kB inactive_anon:416kB active_file:48104kB inactive_file:1489456kB unevictable:0kB writepending:0kB present:3172224kB managed:3172224kB mlocked:0kB kernel_stack:16kB pagetables:228kB bounce:0kB free_pcp:11000kB local_pcp:1348kB free_cma:0kB
[ 1146.838073] lowmem_reserve[]:
[ 1146.838074]  0
[ 1146.838075]  0
[ 1146.838076]  12746
[ 1146.838077]  12746
[ 1146.838080] Normal free:112996kB min:54544kB low:68180kB high:81816kB active_anon:1508272kB inactive_anon:165700kB active_file:2318452kB inactive_file:7740052kB unevictable:4kB writepending:2000kB present:13367296kB managed:13056872kB mlocked:4kB kernel_stack:9220kB pagetables:20980kB bounce:0kB free_pcp:5472kB local_pcp:508kB free_cma:0kB
[ 1146.838081] lowmem_reserve[]:
[ 1146.838082]  0
[ 1146.838083]  0
[ 1146.838085]  0
[ 1146.838086]  0
[ 1146.838088] DMA:
[ 1146.838089] 1*4kB
[ 1146.838090] (U)
[ 1146.838091] 1*8kB
[ 1146.838092] (U)
[ 1146.838093] 1*16kB
[ 1146.838094] (U)
[ 1146.838095] 0*32kB
[ 1146.838097] 2*64kB
[ 1146.838098] (U)
[ 1146.838099] 1*128kB
[ 1146.838100] (U)
[ 1146.838101] 1*256kB
[ 1146.838102] (U)
[ 1146.838103] 0*512kB
[ 1146.838104] 1*1024kB
[ 1146.838106] (U)
[ 1146.838107] 1*2048kB
[ 1146.838279] (M)
[ 1146.838282] 3*4096kB
[ 1146.838284] (M)
[ 1146.838287] = 15900kB
[ 1146.838290] DMA32:
[ 1146.838292] 6524*4kB
[ 1146.838294] (UME)
[ 1146.838295] 2692*8kB
[ 1146.838297] (UME)
[ 1146.838298] 1125*16kB
[ 1146.838300] (UME)
[ 1146.838301] 775*32kB
[ 1146.838303] (UME)
[ 1146.838304] 368*64kB
[ 1146.838306] (UME)
[ 1146.838307] 193*128kB
[ 1146.838308] (UME)
[ 1146.838310] 64*256kB
[ 1146.838311] (UME)
[ 1146.838312] 37*512kB
[ 1146.838313] (UM)
[ 1146.838315] 21*1024kB
[ 1146.838316] (UME)
[ 1146.838318] 195*2048kB
[ 1146.838319] (UM)
[ 1146.838321] 127*4096kB
[ 1146.838322] (M)
[ 1146.838323] = 1115072kB
[ 1146.838324] Normal:
[ 1146.838325] 1083*4kB
[ 1146.838326] (UME)
[ 1146.838327] 1426*8kB
[ 1146.838328] (UM)
[ 1146.838329] 493*16kB
[ 1146.838330] (UE)
[ 1146.838331] 359*32kB
[ 1146.838333] (U)
[ 1146.838334] 161*64kB
[ 1146.838335] (UME)
[ 1146.838336] 54*128kB
[ 1146.838337] (UM)
[ 1146.838339] 43*256kB
[ 1146.838340] (UM)
[ 1146.838341] 9*512kB
[ 1146.838342] (UME)
[ 1146.838343] 5*1024kB
[ 1146.838345] (UME)
[ 1146.838347] 5*2048kB
[ 1146.838348] (ME)
[ 1146.838349] 7*4096kB
[ 1146.838350] (M)
[ 1146.838351] = 111980kB
[ 1146.838353] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1146.838355] 2950826 total pagecache pages
[ 1146.838357] 0 pages in swap cache
[ 1146.838358] Swap cache stats: add 0, delete 0, find 0/0
[ 1146.838360] Free swap  = 4194300kB
[ 1146.838362] Total swap = 4194300kB
[ 1146.838363] 4138876 pages RAM
[ 1146.838364] 0 pages HighMem/MovableOnly
[ 1146.838365] 77627 pages reserved

 From the output it looks like there was about 9G inactive file memory and no
swap used at all when the OOM killer triggered. The output is messy because I
use netconsole.

Swap is using a zram dev setup like this:
   echo 8 > /sys/block/zram0/max_comp_streams
   echo lz4 > /sys/block/zram0/comp_algorithm
   echo 4G > /sys/block/zram0/disksize
   mkswap /dev/zram0
   swapon -v --discard /dev/zram0

Those kernel memory allocation failures can also cause kernel NULL pointer
dereference. Here is a dmesg captured over netconsole when that happens:

4,1210,922134743,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1211,922134751,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1212,922134753,-;  node 0: slabs: 18346, objs: 568698, free: 0
4,1213,922134762,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1214,922134764,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1215,922134765,-;  node 0: slabs: 18346, objs: 568698, free: 0
4,1216,922134770,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1217,922134771,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1218,922134773,-;  node 0: slabs: 18346, objs: 568698, free: 0
4,1219,922134776,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1220,922134778,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1221,922134779,-;  node 0: slabs: 18346, objs: 568698, free: 0
4,1222,922134784,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1223,922134872,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1224,922134874,-;  node 0: slabs: 18346, objs: 568698, free: 0
4,1225,922135143,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1226,922135147,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1227,922135148,-;  node 0: slabs: 18351, objs: 568713, free: 0
4,1228,922135152,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1229,922135154,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1230,922135162,-;  node 0: slabs: 18351, objs: 568713, free: 0
4,1231,922135165,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1232,922135166,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1233,922135166,-;  node 0: slabs: 18351, objs: 568713, free: 0
4,1234,922135168,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1235,922135175,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1236,922135176,-;  node 0: slabs: 18351, objs: 568713, free: 0
4,1237,922135181,-;SLUB: Unable to allocate memory on node -1, gfp=0x600040(GFP_NOFS)
4,1238,922135183,-;  cache: ext4_inode_cache(100:12G), object size: 1024, buffer size: 1032, default order: 3, min order: 0
4,1239,922135183,-;  node 0: slabs: 18351, objs: 568713, free: 0
1,1240,922137835,-;BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
6,1241,922137839,-;PGD 0
4,1242,922137840,c;P4D 0
4,1243,922137842,-;Oops: 0000 [#1] PREEMPT SMP PTI
4,1244,922137844,-;CPU: 3 PID: 16923 Comm: gtk-update-icon Not tainted 4.19.51 #42
4,1245,922137846,-;Hardware name: Gigabyte Technology Co., Ltd. Z97X-Gaming G1/Z97X-Gaming G1, BIOS F9 07/31/2015
4,1246,922137850,-;RIP: 0010:create_empty_buffers+0x24/0x100
4,1247,922137852,-;Code: cd 0f 1f 44 00 00 0f 1f 44 00 00 41 54 49 89 d4 ba 01 00 00 00 55 53 48 89 fb e8 97 fe ff ff 48 89 c5 48 89 c2 eb 03 48 89 ca <48> 8b 4a 08 4c 09 22 48 85 c9 75 f1 48 89 6a 08 48 8b 43 18 48 8d
4,1248,922137853,-;RSP: 0018:ffff927ac1b37bf8 EFLAGS: 00010286
4,1249,922137855,-;RAX: 0000000000000000 RBX: fffff2d4429fd740 RCX: 0000000100097149
4,1250,922137856,-;RDX: 0000000000000000 RSI: 0000000000000082 RDI: ffff9075a99fbe00
4,1251,922137857,-;RBP: 0000000000000000 R08: fffff2d440949cc8 R09: 00000000000960c0
4,1252,922137859,-;R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
4,1253,922137860,-;R13: ffff907601f18360 R14: 0000000000002000 R15: 0000000000001000
4,1254,922137861,-;FS:  00007fb55b288bc0(0000) GS:ffff90761f8c0000(0000) knlGS:0000000000000000
4,1255,922137863,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
4,1256,922137865,-;CR2: 0000000000000008 CR3: 000000007aebc002 CR4: 00000000001606e0
4,1257,922137866,-;Call Trace:
4,1258,922137967,-; create_page_buffers+0x4d/0x60
4,1259,922137969,-; __block_write_begin_int+0x8e/0x5a0
4,1260,922137972,-; ? ext4_inode_attach_jinode.part.82+0xb0/0xb0
4,1261,922137975,-; ? jbd2__journal_start+0xd7/0x1f0
4,1262,922137977,-; ext4_da_write_begin+0x112/0x3d0
4,1263,922137980,-; generic_perform_write+0xf1/0x1b0
4,1264,922137983,-; ? file_update_time+0x70/0x140
4,1265,922137985,-; __generic_file_write_iter+0x141/0x1a0
4,1266,922137988,-; ext4_file_write_iter+0xef/0x3b0
4,1267,922137990,-; __vfs_write+0x17e/0x1e0
4,1268,922137992,-; vfs_write+0xa5/0x1a0
4,1269,922137994,-; ksys_write+0x57/0xd0
4,1270,922137997,-; do_syscall_64+0x55/0x160
4,1271,922138000,-; entry_SYSCALL_64_after_hwframe+0x44/0xa9
4,1272,922138003,-;RIP: 0033:0x7fb55ba9c0d8
4,1273,922138004,-;Code: 00 90 48 83 ec 38 64 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 48 8d 05 05 96 0d 00 8b 00 85 c0 75 27 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 60 48 8b 4c 24 28 64 48 33 0c 25 28 00 00 00
4,1274,922138006,-;RSP: 002b:00007fff718c1260 EFLAGS: 00000246
4,1275,922138007,c; ORIG_RAX: 0000000000000001
4,1276,922138124,-;RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007fb55ba9c0d8
4,1277,922138125,-;RDX: 0000000000001000 RSI: 000056395ab78710 RDI: 0000000000000003
4,1278,922138126,-;RBP: 000056395ab78710 R08: 00007fb55b288bc0 R09: 0000000000000000
4,1279,922138128,-;R10: 0000000000000002 R11: 0000000000000246 R12: 000056395ab69900
4,1280,922138129,-;R13: 0000000000001000 R14: 00007fb55bb6c760 R15: 0000000000001000
4,1281,922138131,-;Modules linked in:
4,1282,922138133,c; 8021q
4,1283,922138134,c; iptable_mangle
4,1284,922138135,c; xt_limit
4,1285,922138136,c; xt_conntrack
4,1286,922138137,c; iptable_filter
4,1287,922138138,c; iptable_nat
4,1288,922138139,c; nf_nat_ipv4
4,1289,922138141,c; nf_nat
4,1290,922138142,c; ip_tables
4,1291,922138143,c; arc4
4,1292,922138144,c; ath9k_htc
4,1293,922138145,c; ath9k_common
4,1294,922138146,c; ath9k_hw
4,1295,922138147,c; ath
4,1296,922138148,c; mac80211
4,1297,922138150,c; kvm_intel
4,1298,922138151,c; cfg80211
4,1299,922138152,c; kvm
4,1300,922138153,c; uas
4,1301,922138154,c; crc32_pclmul
4,1302,922138156,c; usb_storage
4,1303,922138157,c; joydev
4,1304,922138201,c; cdc_acm
4,1305,922138203,-;CR2: 0000000000000008
4,1306,922138270,-;---[ end trace ee8624c121072f8e ]---
4,1307,922138273,-;RIP: 0010:create_empty_buffers+0x24/0x100
4,1308,922138275,-;Code: cd 0f 1f 44 00 00 0f 1f 44 00 00 41 54 49 89 d4 ba 01 00 00 00 55 53 48 89 fb e8 97 fe ff ff 48 89 c5 48 89 c2 eb 03 48 89 ca <48> 8b 4a 08 4c 09 22 48 85 c9 75 f1 48 89 6a 08 48 8b 43 18 48 8d
4,1309,922138278,-;RSP: 0018:ffff927ac1b37bf8 EFLAGS: 00010286
4,1310,922138280,-;RAX: 0000000000000000 RBX: fffff2d4429fd740 RCX: 0000000100097149
4,1311,922138281,-;RDX: 0000000000000000 RSI: 0000000000000082 RDI: ffff9075a99fbe00
4,1312,922138282,-;RBP: 0000000000000000 R08: fffff2d440949cc8 R09: 00000000000960c0
4,1313,922138284,-;R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
4,1314,922138285,-;R13: ffff907601f18360 R14: 0000000000002000 R15: 0000000000001000
4,1315,922138286,-;FS:  00007fb55b288bc0(0000) GS:ffff90761f8c0000(0000) knlGS:0000000000000000
4,1316,922138288,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
4,1317,922138289,-;CR2: 0000000000000008 CR3: 000000007aebc002 CR4: 00000000001606e0
0,1318,922138290,-;Kernel panic - not syncing: Fatal exception
0,1319,922138296,-;Kernel Offset: 0x6000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
0,1320,922138299,-;---[ end Kernel panic - not syncing: Fatal exception ]---

Since I never had this problem with 4.14 I tested the old 4.14.115 that I used
before updating to 4.19 and I couldn't reproduce the problem with it. I can
easily reproduce the problem at least back to 4.19.42 in the 4.19 series.
I could bisect the problem but that's going to take forever so I'm hoping I
can avoid that.

The problem only occurs when that "12G" memory cgroups is used to build
chromium and nothing else. Chromium is the largest package I regularly build
and I selectively enable ccache for the chromium build. My gut feeling tells
the that the massive number of file operations needed for the build is what is
triggering the problem. Perhaps when the memory.kmem.limit_in_bytes limit is
reached?

Here is some more info I don't think fit in a single mail.

full dmesg https://pastebin.com/raw/tKgTCTJ2
.config https://pastebin.com/raw/jKhSqqCX

Some relevant parts of /etc/sysctl.conf:
   vm.dirty_writeback_centisecs = 3000
   vm.dirty_background_bytes = 52428800
   vm.dirty_bytes = 262144000
   vm.swappiness = 99
   vm.vfs_cache_pressure = 25
