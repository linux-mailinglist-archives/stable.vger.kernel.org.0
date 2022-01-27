Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0558549EA12
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245220AbiA0SMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:12:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48684 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245502AbiA0SLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 285AC61D1C;
        Thu, 27 Jan 2022 18:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ECCC340E4;
        Thu, 27 Jan 2022 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307077;
        bh=W1mqs1ld2phG5xDg7wZx0bXk/f8YducFAUZ1xreMwc4=;
        h=From:To:Cc:Subject:Date:From;
        b=KjFHoxb16PCrT14OzkqNk+Jxwh/kYNWNfmkpKrsyYKeM+gm0uQcHaNIgIApIuxchm
         TS9Z+OdTuGjrw2qMWehmnAa3tcqvPxxPvg9q4D90MjP0VmnQvk593MQG8RjQKIlOQ7
         u+JM7YkpDxja/u1ds2rdXehZYjjRKXfZrTqauTIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 5.15 00/12] 5.15.18-rc1 review
Date:   Thu, 27 Jan 2022 19:09:24 +0100
Message-Id: <20220127180259.078563735@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.18-rc1
X-KernelTest-Deadline: 2022-01-29T18:02+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.18 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.18-rc1

Russell King <russell.king@oracle.com>
    arm64/bpf: Remove 128MB limit for BPF JIT programs

Harry Wentland <harry.wentland@amd.com>
    drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2

Jan Kara <jack@suse.cz>
    select: Fix indefinitely sleeping task in poll_schedule_timeout()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Tighten rcu_advance_cbs_nowake() checks

Shakeel Butt <shakeelb@google.com>
    memcg: better bounds on the memcg stats updates

Shakeel Butt <shakeelb@google.com>
    memcg: unify memcg stat flushing

Shakeel Butt <shakeelb@google.com>
    memcg: flush stats only if updated

Manish Chopra <manishc@marvell.com>
    bnx2x: Invalidate fastpath HSI version for VFs

Manish Chopra <manishc@marvell.com>
    bnx2x: Utilize firmware 7.13.21.0

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix not released cached task refs

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: reset dcn31 SMU mailbox on failures

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Flush TLBs before releasing backing store


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/extable.h                   |   9 --
 arch/arm64/include/asm/memory.h                    |   5 +-
 arch/arm64/kernel/traps.c                          |   2 +-
 arch/arm64/mm/extable.c                            |  13 ++-
 arch/arm64/mm/ptdump.c                             |   2 -
 arch/arm64/net/bpf_jit_comp.c                      |   7 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  14 ++-
 .../drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c   |   6 ++
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h   |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_pages.c          |  10 ++
 drivers/gpu/drm/i915/gt/intel_gt.c                 | 102 +++++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_gt.h                 |   2 +
 drivers/gpu/drm/i915/gt/intel_gt_types.h           |   2 +
 drivers/gpu/drm/i915/i915_reg.h                    |  11 +++
 drivers/gpu/drm/i915/i915_vma.c                    |   3 +
 drivers/gpu/drm/i915/intel_uncore.c                |  26 +++++-
 drivers/gpu/drm/i915/intel_uncore.h                |   2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |  11 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    |   2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |   3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  75 ++++++++++-----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  13 ++-
 fs/io_uring.c                                      |  34 ++++---
 fs/select.c                                        |  63 +++++++------
 kernel/rcu/tree.c                                  |   7 +-
 mm/memcontrol.c                                    |  99 ++++++++++++++------
 28 files changed, 396 insertions(+), 138 deletions(-)


