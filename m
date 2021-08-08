Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E583E3966
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhHHHXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhHHHXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:23:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC02860EE7;
        Sun,  8 Aug 2021 07:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628407372;
        bh=XGYYRQow5YWAKiq7u48NhRiDXmC9gP8wUOFsh1QXQK4=;
        h=From:To:Cc:Subject:Date:From;
        b=EGhkw9UBo5PnbMyw6P8MmG9MNjAOoZ1vNdwMGihEHONPfC0MWAan2iLOrqaxKK4n8
         pX4HrN8G1yCF2YKV3YWjRg5X1F7PWR4r0TD35jQAkg/tlabJS5oS/Hk90mzngOxCQF
         T8wlq3jRDPphVCv3vIxkjNulQ8iPm/KoIEO84U4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/11] 4.4.280-rc1 review
Date:   Sun,  8 Aug 2021 09:22:35 +0200
Message-Id: <20210808072217.322468704@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.280-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.280-rc1
X-KernelTest-Deadline: 2021-08-10T07:22+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.280 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 10 Aug 2021 07:22:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.280-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.280-rc1

Anna-Maria Gleixner <anna-maria@linutronix.de>
    rcu: Update documentation of rcu_read_unlock()

Peter Zijlstra <peterz@infradead.org>
    futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()

Thomas Gleixner <tglx@linutronix.de>
    futex: Avoid freeing an active timer

Mike Galbraith <efault@gmx.de>
    futex: Handle transient "ownerless" rtmutex state correctly

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Make wait_lock irq safe

Peter Zijlstra <peterz@infradead.org>
    futex: Futex_unlock_pi() determinism

Peter Zijlstra <peterz@infradead.org>
    futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()

Peter Zijlstra <peterz@infradead.org>
    futex: Pull rt_mutex_futex_unlock() out from under hb->lock

Peter Zijlstra <peterz@infradead.org>
    futex,rt_mutex: Introduce rt_mutex_init_waiter()

Peter Zijlstra <peterz@infradead.org>
    futex: Cleanup refcounting

Thomas Gleixner <tglx@linutronix.de>
    futex: Rename free_pi_state() to put_pi_state()


-------------

Diffstat:

 Makefile                        |   4 +-
 include/linux/rcupdate.h        |   4 +-
 kernel/futex.c                  | 245 ++++++++++++++++++++++++++--------------
 kernel/locking/rtmutex.c        | 185 ++++++++++++++++--------------
 kernel/locking/rtmutex_common.h |   2 +-
 5 files changed, 264 insertions(+), 176 deletions(-)


