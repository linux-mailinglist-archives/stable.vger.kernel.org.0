Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564A258FB52
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbiHKLbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiHKLbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99804240BC;
        Thu, 11 Aug 2022 04:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A6956121B;
        Thu, 11 Aug 2022 11:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23141C433D7;
        Thu, 11 Aug 2022 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660217445;
        bh=iq1LbBsqPywf1FdO/++3nTydnZz5AqPKup1Fx1y/v2w=;
        h=From:To:Cc:Subject:Date:From;
        b=g8obrzcU3FgnW/lYuRLxPK0cJiDyk/BDR+w0lHF72HIhul0/UI4K35VSaChUI+b5V
         XJzOpVWQkeGDUaMv10yv9K4SrxiTEZ05zC5WCSy1o0O+ns9J67etYW8pHV2P/s4Swa
         sAqTGrpj/v06jhJIiLX4KsB9qugUPnJIp5N2Rx5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.210
Date:   Thu, 11 Aug 2022 13:30:38 +0200
Message-Id: <1660217438248138@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.210 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst   |    8 ++
 Makefile                                        |    2 
 arch/x86/include/asm/cpufeatures.h              |    2 
 arch/x86/include/asm/msr-index.h                |    4 +
 arch/x86/include/asm/nospec-branch.h            |   19 +++++
 arch/x86/kernel/cpu/bugs.c                      |   61 +++++++++++++++++-
 arch/x86/kernel/cpu/common.c                    |   12 ++-
 arch/x86/kvm/vmx/vmenter.S                      |    1 
 drivers/acpi/apei/bert.c                        |   31 ++++++---
 drivers/acpi/video_detect.c                     |   55 ++++++++++------
 drivers/macintosh/adb.c                         |    2 
 drivers/media/v4l2-core/v4l2-mem2mem.c          |   60 +++++++++++++----
 drivers/thermal/of-thermal.c                    |    9 +-
 kernel/bpf/verifier.c                           |    1 
 tools/arch/x86/include/asm/cpufeatures.h        |    1 
 tools/include/uapi/linux/bpf.h                  |    3 
 tools/testing/selftests/bpf/test_align.c        |   41 ++++++------
 tools/testing/selftests/bpf/verifier/bounds.c   |    6 -
 tools/testing/selftests/bpf/verifier/sock.c     |   81 +++++++++++++++++++++++-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c |    9 +-
 virt/kvm/kvm_main.c                             |    5 +
 21 files changed, 328 insertions(+), 85 deletions(-)

Alexey Kardashevskiy (1):
      KVM: Don't null dereference ops->destroy

Chen-Yu Tsai (1):
      media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls

Daniel Sneddon (1):
      x86/speculation: Add RSB VM Exit protections

Greg Kroah-Hartman (1):
      Linux 5.4.210

Jakub Sitnicki (1):
      selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads

Jean-Philippe Brucker (1):
      selftests/bpf: Fix "dubious pointer arithmetic" test

John Fastabend (2):
      bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
      bpf: Test_verifier, #70 error message updates for 32-bit right shift

Ning Qiang (1):
      macintosh/adb: fix oob read in do_adb_query() function

Pawan Gupta (1):
      x86/speculation: Add LFENCE to RSB fill sequence

Raghavendra Rao Ananta (1):
      selftests: KVM: Handle compiler optimizations in ucall

Stanislav Fomichev (1):
      selftests/bpf: Fix test_align verifier log patterns

Subbaraman Narayanamurthy (1):
      thermal: Fix NULL pointer dereferences in of_thermal_ functions

Tony Luck (1):
      ACPI: APEI: Better fix to avoid spamming the console with old error logs

Werner Sembach (2):
      ACPI: video: Force backlight native for some TongFang devices
      ACPI: video: Shortening quirk list by identifying Clevo by board_name only

