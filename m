Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBE649E9F5
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245131AbiA0SLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:11:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59280 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245328AbiA0SKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48C70B820CA;
        Thu, 27 Jan 2022 18:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2CEC340E4;
        Thu, 27 Jan 2022 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307035;
        bh=6xBTFrwEO1ZwAOEOPkfOtbUZNRjMR9cuYnyNBRwpWVA=;
        h=From:To:Cc:Subject:Date:From;
        b=OXZU7rTYin6Z4EPBWy3XHAz681Wci24xVBfnKw+ZwMIK8/nDxCudWUS6OxHuYMWlB
         XSidKv9V6lqhijUl9HVFOoIZQbnAuFDDtrZQiyelaD2UwcPAzLNDW7/5KDdjn0tFKq
         sZPY0i5FdQ9WIyCF+zxspsO8XQ0UPqP5V265ZJBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 5.10 0/6] 5.10.95-rc1 review
Date:   Thu, 27 Jan 2022 19:09:16 +0100
Message-Id: <20220127180258.131170405@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.95-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.95-rc1
X-KernelTest-Deadline: 2022-01-29T18:02+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.95 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.95-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.95-rc1

Jan Kara <jack@suse.cz>
    select: Fix indefinitely sleeping task in poll_schedule_timeout()

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU

Paul E. McKenney <paulmck@kernel.org>
    rcu: Tighten rcu_advance_cbs_nowake() checks

Manish Chopra <manishc@marvell.com>
    bnx2x: Invalidate fastpath HSI version for VFs

Manish Chopra <manishc@marvell.com>
    bnx2x: Utilize firmware 7.13.21.0

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Flush TLBs before releasing backing store


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   6 +-
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
 fs/select.c                                        |  63 +++++++------
 kernel/rcu/tree.c                                  |   7 +-
 19 files changed, 277 insertions(+), 72 deletions(-)


