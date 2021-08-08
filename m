Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45D63E3952
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhHHHQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhHHHQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:16:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D0DE60F02;
        Sun,  8 Aug 2021 07:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628406948;
        bh=fcyS5osPGtTNQQ7e6bmn9YxrkalLLfdNlOl8IFWLK4A=;
        h=From:To:Cc:Subject:Date:From;
        b=cxBiDWS03XfGxR0/XyJ37jPUppdw3XWpfWwuJ1b6rJCmDCblXJv3WIZW+EMKuqa4e
         qbXJbdkAY0opWjwjLFHOeeWOTOSs/A5zVEixj/3ks+jCwOKlJ9waiFwguSe5Gv1wF0
         9BoxjuYWQSWSMrAJKJSKdwLyJzDSAqvWRg5XX0Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.139
Date:   Sun,  8 Aug 2021 09:15:44 +0200
Message-Id: <1628406945167165@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.139 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 drivers/firmware/arm_scmi/bus.c                        |    3 
 drivers/firmware/arm_scmi/driver.c                     |    8 -
 drivers/net/ethernet/qlogic/qed/qed_mcp.c              |   23 ++-
 drivers/net/usb/r8152.c                                |    3 
 drivers/nvme/host/trace.h                              |    6 
 drivers/spi/spi-mt65xx.c                               |   19 --
 drivers/spi/spi-stm32.c                                |   15 +-
 drivers/watchdog/iTCO_wdt.c                            |   12 -
 fs/btrfs/block-group.c                                 |    2 
 fs/btrfs/ctree.c                                       |    2 
 fs/btrfs/disk-io.c                                     |    2 
 fs/btrfs/extent_io.c                                   |    2 
 fs/btrfs/free-space-cache.c                            |    2 
 fs/btrfs/inode.c                                       |  115 +----------------
 fs/btrfs/qgroup.c                                      |    2 
 fs/btrfs/tree-log.c                                    |  107 ++++++---------
 fs/btrfs/tree-log.h                                    |   14 --
 include/acpi/acpi_bus.h                                |    3 
 include/linux/mfd/rt5033-private.h                     |    4 
 kernel/bpf/verifier.c                                  |   65 ++++++++-
 net/bluetooth/hci_core.c                               |   16 +-
 net/core/skbuff.c                                      |    5 
 sound/soc/codecs/tlv320aic31xx.h                       |    4 
 tools/testing/selftests/bpf/test_verifier.c            |    2 
 tools/testing/selftests/bpf/verifier/bounds.c          |   65 +++++++++
 tools/testing/selftests/bpf/verifier/dead_code.c       |    2 
 tools/testing/selftests/bpf/verifier/jmp32.c           |   22 +++
 tools/testing/selftests/bpf/verifier/jset.c            |   10 -
 tools/testing/selftests/bpf/verifier/unpriv.c          |    2 
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c |    7 -
 31 files changed, 296 insertions(+), 250 deletions(-)

Alain Volmat (1):
      spi: stm32h7: fix full duplex irq handler handling

Axel Lin (1):
      regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Cristian Marussi (1):
      firmware: arm_scmi: Add delayed response status check

Daniel Borkmann (4):
      bpf: Inherit expanded/patched seen count from old aux data
      bpf: Do not mark insn as seen under speculative path verification
      bpf: Fix leakage under speculation on mispredicted branches
      bpf, selftests: Adjust few selftest outcomes wrt unreachable code

Filipe Manana (3):
      btrfs: do not commit logs and transactions during link and rename operations
      btrfs: fix race causing unnecessary inode logging during link and rename
      btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
      Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
      Linux 5.4.139

Guenter Roeck (1):
      spi: mediatek: Fix fifo transfer

Jia He (1):
      qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

John Fastabend (2):
      bpf: Test_verifier, add alu32 bounds tracking tests
      bpf, selftests: Add a verifier test for assigning 32bit reg states to 64bit ones

Keith Busch (1):
      nvme: fix nvme_setup_command metadata trace event

Kyle Russell (1):
      ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits

Linus Torvalds (1):
      ACPI: fix NULL pointer dereference

Pravin B Shelar (1):
      net: Fix zero-copy head len calculation.

Randy Dunlap (1):
      btrfs: delete duplicated words + other fixes in comments

Sudeep Holla (1):
      firmware: arm_scmi: Ensure drivers provide a probe function

Takashi Iwai (1):
      r8152: Fix potential PM refcount imbalance

