Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE1423CD04
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 19:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgHERO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 13:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbgHERKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 13:10:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70ECC2339D;
        Wed,  5 Aug 2020 15:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642785;
        bh=fn49Rk2Cqy97YNiLut0TUdVYUCdTceQqwb/lCEf+lJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=X9L9G6gnCtR3iRCjTWf1GTISvJcFTyjh9CNlPq2rRBFBeDZA6gMCQRpHcH9aldHvE
         oEqQIBl6icNj4807wL2IXXmnCgG0hI0hAiTAlrNqiFjSE+kIO8GKzHT/W5KzpGY62W
         +j3tqJgcdGBvsJGb1DcsE502kE+CO+iXhPCfbDXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 0/9] 5.4.57-rc1 review
Date:   Wed,  5 Aug 2020 17:52:37 +0200
Message-Id: <20200805153507.053638231@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.57-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.57-rc1
X-KernelTest-Deadline: 2020-08-07T15:35+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.57 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.57-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.57-rc1

Lorenz Bauer <lmb@cloudflare.com>
    bpf: sockmap: Require attach_bpf_fd when detaching a program

Lorenz Bauer <lmb@cloudflare.com>
    selftests: bpf: Fix detach from sockmap tests

Jiang Ying <jiangying8582@126.com>
    ext4: fix direct I/O read error

Marc Zyngier <maz@kernel.org>
    arm64: Workaround circular dependency in pointer_auth.h

Linus Torvalds <torvalds@linux-foundation.org>
    random32: move the pseudo-random 32-bit definitions to prandom.h

Linus Torvalds <torvalds@linux-foundation.org>
    random32: remove net_rand_state from the latent entropy gcc plugin

Willy Tarreau <w@1wt.eu>
    random: fix circular include dependency on arm64 after addition of percpu.h

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: percpu.h: fix build error

Willy Tarreau <w@1wt.eu>
    random32: update the net random state on interrupt and activity


-------------

Diffstat:

 Makefile                                |  4 +-
 arch/arm/include/asm/percpu.h           |  2 +
 arch/arm64/include/asm/pointer_auth.h   |  8 +++-
 drivers/char/random.c                   |  1 +
 fs/ext4/inode.c                         |  5 +++
 include/linux/bpf.h                     | 13 +++++-
 include/linux/prandom.h                 | 78 +++++++++++++++++++++++++++++++++
 include/linux/random.h                  | 63 ++------------------------
 include/linux/skmsg.h                   | 13 ++++++
 kernel/bpf/syscall.c                    |  4 +-
 kernel/time/timer.c                     |  8 ++++
 lib/random32.c                          |  2 +-
 net/core/sock_map.c                     | 50 ++++++++++++++++++---
 tools/testing/selftests/bpf/test_maps.c | 12 ++---
 14 files changed, 185 insertions(+), 78 deletions(-)


