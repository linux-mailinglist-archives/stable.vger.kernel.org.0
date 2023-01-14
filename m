Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B266AA8B
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjANJky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjANJkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:40:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCE7659C;
        Sat, 14 Jan 2023 01:40:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA5360303;
        Sat, 14 Jan 2023 09:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1228C433EF;
        Sat, 14 Jan 2023 09:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689234;
        bh=Kp8YnR2oRrf2rdnpzS7y/3dOaEwTUxesEmPvePTo3tw=;
        h=From:To:Cc:Subject:Date:From;
        b=kJCnaWtxxWH0Vx5FcJUEKlBxWN6hnkeWYbADNadGdbSQU5ODij8Hjvaf7qov+UNsE
         60ZQMZrIaqBPe88lvJ2Q9L4na2q0wOIvasA/2PE677l1aiVeAKF93gCWKd5kPpJTbq
         6VWjGzf90TGkfHIWV5s7+XASC5gA3WZfy1sghgeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.88
Date:   Sat, 14 Jan 2023 10:40:23 +0100
Message-Id: <1673689224253125@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.88 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 
 arch/parisc/include/uapi/asm/mman.h          |   27 ++---
 arch/parisc/kernel/sys_parisc.c              |   27 +++++
 arch/parisc/kernel/syscalls/syscall.tbl      |    2 
 arch/x86/include/asm/fpu/xstate.h            |    4 
 arch/x86/kernel/fpu/regset.c                 |    2 
 arch/x86/kernel/fpu/signal.c                 |    2 
 arch/x86/kernel/fpu/xstate.c                 |   41 +++++++-
 drivers/tty/serial/fsl_lpuart.c              |    2 
 drivers/tty/serial/serial_core.c             |    3 
 net/ipv4/inet_connection_sock.c              |   16 +++
 net/ipv4/tcp_ulp.c                           |    4 
 net/sched/sch_api.c                          |    5 +
 sound/core/control.c                         |   24 +++-
 sound/pci/hda/patch_hdmi.c                   |    1 
 sound/pci/hda/patch_realtek.c                |    1 
 tools/arch/parisc/include/uapi/asm/mman.h    |   12 +-
 tools/perf/bench/bench.h                     |   12 --
 tools/testing/selftests/vm/pkey-x86.h        |   12 ++
 tools/testing/selftests/vm/protection_keys.c |  131 ++++++++++++++++++++++++++-
 20 files changed, 273 insertions(+), 57 deletions(-)

Adrian Chan (1):
      ALSA: hda/hdmi: Add a HP device 0x8715 to force connect list

Chris Chiu (1):
      ALSA: hda - Enable headset mic on another Dell laptop with ALC3254

Clement Lecigne (1):
      ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF

Frederick Lawler (1):
      net: sched: disallow noqueue for qdisc classes

Greg Kroah-Hartman (1):
      Linux 5.15.88

Helge Deller (1):
      parisc: Align parisc MADV_XXX constants with all other architectures

Kyle Huey (6):
      x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()
      x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().
      x86/fpu: Add a pkru argument to copy_uabi_to_xstate()
      x86/fpu: Allow PKRU to be (once again) written by ptrace.
      x86/fpu: Emulate XRSTOR's behavior if the xfeatures PKRU bit is not set
      selftests/vm/pkeys: Add a regression test for setting PKRU through ptrace

Paolo Abeni (1):
      net/ulp: prevent ULP without clone op from entering the LISTEN status

Rasmus Villemoes (1):
      serial: fixup backport of "serial: Deassert Transmit Enable on probe in driver-specific way"

