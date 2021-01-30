Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6911F3095CA
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 15:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhA3OMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 09:12:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhA3OLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 09:11:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D941364E09;
        Sat, 30 Jan 2021 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612015836;
        bh=ND8S9ShaVQVgOybTWZJecZcTZl/VXdSjEZMvrkI36v4=;
        h=From:To:Cc:Subject:Date:From;
        b=aHJyuXr1TeJ8pE+TpuXwPE3wnLqYwYVofkhbmyBeZm989RsvYs2koJ5s3ii2+ITsC
         9YpspTXyROjnvtw9MkiRPl7MquZuxigKL6mToHu7kwMDngmXQinYckR61RQQLmpE9T
         TgLEOsFSsNFnkNmaafTpEjA2ysjZPJgilD6jY6NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.172
Date:   Sat, 30 Jan 2021 15:10:22 +0100
Message-Id: <161201582266161@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.172 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/device-mapper/dm-integrity.txt |    7 
 Makefile                                     |    2 
 drivers/gpio/gpio-mvebu.c                    |   25 -
 drivers/hid/wacom_sys.c                      |    7 
 drivers/hid/wacom_wac.h                      |    2 
 drivers/md/dm-integrity.c                    |   24 +
 fs/exec.c                                    |    2 
 fs/ext4/inode.c                              |    2 
 fs/fs-writeback.c                            |   36 --
 fs/xfs/xfs_trans_inode.c                     |    4 
 include/linux/compat.h                       |    2 
 include/linux/fs.h                           |    1 
 include/linux/futex.h                        |   40 +-
 include/linux/sched.h                        |    3 
 include/linux/sched/mm.h                     |    6 
 include/trace/events/writeback.h             |    1 
 kernel/exit.c                                |   30 -
 kernel/fork.c                                |   40 --
 kernel/futex.c                               |  485 ++++++++++++++++++---------
 kernel/locking/rtmutex.c                     |    3 
 kernel/locking/rtmutex_common.h              |    3 
 kernel/trace/ring_buffer.c                   |    4 
 mm/slub.c                                    |    4 
 tools/build/Makefile                         |    4 
 tools/objtool/Makefile                       |    9 
 tools/perf/Makefile.perf                     |    4 
 tools/power/acpi/Makefile.config             |    1 
 tools/scripts/Makefile.include               |   10 
 28 files changed, 459 insertions(+), 302 deletions(-)

Baruch Siach (1):
      gpio: mvebu: fix pwm .get_state period calculation

Eric Biggers (1):
      fs: fix lazytime expiration handling in __writeback_single_inode()

Gaurav Kohli (1):
      tracing: Fix race in trace_open and buffer resize call

Greg Kroah-Hartman (1):
      Linux 4.19.172

Jan Kara (1):
      writeback: Drop I_DIRTY_TIME_EXPIRE

Jason Gerecke (1):
      HID: wacom: Correct NULL dereference on AES pen proximity

Jean-Philippe Brucker (1):
      tools: Factor HOSTCC, HOSTLD, HOSTAR definitions

Mikulas Patocka (1):
      dm integrity: conditionally disable "recalculate" feature

Thomas Gleixner (18):
      futex: Move futex exit handling into futex code
      futex: Replace PF_EXITPIDONE with a state
      exit/exec: Seperate mm_release()
      futex: Split futex_mm_release() for exit/exec
      futex: Set task::futex_state to DEAD right after handling futex exit
      futex: Mark the begin of futex exit explicitly
      futex: Sanitize exit state handling
      futex: Provide state handling for exec() as well
      futex: Add mutex around futex exit
      futex: Provide distinct return value when owner is exiting
      futex: Prevent exit livelock
      futex: Ensure the correct return value from futex_lock_pi()
      futex: Replace pointless printk in fixup_owner()
      futex: Provide and use pi_state_update_owner()
      rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
      futex: Use pi_state_update_owner() in put_pi_state()
      futex: Simplify fixup_pi_state_owner()
      futex: Handle faults correctly for PI futexes

Wang Hai (1):
      Revert "mm/slub: fix a memory leak in sysfs_slab_add()"

