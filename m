Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BC63215E0
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhBVMN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230178AbhBVMNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:13:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3385964E24;
        Mon, 22 Feb 2021 12:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613995989;
        bh=YJUBo3kb5pH9WjfZ1keeUYLSIPyTImC14yv9XRVnZS4=;
        h=From:To:Cc:Subject:Date:From;
        b=RF04ouFHXJXl4BOsrHIv6VLnyHqjIaCpGKoJryA9iDTDQ6sfEgv5ICGeOi2ggeoOR
         kF3I2A3OuQL0ckqpM7zYD18qtCCcOCWirIV2o6QYpnTndZQWBvxBk+eZp7nO7/rDdD
         JtBCAj5sEkIoDwBszzsHaHAWjTD0U1mdq2DjMhZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.11 00/12] 5.11.1-rc1 review
Date:   Mon, 22 Feb 2021 13:12:52 +0100
Message-Id: <20210222121013.586597942@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.11.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.1-rc1
X-KernelTest-Deadline: 2021-02-24T12:10+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.1 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.1-rc1

Matwey V. Kornilov <matwey@sai.msu.ru>
    media: pwc: Use correct device for DMA

Trent Piepho <tpiepho@gmail.com>
    Bluetooth: btusb: Always fallback to alt 1 for WBS

Linus Torvalds <torvalds@linux-foundation.org>
    tty: protect tty_write from odd low-level tty disciplines

Jan Beulich <jbeulich@suse.com>
    xen-blkback: fix error handling in xen_blkbk_map()

Jan Beulich <jbeulich@suse.com>
    xen-scsiback: don't "handle" error by BUG()

Jan Beulich <jbeulich@suse.com>
    xen-netback: don't "handle" error by BUG()

Jan Beulich <jbeulich@suse.com>
    xen-blkback: don't "handle" error by BUG()

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen/arm: don't ignore return errors from set_phys_to_machine

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: correct error checking in gntdev_map_grant_pages()

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()

Jan Beulich <jbeulich@suse.com>
    Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()

Jan Beulich <jbeulich@suse.com>
    Xen/x86: don't bail early from clear_foreign_p2m_mapping()


-------------

Diffstat:

 Makefile                            |  4 ++--
 arch/arm/xen/p2m.c                  |  6 ++++--
 arch/x86/xen/p2m.c                  | 15 +++++++--------
 drivers/block/xen-blkback/blkback.c | 32 ++++++++++++++++++--------------
 drivers/bluetooth/btusb.c           | 20 ++++++--------------
 drivers/media/usb/pwc/pwc-if.c      | 22 +++++++++++++---------
 drivers/net/xen-netback/netback.c   |  4 +---
 drivers/tty/tty_io.c                |  5 ++++-
 drivers/xen/gntdev.c                | 37 ++++++++++++++++++++-----------------
 drivers/xen/xen-scsiback.c          |  4 ++--
 include/xen/grant_table.h           |  1 +
 11 files changed, 78 insertions(+), 72 deletions(-)


