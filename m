Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DC0255DDD
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 17:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgH1P2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 11:28:55 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45954 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgH1P2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 11:28:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598628516; x=1630164516;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=O0htGam+5XgQ5FN20ElWSvBLSIGTMCdCBOrW7u3A85M=;
  b=U1IRTyYMdL9oVct568IJufYLcFmdsIBIcLgFX42+RWaH3v86aOQtnqaq
   bDLdPZ2zfCNZpceoA0Sow9xcyrbtR3s21Wqzz8/QxF0fACurl30VYoc2E
   8VEnW/cMV0DurZanNeCbBRZGWrEm5jBhJ8XIq9GLqiLbvcpb4cZnU/nb2
   Y=;
X-IronPort-AV: E=Sophos;i="5.76,364,1592870400"; 
   d="scan'208";a="50679147"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 28 Aug 2020 15:28:29 +0000
Received: from EX13D31EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id A3C97C1A03;
        Fri, 28 Aug 2020 15:28:20 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.38) by
 EX13D31EUB001.ant.amazon.com (10.43.166.210) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 28 Aug 2020 15:28:08 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Muchun Song <songmuchun@bytedance.com>,
        Filipe Manana <fdmanana@suse.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, Jan Kara <jack@suse.cz>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Adam Ford <aford173@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     <amit@kernel.org>, <sjpark@amazon.com>, <sj38.park@gmail.com>,
        <stable@vger.kernel.org>
Subject: [5.4.y] Found 27 commits that might missed
Date:   Fri, 28 Aug 2020 17:27:45 +0200
Message-ID: <20200828152745.10819-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D25UWC002.ant.amazon.com (10.43.162.210) To
 EX13D31EUB001.ant.amazon.com (10.43.166.210)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

Hello,


We found below 27 commits in the 'v5.5..linus/master (upstream)' seems fixing or mentioning
commits in the 'v5.4..stable/linux-5.4.y (downstream)' but are not merged in the 'downstream' yet.
Could you please review if those need to be merged in?

A commit is considered as fix of another if the complete 'Fixed:' tag is in the
commit message.  If the tag is not found but the commit message contains the
title or the hash id of the other commit, it is considered mentioning it.  So,
the 'mentions' might have many false positives, but it could cover the typos (I
found such cases before).

The commits are grouped as 'fixes cleanly applicable', 'fixes not cleanly
applicable (need manual backporting to be applied)', 'mentions cleanly
applicable', and 'mentions not cleanly applicable'.  Also, the commits in each
group are sorted by the commit dates (oldest first).

Both the finding of the commits and the writeup of this report is automatically
done by a little script[1].  I'm going to run the tool and post this kind of
report every couple of weeks or every month.  Any comment (e.g., regarding
posting period, new features request, bug report, ...) is welcome.

Especially, if you find some commits that don't need to be merged in the
downstream, please let me know so that I can mark those as unnecessary and
don't bother you again.

[1] https://github.com/sjp38/stream-track


Thanks,
SeongJae


# v5.5: 4e3112a240ba9986cc3f67a6880da6529a955006
# linus/master: 15bc20c6af4ceee97a1f90b43c0e386643c071b4
# v5.4: 6e815efe19a99a33b16cc720c3d3a727565a4fa1
# stable/linux-5.4.y: 6576d69aac94cd8409636dfa86e0df39facdf0d2


Fixes cleanly applicable
------------------------

2fb75ceaf71a ("remoteproc: Add missing '\n' in log messages")
# commit date: 2020-04-22, author: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
# fixes 'remoteproc: Fix NULL pointer dereference in rproc_virtio_notify'

1b9ae0c92925 ("wireless: Use linux/stddef.h instead of stddef.h")
# commit date: 2020-05-27, author: Hauke Mehrtens <hauke@hauke-m.de>
# fixes 'wireless: Use offsetof instead of custom macro.'

e4b0e41fee94 ("ALSA: usb-audio: Use the new macro for HP Dock rename quirks")
# commit date: 2020-06-08, author: Takashi Iwai <tiwai@suse.de>
# fixes 'ALSA: usb-audio: Add vendor, product and profile name for HP Thunderbolt Dock'

efb94790852a ("drm/panel-simple: fix connector type for LogicPD Type28 Display")
# commit date: 2020-06-21, author: Adam Ford <aford173@gmail.com>
# fixes 'drm/panel: simple: Add Logic PD Type 28 display support'

2f57b8d57673 ("dmaengine: imx-sdma: Fix: Remove 'always true' comparison")
# commit date: 2020-06-24, author: Fabio Estevam <festevam@gmail.com>
# fixes 'dmaengine: imx-sdma: Fix the event id check to include RX event for UART6'

10de795a5add ("kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE")
# commit date: 2020-08-06, author: Muchun Song <songmuchun@bytedance.com>
# fixes 'kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler'



Fixes not cleanly applicable
----------------------------

3907ccfaec5d ("crypto: atmel-aes - Fix CTR counter overflow when multiple fragments")
# commit date: 2019-12-20, author: Tudor Ambarus <tudor.ambarus@microchip.com>
# fixes 'crypto: atmel-aes - Fix counter overflow in CTR mode'

9210c075cef2 ("nvme-pci: avoid race between nvme_reap_pending_cqes() and nvme_poll()")
# commit date: 2020-05-27, author: Dongli Zhang <dongli.zhang@oracle.com>
# fixes 'nvme/pci: move cqe check after device shutdown'

6e2f83884c09 ("bnxt_en: Fix AER reset logic on 57500 chips.")
# commit date: 2020-06-15, author: Michael Chan <michael.chan@broadcom.com>
# fixes 'bnxt_en: Improve AER slot reset.'

695cf5ab401c ("ALSA: usb-audio: Fix packet size calculation")
# commit date: 2020-06-30, author: Alexander Tsoy <alexander@tsoy.me>
# fixes 'ALSA: usb-audio: Improve frames size computation'

2fb2799a2abb ("net: rmnet: do not allow to add multiple bridge interfaces")
# commit date: 2020-07-04, author: Taehee Yoo <ap420073@gmail.com>
# fixes 'net: rmnet: use upper/lower device infrastructure'



Mentions cleanly applicable
---------------------------

32ada3b9e04c ("x86/resctrl: Clean up unused function parameter in mkdir path")
# commit date: 2020-01-20, author: Xiaochen Shen <xiaochen.shen@intel.com>
# mentions 'x86/resctrl: Fix a deadlock due to inaccurate reference'

20f513091caf ("crypto: ccree - remove set but not used variable 'du_size'")
# commit date: 2020-02-13, author: YueHaibing <yuehaibing@huawei.com>
# mentions 'crypto: ccree - fix FDE descriptor sequence'

b182a66792fe ("net: ena: remove set but not used variable 'hash_key'")
# commit date: 2020-02-17, author: YueHaibing <yuehaibing@huawei.com>
# mentions 'net: ena: rss: do not allocate key when not supported'

cbb5494ebce5 ("Revert "thunderbolt: Prevent crash if non-active NVMem file is read"")
# commit date: 2020-04-16, author: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
# mentions 'thunderbolt: Prevent crash if non-active NVMem file is read'

1a33e10e4a95 ("net: partially revert dynamic lockdep key changes")
# commit date: 2020-05-04, author: Cong Wang <xiyou.wangcong@gmail.com>
# mentions 'bonding: add missing netdev_update_lockdep_key()'

7e579f3a074c ("tools arch x86 uapi: Synch asm/unistd.h with the kernel sources")
# commit date: 2020-06-09, author: Arnaldo Carvalho de Melo <acme@redhat.com>
# mentions 'x86/syscalls: Revert "x86/syscalls: Make __X32_SYSCALL_BIT be unsigned long"'

c3dbe541ef77 ("blktrace: Avoid sparse warnings when assigning q->blk_trace")
# commit date: 2020-06-17, author: Jan Kara <jack@suse.cz>
# mentions 'blktrace: Protect q->blk_trace with RCU'

6d548b9e5d56 ("btrfs: fix reclaim_size counter leak after stealing from global reserve")
# commit date: 2020-07-02, author: Filipe Manana <fdmanana@suse.com>
# mentions 'btrfs: improve global reserve stealing logic'



Mentions not cleanly applicable
-------------------------------

6dbd54e4154d ("Revert "tty/serial: atmel: fix out of range clock divider handling"")
# commit date: 2019-12-18, author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
# mentions 'tty/serial: atmel: fix out of range clock divider handling'

48d7fb181a91 ("drm/i915: Remove lite restore defines")
# commit date: 2020-02-08, author: Mika Kuoppala <mika.kuoppala@linux.intel.com>
# mentions 'drm/i915/gt: Detect if we miss WaIdleLiteRestore'

ff7e06a55676 ("ALSA: pcm: oss: Fix regression by buffer overflow fix (again)")
# commit date: 2020-04-03, author: Takashi Iwai <tiwai@suse.de>
# mentions 'ALSA: pcm: oss: Avoid plugin buffer overflow'

ac957e8c5411 ("ALSA: pcm: oss: Place the plugin buffer overflow checks correctly (for 5.7)")
# commit date: 2020-04-24, author: Takashi Iwai <tiwai@suse.de>
# mentions 'ALSA: pcm: oss: Avoid plugin buffer overflow'

e7511f560f54 ("bonding: remove useless stats_lock_key")
# commit date: 2020-05-04, author: Cong Wang <xiyou.wangcong@gmail.com>
# mentions 'bonding: fix lockdep warning in bond_get_stats()'

39f23ce07b93 ("sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list")
# commit date: 2020-05-19, author: Vincent Guittot <vincent.guittot@linaro.org>
# mentions 'sched/fair: Fix enqueue_task_fair warning'

8ab3a3812aa9 ("drm/i915/gt: Incrementally check for rewinding")
# commit date: 2020-06-16, author: Chris Wilson <chris@chris-wilson.co.uk>
# mentions 'drm/i915/execlists: Always force a context reload when rewinding RING_TAIL'

5e548b32018d ("btrfs: do not set the full sync flag on the inode during page release")
# commit date: 2020-07-27, author: Filipe Manana <fdmanana@suse.com>
# mentions 'btrfs: fix race between page release and a fast fsync'
