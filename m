Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96693C24D9
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbhGINZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhGINZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00D11613C8;
        Fri,  9 Jul 2021 13:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836948;
        bh=YXjNzQ4dgZy2zKG3SYF7k2Ax7yI8Pmm31un5fz+G228=;
        h=From:To:Cc:Subject:Date:From;
        b=nqSKejZUkY3P67Ekkbw+NcUER5dEMj3Ztu5MpC/i6Lgkvz7TvTj24betUOffkeVOw
         3mBkeXoFMK344OpFLXQiRbmo3zUwf2azdvkhtWUtjgq9Ker4/je/CQVwWz+CNd7yZD
         pWO1Go5O9nzNxz4QfI33B36tJ8aI9yRFThiH9B3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 0/6] 5.10.49-rc1 review
Date:   Fri,  9 Jul 2021 15:21:09 +0200
Message-Id: <20210709131537.035851348@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.49-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.49-rc1
X-KernelTest-Deadline: 2021-07-11T13:15+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.49 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.49-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.49-rc1

Juergen Gross <jgross@suse.com>
    xen/events: reset active flag for lateeoi events later

Sid Manning <sidneym@codeaurora.org>
    Hexagon: change jumps to must-extend in futex_atomic_*

Sid Manning <sidneym@codeaurora.org>
    Hexagon: add target builtins to kernel

Sid Manning <sidneym@codeaurora.org>
    Hexagon: fix build errors

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Support devices that report an OT as an entity source

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path


-------------

Diffstat:

 Makefile                                 |  4 +-
 arch/hexagon/Makefile                    |  6 +--
 arch/hexagon/include/asm/futex.h         |  4 +-
 arch/hexagon/include/asm/timex.h         |  3 +-
 arch/hexagon/kernel/hexagon_ksyms.c      |  8 ++--
 arch/hexagon/kernel/ptrace.c             |  4 +-
 arch/hexagon/lib/Makefile                |  3 +-
 arch/hexagon/lib/divsi3.S                | 67 ++++++++++++++++++++++++++++++++
 arch/hexagon/lib/memcpy_likely_aligned.S | 56 ++++++++++++++++++++++++++
 arch/hexagon/lib/modsi3.S                | 46 ++++++++++++++++++++++
 arch/hexagon/lib/udivsi3.S               | 38 ++++++++++++++++++
 arch/hexagon/lib/umodsi3.S               | 36 +++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c             |  4 ++
 drivers/media/usb/uvc/uvc_driver.c       | 32 +++++++++++++++
 drivers/xen/events/events_base.c         | 23 +++++++++--
 15 files changed, 315 insertions(+), 19 deletions(-)


