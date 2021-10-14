Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FC842DCE4
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhJNPCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhJNPBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 956FD6120D;
        Thu, 14 Oct 2021 14:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223526;
        bh=F6cAyb9YjU9zZ8eWPv3WUj2arDIgo8WrmczzKSEMu48=;
        h=From:To:Cc:Subject:Date:From;
        b=IUSyLULa8Ht4/l+THRKY3upISiVEHMFcG4fHJrKxJcv+RnNNS9YyjJ7pft5mqRokq
         kBI1Wmwzj3MrFgUUPpV8LWehbE41AdgSZTTt/C909Vsdss/D8q+K6GX7UG5/qHoXe9
         L6wfbRBo91BUfUL1nEoHZdePAumiYgED1hxgqZ3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/12] 4.19.212-rc1 review
Date:   Thu, 14 Oct 2021 16:54:00 +0200
Message-Id: <20211014145206.566123760@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.212-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.212-rc1
X-KernelTest-Deadline: 2021-10-16T14:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.212 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.212-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.212-rc1

Peter Zijlstra <peterz@infradead.org>
    sched: Always inline is_percpu_thread()

Anand K Mistry <amistry@google.com>
    perf/x86: Reset destroy callback on event init failure

Colin Ian King <colin.king@canonical.com>
    scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    scsi: ses: Fix unsigned comparison with less than zero

Randy Dunlap <rdunlap@infradead.org>
    net: sun: SUNVNET_COMMON should depend on INET

MichelleJin <shjy180909@gmail.com>
    mac80211: check return value of rhashtable_init

王贇 <yun.wang@linux.alibaba.com>
    net: prevent user from passing illegal stab size

Al Viro <viro@zeniv.linux.org.uk>
    m68k: Handle arrivals of multiple signals correctly

YueHaibing <yuehaibing@huawei.com>
    mac80211: Drop frames from invalid MAC address in ad-hoc mode

Jeremy Sowden <jeremy@azazel.net>
    netfilter: ip6_tables: zero-initialize fragment offset

Mizuho Mori <morimolymoly@gmail.com>
    HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: bcm7xxx: Fixed indirect MMD operations


-------------

Diffstat:

 Makefile                         |  4 +-
 arch/m68k/kernel/signal.c        | 88 ++++++++++++++++++-------------------
 arch/x86/events/core.c           |  1 +
 drivers/hid/hid-apple.c          |  7 +++
 drivers/net/ethernet/sun/Kconfig |  1 +
 drivers/net/phy/bcm7xxx.c        | 94 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ses.c               |  2 +-
 drivers/scsi/virtio_scsi.c       |  4 +-
 include/linux/sched.h            |  2 +-
 include/net/pkt_sched.h          |  1 +
 net/ipv6/netfilter/ip6_tables.c  |  1 +
 net/mac80211/mesh_pathtbl.c      |  5 ++-
 net/mac80211/rx.c                |  3 +-
 net/sched/sch_api.c              |  6 +++
 14 files changed, 165 insertions(+), 54 deletions(-)


