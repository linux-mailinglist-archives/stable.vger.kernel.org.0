Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2895BD098
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiISPUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 11:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiISPUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 11:20:18 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5893687B;
        Mon, 19 Sep 2022 08:19:09 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1280590722dso62383306fac.1;
        Mon, 19 Sep 2022 08:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=P3Ai33rdsVQqwX7PMGHtm9t83pWvGtZHjBBhRBZU8og=;
        b=W0dQZIMGqIqcsV83SYHQ0bW/iCwIn1NxWsscA4jx2N89ZAHkYAH7pqPV4XVejkjavd
         j9pEN+hRQDRkD/8e/zdpzdhUOr+F6hgz1egzAaYkOFX8R8drNkP4Uy944+d5A7waBB6V
         ZYNgUn3U87olVVMmfY1/0B/1dh1db2HplQmrmlV1yRe2GxJ+zK4Q+qIT/mHiZM2Q8IdC
         d6yxJo18EAHqGHpgpasAQDs041e2TKGIpzw8OZEzbmt7KxrpE5AweJQyOP3EmB3TecJm
         Z59wLSc3JCr+mT/BkvfsVabc0DUbE4SB+/6VKxpQJ6yINDuXYEYjqBaet6dKgixTwOrz
         8PRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=P3Ai33rdsVQqwX7PMGHtm9t83pWvGtZHjBBhRBZU8og=;
        b=T1COKkmAQXt9OCdTU4ax9RhAz9C0tq2PlSRYtN/mzY1+DqvHl2thlKGbULNR6MV7CS
         eb+XqgmLXqyJj/N9KN4Taxf/3Zgt0DCk3Uop3ThekETa/gTZrXHxmDVs103HhU7HMtvo
         VD7ABW3sFJWJzflNuDGfuIDdqjpZq2WsP63buSjnSB1v5251l7HvELx5MyWTZlV0QRB9
         UoYqwPZvhhefLVt6QqlPb64kx37emT/ff4OKDBwPqTEgxoO30kmwZRuCLiLKsReBaxaS
         RZ2ycv5l5m+nomuqOnY5N7uaMF6BsT2F7c0jIGQnYXj6rToEz+hF9Ec+BbhYdMfVLGPh
         ejng==
X-Gm-Message-State: ACrzQf1ID/TxtP1woIQVxyOLtkE5GJzKBUrsIu7Ke5t+zuiuhLqWn75f
        vy05j15UHkHuSUnyde9Mgs30wEP+tpb+IauI0RWq+pp8npuk9DAt
X-Google-Smtp-Source: AMsMyM6mtg+yz3PrNMx8EpXi5/5V325Tunsl+hJk83DNGyZmx5hWFNy0V90RGJGu/NPm6bW2s4Ks+KvoeTyRx+yilcE=
X-Received: by 2002:a05:6870:c1c6:b0:12c:8311:8f3c with SMTP id
 i6-20020a056870c1c600b0012c83118f3cmr9061016oad.158.1663600748346; Mon, 19
 Sep 2022 08:19:08 -0700 (PDT)
MIME-Version: 1.0
From:   hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>
Date:   Mon, 19 Sep 2022 16:18:32 +0100
Message-ID: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
Subject: Ext4: Buffered random writes performance regression with
 dioread_nolock enabled
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Team,



I am sending this e-mail to report a performance regression that=E2=80=99s
caused by commit 244adf6426(ext4: make dioread_nolock the default) , I
am listing the performance regression symptoms below & our analysis
for the reported regression.



Reproduction Environment:



m5.24xlarge AWS EC2 instance that=E2=80=99s equipped with 96 vCPUs & 384 Gi=
B of memory
Disk: io1 16 TiB AWS EBS volume that should be able to achieve 64 IOPS
with throughput of 1000 MiB/s.



Reproduction steps:



We have seen a sharp regression in the achieved Disk  IOPS &
throughput running random buffered writes I/O fio test as shown below.

Format and mount:



$sudo mkdir -p /dbdata

$mke2fs -E lazy_itable_init=3D0,lazy_journal_init=3D0 -m 1 -t ext4 -b 4096
/dev/nvme1n1

$mount -t ext4 -o noatime,nodiratime,data=3Dordered /dev/nvme1n1 /dbdata


Mount options:


/dev/nvme1n1 on /dbdata type ext4 (rw,noatime,nodiratime,data=3Dordered)



Running the below script:

[root@ip-xx-xx-xx-xx ec2-user]# cat fio_test.sh

#!/bin/bash



for i in `seq 1 2`; do

    rm -rf /rdsdbdata/*

    /usr/bin/fio --name=3D16kb_rand_write_only_2048_jobs
--directory=3D/dbdata --rw=3Drandwrite --ioengine=3Dsync --fdatasync=3D1
--buffered=3D1 --bs=3D16k --max-jobs=3D2048 --numjobs=3D2048 --runtime=3D30
--thread --filesize=3D28800000 --fsync=3D1 --group_reporting
--create_only=3D1 > /dev/null

    sudo echo 1 > /proc/sys/vm/drop_caches

    echo "start test ${i}"

    /usr/bin/fio --name=3D16kb_rand_write_only_2048_jobs
--directory=3D/dbdata --rw=3Drandwrite --ioengine=3Dsync --fdatasync=3D1
--buffered=3D1 --bs=3D16k --max-jobs=3D2048 --numjobs=3D2048 --runtime=3D60
--time_based --thread --filesize=3D28800000 --fsync=3D1 --group_reporting
| grep iops

done



Symptoms:



The regression has been seen after upgrading from kernel 4.14 to 5.10
as shown below. it=E2=80=99s still reproducible on the latest upstream kern=
el
5.19 as the previously mentioned commit has been in the Linux kernel
since  5.6.



Kernel 4.14.287-215.504.amzn2.x86_64



[root@ip-xx-xx-xx-xx ec2-user]# ./fio_test.sh

start test 1

  write: io=3D56335MB, bw=3D320416KB/s, iops=3D20026, runt=3D180038msec

start test 2

  write: io=3D55111MB, bw=3D313421KB/s, iops=3D19588, runt=3D180056msec



Kernel 5.10.130-118.517.amzn2.x86_64



[root@ip-xx-xx-xx-xx ec2-user]# ./fio_test.sh

start test 1

  write: io=3D911744KB, bw=3D5055.5KB/s, iops=3D315, runt=3D180350msec

start test 2

  write: io=3D1075.6MB, bw=3D6089.4KB/s, iops=3D380, runt=3D180872msec





Analysis:



Doing a kernel bisect pointed out to the previously mentioned commit
as culprit behind the reported regression. We have tried to remount
the ext4 filesystem disabling dioread_nolock and that was enough to
bring the performance back to what it was before the commit.



We have done some performance debugging using perf event flame graphs
The dioread_nolock captured flame graphs are showing that 93.47% of
the time is been spent on fsync calls with the below path:



Fsync->entry_SYSCALL_64_after_hwframe->do_syscall_64->__x64_sys_fsync->ext4=
_sync_file->file_write_and_wait_range->__filemap_fdatawrite_range->do_write=
pages->
ext4_writepages->__ext4_journal_start_sb-> jbd2__journal_start->
start_this_handle->add_transaction_credits-> prepare_to_wait_event->
_raw_spin_lock_irqsave-> native_queued_spin_lock_slowpath.





With dioread_lock 51% of the time is been spent on fsync->
entry_SYSCALL_64_after_hwframe-> do_syscall_64-> __x64_sys_fsync->
ext4_sync_file->jbd2_log_wait_commit->prepare_to_wait_event->_raw_spin_lock=
_irqsave->native_queued_spin_lock_slowpath.



Doing a quick perf diff comparison between dioread_nolock &
dioread_lock and ironically it looks like we have kind of higher spin
lock contention when using dioread_nolock

# Event 'cycles'

#

# Baseline  Delta Abs  Shared Object        Symbol

# ........  .........  ...................
.................................................

#

    96.46%    -14.86%  [kernel.kallsyms]    [k] native_queued_spin_lock_slo=
wpath

     1.05%     +2.19%  fio                  [.] 0x0000000000019f00

     0.00%     +1.52%  [kernel.kallsyms]    [k] start_this_handle

     0.04%     +1.31%  [kernel.kallsyms]    [k] osq_lock

     0.03%     +0.73%  [kernel.kallsyms]    [k]
mwait_idle_with_hints.constprop.0

     0.01%     +0.60%  [kernel.kallsyms]    [k] copy_user_enhanced_fast_str=
ing

     0.01%     +0.58%  [kernel.kallsyms]    [k] _raw_read_lock

     0.03%     +0.48%  [kernel.kallsyms]    [k] add_transaction_credits

     0.01%     +0.34%  [kernel.kallsyms]    [k] queued_read_lock_slowpath





The flame graphs were showing that with dioread_lock enabled, most of
the CPU time is been spent in the add_transaction_credits function
which is responsible for making sure there is enough journal space
before adding the handle to the running transaction.
While running the reproduction with dioread_lock enabled and using
/proc/sysrq we were able to see that the fio process is waiting for
journal space most of the time and that=E2=80=99s why the lock contention o=
n
journal->j_state_lock was higher with dioread_lock enabled.



Aug 19 14:52:09 ip-172-31-8-128 kernel: task:fio             state:D
stack:    0 pid:34280 ppid: 26341 flags:0x00000080

Aug 19 14:52:09 ip-172-31-8-128 kernel: Call Trace:

Aug 19 14:52:09 ip-172-31-8-128 kernel: __schedule+0x1f9/0x660

Aug 19 14:52:09 ip-172-31-8-128 kernel: schedule+0x46/0xb0

Aug 19 14:52:09 ip-172-31-8-128 kernel: schedule_preempt_disabled+0xa/0x10

Aug 19 14:52:09 ip-172-31-8-128 kernel: __mutex_lock.constprop.0+0x12d/0x46=
0

Aug 19 14:52:09 ip-172-31-8-128 kernel: mutex_lock_io+0x39/0x50

Aug 19 14:52:09 ip-172-31-8-128 kernel:
__jbd2_log_wait_for_space+0xc5/0x1a0 [jbd2]

Aug 19 14:52:09 ip-172-31-8-128 kernel:
add_transaction_credits+0x288/0x2a0 [jbd2]

Aug 19 14:52:09 ip-172-31-8-128 kernel: start_this_handle+0x12d/0x4d0 [jbd2=
]

Aug 19 14:52:09 ip-172-31-8-128 kernel: ? jbd2__journal_start+0x8d/0x1e0 [j=
bd2]

Aug 19 14:52:09 ip-172-31-8-128 kernel: ? kmem_cache_alloc+0x132/0x260

Aug 19 14:52:09 ip-172-31-8-128 kernel: jbd2__journal_start+0xf7/0x1e0 [jbd=
2]

Aug 19 14:52:09 ip-172-31-8-128 kernel:
__ext4_journal_start_sb+0xf3/0x110 [ext4]

Aug 19 14:52:09 ip-172-31-8-128 kernel: ext4_dirty_inode+0x3d/0x80 [ext4]

Aug 19 14:52:09 ip-172-31-8-128 kernel: __mark_inode_dirty+0x192/0x2f0

Aug 19 14:52:09 ip-172-31-8-128 kernel: generic_update_time+0x68/0xc0

Aug 19 14:52:09 ip-172-31-8-128 kernel: file_update_time+0x123/0x140

Aug 19 14:52:09 ip-172-31-8-128 kernel: ? generic_write_checks+0x61/0xc0

Aug 19 14:52:09 ip-172-31-8-128 kernel:
ext4_buffered_write_iter+0x5a/0x160 [ext4]

Aug 19 14:52:09 ip-172-31-8-128 kernel: new_sync_write+0x11c/0x1b0

Aug 19 14:52:09 ip-172-31-8-128 kernel: vfs_write+0x1bd/0x260

Aug 19 14:52:09 ip-172-31-8-128 kernel: ksys_write+0x5f/0xe0

Aug 19 14:52:09 ip-172-31-8-128 kernel: do_syscall_64+0x33/0x40

Aug 19 14:52:09 ip-172-31-8-128 kernel: entry_SYSCALL_64_after_hwframe+0x44=
/0xa9

Aug 19 14:52:09 ip-172-31-8-128 kernel: RIP: 0033:0x7f13bde28559

Aug 19 14:52:09 ip-172-31-8-128 kernel: RSP: 002b:00007f04e0dde8e0
EFLAGS: 00000293 ORIG_RAX: 0000000000000001

Aug 19 14:52:09 ip-172-31-8-128 kernel: RAX: ffffffffffffffda RBX:
00007f0fa8005280 RCX: 00007f13bde28559

Aug 19 14:52:09 ip-172-31-8-128 kernel: RDX: 0000000000004000 RSI:
00007f0fa8005280 RDI: 00000000000006bf

Aug 19 14:52:09 ip-172-31-8-128 kernel: RBP: 0000000000004000 R08:
0000000000000000 R09: 0000000000000001

Aug 19 14:52:09 ip-172-31-8-128 kernel: R10: 0000000000000000 R11:
0000000000000293 R12: 00007f13a9e562c8

Aug 19 14:52:09 ip-172-31-8-128 kernel: R13: 0000000000004000 R14:
00007f13a9e63c40 R15: 00007f13a9e63ae0



We  did the same with dioread_lock enabled and I couldn't see any
reference for __jbd2_log_wait_for_space function which is the one
responsible for waiting for enough journal space to be available.

Aug 19 15:22:35 ip-172-31-8-128 kernel: task:fio             state:D
stack:    0 pid:77710 ppid: 71030 flags:0x00004080

Aug 19 15:22:35 ip-172-31-8-128 kernel: Call Trace:

Aug 19 15:22:35 ip-172-31-8-128 kernel: __schedule+0x1f9/0x660

Aug 19 15:22:35 ip-172-31-8-128 kernel: schedule+0x46/0xb0

Aug 19 15:22:35 ip-172-31-8-128 kernel: wait_transaction_locked+0x8a/0xd0 [=
jbd2]

Aug 19 15:22:35 ip-172-31-8-128 kernel: ? add_wait_queue_exclusive+0x70/0x7=
0

Aug 19 15:22:35 ip-172-31-8-128 kernel:
add_transaction_credits+0xd6/0x2a0 [jbd2]

Aug 19 15:22:35 ip-172-31-8-128 kernel: start_this_handle+0x12d/0x4d0 [jbd2=
]

Aug 19 15:22:35 ip-172-31-8-128 kernel: ? jbd2__journal_start+0x8d/0x1e0 [j=
bd2]

Aug 19 15:22:35 ip-172-31-8-128 kernel: ? kmem_cache_alloc+0x132/0x260

Aug 19 15:22:35 ip-172-31-8-128 kernel: jbd2__journal_start+0xf7/0x1e0 [jbd=
2]

Aug 19 15:22:35 ip-172-31-8-128 kernel:
__ext4_journal_start_sb+0xf3/0x110 [ext4]

Aug 19 15:22:35 ip-172-31-8-128 kernel: ext4_dirty_inode+0x3d/0x80 [ext4]

Aug 19 15:22:35 ip-172-31-8-128 kernel: __mark_inode_dirty+0x192/0x2f0

Aug 19 15:22:35 ip-172-31-8-128 kernel: generic_update_time+0x68/0xc0

Aug 19 15:22:35 ip-172-31-8-128 kernel: file_update_time+0x123/0x140

Aug 19 15:22:35 ip-172-31-8-128 kernel: ? generic_write_checks+0x61/0xc0

Aug 19 15:22:35 ip-172-31-8-128 kernel:
ext4_buffered_write_iter+0x5a/0x160 [ext4]

Aug 19 15:22:35 ip-172-31-8-128 kernel: new_sync_write+0x11c/0x1b0

Aug 19 15:22:35 ip-172-31-8-128 kernel: vfs_write+0x1bd/0x260

Aug 19 15:22:35 ip-172-31-8-128 kernel: ksys_write+0x5f/0xe0

Aug 19 15:22:35 ip-172-31-8-128 kernel: do_syscall_64+0x33/0x40

Aug 19 15:22:35 ip-172-31-8-128 kernel: entry_SYSCALL_64_after_hwframe+0x44=
/0xa9

Aug 19 15:22:35 ip-172-31-8-128 kernel: RIP: 0033:0x7fd6d8083559

Aug 19 15:22:35 ip-172-31-8-128 kernel: RSP: 002b:00007fd59d7f78e0
EFLAGS: 00000293 ORIG_RAX: 0000000000000001

Aug 19 15:22:35 ip-172-31-8-128 kernel: RAX: ffffffffffffffda RBX:
00007fd580000dd0 RCX: 00007fd6d8083559

Aug 19 15:22:35 ip-172-31-8-128 kernel: RDX: 0000000000004000 RSI:
00007fd580000dd0 RDI: 0000000000000088

Aug 19 15:22:35 ip-172-31-8-128 kernel: RBP: 0000000000004000 R08:
0000000000000000 R09: 0000000000000001

Aug 19 15:22:35 ip-172-31-8-128 kernel: R10: 0000000000000000 R11:
0000000000000293 R12: 00007fd6bfe33b08

Aug 19 15:22:35 ip-172-31-8-128 kernel: R13: 0000000000004000 R14:
00007fd6bfe41480 R15: 00007fd6bfe41320



Also running funclatency BCC script is showing that fsync operations
are taking higher time while having dioread_nolock enabled




dioread_nolock enabled


operation =3D open

     msecs               : count     distribution

         0 -> 1          : 4086     |**************************************=
**|



operation =3D fsync

     msecs               : count     distribution

         0 -> 1          : 0        |                                      =
  |

         2 -> 3          : 0        |                                      =
  |

         4 -> 7          : 0        |                                      =
  |

         8 -> 15         : 92       |********************                  =
  |

        16 -> 31         : 153      |**********************************    =
  |

        32 -> 63         : 177      |**************************************=
**|

        64 -> 127        : 18       |****                                  =
  |

       128 -> 255        : 77       |*****************                     =
  |

       256 -> 511        : 15       |***                                   =
  |

       512 -> 1023       : 19       |****                                  =
  |

      1024 -> 2047       : 51       |***********                           =
  |

      2048 -> 4095       : 137      |******************************        =
  |

      4096 -> 8191       : 82       |******************                    =
  |

      8192 -> 16383      : 118      |**************************            =
  |

     16384 -> 32767      : 104      |***********************               =
  |

     32768 -> 65535      : 140      |*******************************       =
  |



operation =3D write

     msecs               : count     distribution

         0 -> 1          : 10265    |**************************************=
**|

         2 -> 3          : 491      |*                                     =
  |

         4 -> 7          : 433      |*                                     =
  |

         8 -> 15         : 670      |**                                    =
  |

        16 -> 31         : 1043     |****                                  =
  |

        32 -> 63         : 438      |*                                     =
  |

        64 -> 127        : 177      |                                      =
  |

       128 -> 255        : 129      |                                      =
  |

       256 -> 511        : 14       |                                      =
  |

       512 -> 1023       : 80       |                                      =
  |

      1024 -> 2047       : 24       |                                      =
  |





dioread_lock enabled


operation =3D fsync

     msecs               : count     distribution

         0 -> 1          : 1        |                                      =
  |

         2 -> 3          : 115      |                                      =
  |

         4 -> 7          : 795      |                                      =
  |

         8 -> 15         : 2402     |                                      =
  |

        16 -> 31         : 3226     |*                                     =
  |

        32 -> 63         : 6271     |**                                    =
  |

        64 -> 127        : 109773   |**************************************=
**|

       128 -> 255        : 222      |                                      =
  |



operation =3D write

     msecs               : count     distribution

         0 -> 1          : 698243   |**************************************=
**|

         2 -> 3          : 967      |                                      =
  |

         4 -> 7          : 3233     |                                      =
  |

         8 -> 15         : 16189    |                                      =
  |

        16 -> 31         : 19443    |*                                     =
  |

        32 -> 63         : 47206    |**                                    =
  |

        64 -> 127        : 6850     |                                      =
  |

       128 -> 255        : 149      |                                      =
  |



operation =3D open

     msecs               : count     distribution

-> 1          : 8140     |****************************************|



Further tracing is showing that performance degradation we are seeing
is visible in funclatency of add_transaction_credits where we are
waiting until we can add credits for handle to the running
transaction. With dioread_nolock it=E2=80=99s taking on average 154 msec wh=
ile
0.27 msec with dioread_lock enabled



dioread_nolock enabled



3 warnings generated.

Tracing 1 functions for "add_transaction_credits"... Hit Ctrl-C to end.

^C

               nsecs                         : count     distribution

                   0 -> 1                    : 0        |                  =
  |

                   2 -> 3                    : 0        |                  =
  |

                   4 -> 7                    : 0        |                  =
  |

                   8 -> 15                   : 0        |                  =
  |

                  16 -> 31                   : 0        |                  =
  |

                  32 -> 63                   : 0        |                  =
  |

                  64 -> 127                  : 0        |                  =
  |

                 128 -> 255                  : 12677    |******************=
**|

                 256 -> 511                  : 5374     |********          =
  |

                 512 -> 1023                 : 6898     |**********        =
  |

                1024 -> 2047                 : 4114     |******            =
  |

                2048 -> 4095                 : 3736     |*****             =
  |

                4096 -> 8191                 : 1954     |***               =
  |

                8192 -> 16383                : 329      |                  =
  |

               16384 -> 32767                : 111      |                  =
  |

               32768 -> 65535                : 157      |                  =
  |

               65536 -> 131071               : 191      |                  =
  |

              131072 -> 262143               : 234      |                  =
  |

              262144 -> 524287               : 169      |                  =
  |

              524288 -> 1048575              : 190      |                  =
  |

             1048576 -> 2097151              : 270      |                  =
  |

             2097152 -> 4194303              : 459      |                  =
  |

             4194304 -> 8388607              : 2203     |***               =
  |

             8388608 -> 16777215             : 6032     |*********         =
  |

            16777216 -> 33554431             : 4827     |*******           =
  |

            33554432 -> 67108863             : 3846     |******            =
  |

            67108864 -> 134217727            : 3720     |*****             =
  |

          134217728 -> 268435455            : 6606     |**********         =
 |

           268435456 -> 536870911            : 6502     |**********        =
  |

           536870912 -> 1073741823           : 5072     |********          =
  |

          1073741824 -> 2147483647           : 2180     |***               =
  |

          2147483648 -> 4294967295           : 229      |                  =
  |

          4294967296 -> 8589934591           : 7        |                  =
  |



avg =3D 154580459 nsecs, total: 12084945771325 nsecs, count: 78179



dioread_lock



3 warnings generated.

Tracing 1 functions for "add_transaction_credits"... Hit Ctrl-C to end.

^C

     nsecs               : count     distribution

         0 -> 1          : 0        |                                      =
  |

         2 -> 3          : 0        |                                      =
  |

         4 -> 7          : 0        |                                      =
  |

         8 -> 15         : 0        |                                      =
  |

        16 -> 31         : 0        |                                      =
  |

        32 -> 63         : 0        |                                      =
  |

        64 -> 127        : 0        |                                      =
  |

       128 -> 255        : 54708    |                                      =
  |

       256 -> 511        : 952229   |************                          =
  |

       512 -> 1023       : 2954850  |**************************************=
**|

      1024 -> 2047       : 2833787  |**************************************=
  |

      2048 -> 4095       : 2843252  |**************************************=
  |

      4096 -> 8191       : 1952274  |**************************            =
  |

      8192 -> 16383      : 385997   |*****                                 =
  |

     16384 -> 32767      : 56495    |                                      =
  |

     32768 -> 65535      : 39379    |                                      =
  |

     65536 -> 131071     : 27116    |                                      =
  |

    131072 -> 262143     : 14277    |                                      =
  |

    262144 -> 524287     : 5726     |                                      =
  |

    524288 -> 1048575    : 3224     |                                      =
  |

   1048576 -> 2097151    : 2192     |                                      =
  |

   2097152 -> 4194303    : 6344     |                                      =
  |

   4194304 -> 8388607    : 11606    |                                      =
  |

   8388608 -> 16777215   : 21528    |                                      =
  |

  16777216 -> 33554431   : 42377    |                                      =
  |

  33554432 -> 67108863   : 40907    |                                      =
  |

  67108864 -> 134217727  : 801      |                                      =
  |

134217728 -> 268435455  : 64       |                                       =
 |



avg =3D 276573 nsecs, total: 3419652820836 nsecs, count: 12364366



We  thought  we may be seeing other manifestation for
https://patchwork.ozlabs.org/project/linux-ext4/patch/20220520111402.4252-1=
-jack@suse.cz/
but unfortunately unsetting EXT4_GET_BLOCKS_PRE_IO in
https://elixir.bootlin.com/linux/v5.10.135/source/fs/ext4/inode.c#L2410didn=
't
make any difference in reclaiming the performance similar to what it
was with dioread_lock enabled.
Below are the workarounds which helped us reclaiming the performance
back to what it was before commit 244adf6426(ext4: make dioread_nolock
the default)

Mounting using dioread_lock
Enabling nodelalloc and that=E2=80=99s  because since commit c8980e1980(ext=
4:
disable dioread_nolock whenever delayed allocation is disabled)
dioread_nolock will be disabled whenever you disable delayed
allocation.
Increasing the journal size from ext4 128 MiB to 1GiB will also fix the pro=
blem.

We know that dioread_nolock is pretty much beneficial for parallel
direct reads as with it enabled we shouldn=E2=80=99t use the DIO read locki=
ng
however with buffered writes ext4 will allocate uninitialized extent
before buffer  write and convert the extent to initialized after IO
completes and this seems to be the cause behind the reported
regression and we have to note that  this should be only beneficial
with extent-based files, it=E2=80=99s also mentioned in the ext4 man page
https://www.kernel.org/doc/Documentation/filesystems/ext4.txt  that
dioread_lock is the default which no longer the case since commit
244adf6426(ext4: make dioread_nolock the default) so will need to
update the documentations unless we are going to revert the previously
mentioned commit for the listed reasons.
I think we should revert the previously mentioned commit as this is
clear performance regression otherwise we need to make it explicit in
the commit message that this option has higher journaling overhead and
will require higher journal space if this is working as designed.

I will submit a revert patch for commit 244adf6426(ext4: make
dioread_nolock the default)  if that=E2=80=99s what we agreed on after the
discussion



Thank you.



Hazem
