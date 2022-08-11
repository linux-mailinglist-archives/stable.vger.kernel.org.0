Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A8E58FB5D
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbiHKLcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiHKLbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:31:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4F096741;
        Thu, 11 Aug 2022 04:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D4F1B82060;
        Thu, 11 Aug 2022 11:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4830C433C1;
        Thu, 11 Aug 2022 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660217482;
        bh=5KoZw/CaGPXDco/fS5y7xe/u8MfH8yeKxMAcFgJVXoI=;
        h=From:To:Cc:Subject:Date:From;
        b=mOIOtJHpjx2ZkPdWd8U1fpM/yWJBbtoYkX5nlN8uvKcbJeoidibEacVtqVth/k455
         9beQP0txxHWguMWFjcnVg2AeU5KNivynDYZJhgw06TxmgQL3FZ9rItjSJbMQYASrQt
         A3QjbMv4tlddVtRPW7BmhVVJ5L3uKS4Q8qkNLx6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.60
Date:   Thu, 11 Aug 2022 13:31:07 +0200
Message-Id: <166021746711648@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

I'm announcing the release of the 5.15.60 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst                 |    8 
 Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml |    1 
 Makefile                                                      |    2 
 arch/arm64/crypto/poly1305-glue.c                             |    2 
 arch/arm64/include/asm/kernel-pgtable.h                       |    4 
 arch/arm64/kernel/head.S                                      |    2 
 arch/x86/Kconfig                                              |    8 
 arch/x86/include/asm/cpufeatures.h                            |    2 
 arch/x86/include/asm/kvm_host.h                               |    3 
 arch/x86/include/asm/msr-index.h                              |    4 
 arch/x86/include/asm/nospec-branch.h                          |   21 ++
 arch/x86/kernel/cpu/bugs.c                                    |   86 +++++++---
 arch/x86/kernel/cpu/common.c                                  |   12 +
 arch/x86/kvm/svm/sev.c                                        |    4 
 arch/x86/kvm/svm/svm.c                                        |    2 
 arch/x86/kvm/vmx/vmenter.S                                    |    8 
 arch/x86/kvm/vmx/vmx.c                                        |    1 
 arch/x86/kvm/x86.c                                            |   48 ++++-
 arch/x86/kvm/xen.h                                            |    6 
 block/blk-ioc.c                                               |    1 
 block/ioprio.c                                                |    4 
 drivers/acpi/apei/bert.c                                      |   31 ++-
 drivers/acpi/video_detect.c                                   |   55 ++++--
 drivers/bluetooth/btbcm.c                                     |    2 
 drivers/bluetooth/btusb.c                                     |   15 +
 drivers/bluetooth/hci_bcm.c                                   |    2 
 drivers/macintosh/adb.c                                       |    2 
 fs/btrfs/block-group.h                                        |    1 
 fs/btrfs/extent-tree.c                                        |   20 ++
 fs/btrfs/extent_io.c                                          |    3 
 fs/btrfs/inode.c                                              |    2 
 fs/btrfs/zoned.c                                              |   27 +++
 fs/btrfs/zoned.h                                              |    5 
 include/linux/ioprio.h                                        |    2 
 tools/arch/x86/include/asm/cpufeatures.h                      |    1 
 tools/arch/x86/include/asm/msr-index.h                        |    4 
 tools/include/uapi/linux/bpf.h                                |    3 
 tools/kvm/kvm_stat/kvm_stat                                   |    3 
 tools/testing/selftests/bpf/prog_tests/sock_fields.c          |   58 ++++--
 tools/testing/selftests/bpf/progs/test_sock_fields.c          |   45 +++++
 tools/testing/selftests/bpf/verifier/sock.c                   |   81 +++++++++
 tools/testing/selftests/kvm/lib/aarch64/ucall.c               |    9 -
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c             |   10 -
 tools/vm/slabinfo.c                                           |   26 ++-
 44 files changed, 514 insertions(+), 122 deletions(-)

Aaron Ma (1):
      Bluetooth: btusb: Add support of IMC Networks PID 0x3568

Ahmad Fatoum (2):
      Bluetooth: hci_bcm: Add BCM4349B1 variant
      dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT binding

Ben Hutchings (1):
      x86/speculation: Make all RETbleed mitigations 64-bit only

Daniel Sneddon (1):
      x86/speculation: Add RSB VM Exit protections

Dmitry Klochkov (1):
      tools/kvm_stat: fix display of error when multiple processes are found

GUO Zihua (1):
      crypto: arm64/poly1305 - fix a read out-of-bound

Greg Kroah-Hartman (1):
      Linux 5.15.60

Hakan Jansson (1):
      Bluetooth: hci_bcm: Add DT compatible for CYW55572

Hilda Wu (5):
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04CA:0x4007
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04C5:0x1675
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x0CB8:0xC558
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3587
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3586

Jakub Sitnicki (2):
      selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
      selftests/bpf: Check dst_port only on the client socket

Jan Kara (1):
      block: fix default IO priority handling again

Mingwei Zhang (1):
      KVM: x86/svm: add __GFP_ACCOUNT to __sev_dbg_{en,de}crypt_user()

Naohiro Aota (2):
      btrfs: zoned: prevent allocation from previous data relocation BG
      btrfs: zoned: fix critical section of relocation inode writeback

Ning Qiang (1):
      macintosh/adb: fix oob read in do_adb_query() function

Paolo Bonzini (2):
      KVM: x86: do not report a vCPU as preempted outside instruction boundaries
      KVM: x86: do not set st->preempted when going back to user space

Pawan Gupta (1):
      x86/speculation: Add LFENCE to RSB fill sequence

Peter Collingbourne (1):
      arm64: set UXN on swapper page tables

Raghavendra Rao Ananta (1):
      selftests: KVM: Handle compiler optimizations in ucall

Stéphane Graber (1):
      tools/vm/slabinfo: Handle files in debugfs

Tony Luck (1):
      ACPI: APEI: Better fix to avoid spamming the console with old error logs

Vitaly Kuznetsov (1):
      KVM: selftests: Make hyperv_clock selftest more stable

Werner Sembach (2):
      ACPI: video: Force backlight native for some TongFang devices
      ACPI: video: Shortening quirk list by identifying Clevo by board_name only

