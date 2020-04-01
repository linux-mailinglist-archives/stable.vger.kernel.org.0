Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E10319AFA2
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732574AbgDAQTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732545AbgDAQTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:19:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2AF620658;
        Wed,  1 Apr 2020 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585757990;
        bh=/uFLWwHDu9UnM9l2Rzf0l5xvw4/SzBCc5ZNeZVG0iqs=;
        h=From:To:Cc:Subject:Date:From;
        b=si1GZGUplI3K0S4JHMyRqkMxc/tYqiazLi/GIhA3o7Pvvm9HxOqsUJR3Mf8McB4yj
         zYrmRSCtKJAlxaDaVKpaQUakDRhzOXKvKO7CV5NRmhR8IKX9E37lsbKrB7x1Fkk88T
         YnEBa3XALEUa1dbXjH281dQ/gtrFyNRnctBTjypk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 00/10] 5.6.2-rc1 review
Date:   Wed,  1 Apr 2020 18:17:16 +0200
Message-Id: <20200401161413.974936041@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.2-rc1
X-KernelTest-Deadline: 2020-04-03T16:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.2 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.2-rc1

Georg Müller <georgmueller@gmx.net>
    platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix use-after-free in vt_in_use()

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: remove unnecessary console allocation checks

Jiri Slaby <jslaby@suse.cz>
    vt: switch vt_dont_switch to bool

Jiri Slaby <jslaby@suse.cz>
    vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines

Jiri Slaby <jslaby@suse.cz>
    vt: selection, introduce vc_is_sel

Lanqing Liu <liuhhome@gmail.com>
    serial: sprd: Fix a dereference warning

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix authentication with iwlwifi/mvm

Daniel Borkmann <daniel@iogearbox.net>
    bpf: update jmp32 test cases to fix range bound deduction


-------------

Diffstat:

 Makefile                                     |  4 +-
 drivers/platform/x86/pmc_atom.c              |  8 +++
 drivers/tty/serial/sprd_serial.c             |  3 +-
 drivers/tty/vt/selection.c                   |  5 ++
 drivers/tty/vt/vt.c                          | 30 +++++++++--
 drivers/tty/vt/vt_ioctl.c                    | 75 +++++++++++++++-------------
 include/linux/selection.h                    |  4 +-
 include/linux/vt_kern.h                      |  2 +-
 net/mac80211/tx.c                            |  3 +-
 tools/testing/selftests/bpf/verifier/jmp32.c |  9 ++--
 10 files changed, 94 insertions(+), 49 deletions(-)


