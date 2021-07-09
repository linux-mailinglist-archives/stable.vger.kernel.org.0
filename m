Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EBA3C24F6
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhGINZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhGINZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EE55611B0;
        Fri,  9 Jul 2021 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836969;
        bh=iauS/4yoH6qXvgp9oJnWadjKGl/f4vFBi1NzcoLUQmw=;
        h=From:To:Cc:Subject:Date:From;
        b=Fif+unNL5tKtptoI1b15gF7yc1YdgjCi0DOHHNKdCjYcU1z4q90cI6xvuIzLGNvSF
         uzYr8dk5DEDYWeQTnZ0oZQttZF6DTyLycX3tEO06+aab36nsQmkXV5MCxUbvXYnohp
         PEvgyP03kY6z5Pn8HZ7L6iL4SUrQryUVe0Yx1P2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.12 00/11] 5.12.16-rc1 review
Date:   Fri,  9 Jul 2021 15:21:37 +0200
Message-Id: <20210709131549.679160341@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.16-rc1
X-KernelTest-Deadline: 2021-07-11T13:16+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.12.16 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.12.16-rc1

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: get rid of mcu_reset function pointer

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: abort uncompleted scan by wifi reset

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: add wifi reset support

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: export mt76_dma_rx_cleanup routine

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: introduce mt76_dma_queue_reset routine

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: introduce __mt7921_start utility routine

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: introduce mt7921_run_firmware utility routine.

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: check mcu returned values in mt7921_start

Sid Manning <sidneym@codeaurora.org>
    Hexagon: change jumps to must-extend in futex_atomic_*

Sid Manning <sidneym@codeaurora.org>
    Hexagon: add target builtins to kernel

Sid Manning <sidneym@codeaurora.org>
    Hexagon: fix build errors


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/hexagon/Makefile                              |   6 +-
 arch/hexagon/include/asm/futex.h                   |   4 +-
 arch/hexagon/include/asm/timex.h                   |   3 +-
 arch/hexagon/kernel/hexagon_ksyms.c                |   8 +-
 arch/hexagon/kernel/ptrace.c                       |   4 +-
 arch/hexagon/lib/Makefile                          |   3 +-
 arch/hexagon/lib/divsi3.S                          |  67 +++++++
 arch/hexagon/lib/memcpy_likely_aligned.S           |  56 ++++++
 arch/hexagon/lib/modsi3.S                          |  46 +++++
 arch/hexagon/lib/udivsi3.S                         |  38 ++++
 arch/hexagon/lib/umodsi3.S                         |  36 ++++
 drivers/net/wireless/mediatek/mt76/dma.c           |  47 +++--
 drivers/net/wireless/mediatek/mt76/mt76.h          |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 209 +++++++++++++++------
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  38 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  36 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |   4 +
 20 files changed, 508 insertions(+), 118 deletions(-)


