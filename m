Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B243FDCD1
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345269AbhIAMxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345191AbhIAMvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:51:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DD2561252;
        Wed,  1 Sep 2021 12:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500178;
        bh=NSrvlgG1OGAPzejKZYW5fTPnbUmv1NIH6dDo2OIK7gc=;
        h=From:To:Cc:Subject:Date:From;
        b=TwTlOfHUGBNrnMbClw7KYH0bobDzVZzPu5Hmk/MOBbhXaVSOKdkuUm/nPXecu9w7X
         NOmjmCE6mOuCnyZHRY8S1SCh9aYx6Z+s+Dh4KL45N/2RVGy47ZrBid7qzEj5Js5S7a
         hl04bdKPjdd/Mb3rAm+sHToW7p3VP7ks4HTHhMXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 00/11] 5.14.1-rc1 review
Date:   Wed,  1 Sep 2021 14:29:08 +0200
Message-Id: <20210901122249.520249736@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.1-rc1
X-KernelTest-Deadline: 2021-09-03T12:22+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.1 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.1-rc1

Richard Guy Briggs <rgb@redhat.com>
    audit: move put_tree() to avoid trim_trees refcount underflow and UAF

Peter Collingbourne <pcc@google.com>
    net: don't unconditionally copy_from_user a struct ifreq for socket ioctls

Eric Biggers <ebiggers@google.com>
    ubifs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    f2fs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    ext4: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    fscrypt: add fscrypt_symlink_getattr() for computing st_size

Denis Efremov <efremov@linux.com>
    Revert "floppy: reintroduce O_NDELAY fix"

Qu Wenruo <wqu@suse.com>
    btrfs: fix NULL pointer dereference when deleting device by invalid id

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix VLAN traffic leaks again

Pauli Virtanen <pav@iki.fi>
    Bluetooth: btusb: check conditions before enabling USB ALT 3 for WBS

Linus Torvalds <torvalds@linux-foundation.org>
    vt_kdsetmode: extend console locking


-------------

Diffstat:

 Makefile                  |  4 ++--
 drivers/block/floppy.c    | 30 +++++++++++++++---------------
 drivers/bluetooth/btusb.c | 22 ++++++++++++++--------
 drivers/net/dsa/mt7530.c  |  5 +----
 drivers/tty/vt/vt_ioctl.c | 10 ++++++----
 fs/btrfs/volumes.c        |  2 +-
 fs/crypto/hooks.c         | 44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/symlink.c         | 12 +++++++++++-
 fs/f2fs/namei.c           | 12 +++++++++++-
 fs/ubifs/file.c           | 13 ++++++++++++-
 include/linux/fscrypt.h   |  7 +++++++
 include/linux/netdevice.h |  4 ++++
 kernel/audit_tree.c       |  2 +-
 net/socket.c              |  6 +++++-
 14 files changed, 134 insertions(+), 39 deletions(-)


