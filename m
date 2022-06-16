Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDDF54E05D
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 13:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiFPLyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 07:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377018AbiFPLyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 07:54:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B955EDCB;
        Thu, 16 Jun 2022 04:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC771B823A1;
        Thu, 16 Jun 2022 11:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CECC3411B;
        Thu, 16 Jun 2022 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655380440;
        bh=/XPhCetjBiJnoxOykPQjWzgHuLVj6UzcwvNHuoarhK8=;
        h=From:To:Cc:Subject:Date:From;
        b=MOpkTvLp/xAmv0yid9WWCLeQLyOr2YrjGVleEkTmJu1LdHxFrcrqYP6v2TggtHizV
         C0fB/CG6xb/JDnFmWc1Ytr+3PLKit8WMrYVBTWtCDSNu2Y6w6ZCm+jqcjSEjpRR/hW
         eaXwL3PBfApanMBtBdjAxRnp4tq4EqA1kgTUhyF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.48
Date:   Thu, 16 Jun 2022 13:53:53 +0200
Message-Id: <1655380434166170@kroah.com>
X-Mailer: git-send-email 2.36.1
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

I'm announcing the release of the 5.15.48 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu              |    1 
 Documentation/admin-guide/hw-vuln/index.rst                     |    1 
 Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst |  246 ++++++++++
 Documentation/admin-guide/kernel-parameters.txt                 |   36 +
 Makefile                                                        |    2 
 arch/x86/include/asm/cpufeatures.h                              |    1 
 arch/x86/include/asm/msr-index.h                                |   25 +
 arch/x86/include/asm/nospec-branch.h                            |    2 
 arch/x86/kernel/cpu/bugs.c                                      |  235 ++++++++-
 arch/x86/kernel/cpu/common.c                                    |   52 +-
 arch/x86/kvm/vmx/vmx.c                                          |   72 ++
 arch/x86/kvm/vmx/vmx.h                                          |    2 
 arch/x86/kvm/x86.c                                              |    3 
 drivers/base/cpu.c                                              |    8 
 include/linux/cpu.h                                             |    3 
 tools/arch/x86/include/asm/cpufeatures.h                        |    1 
 tools/arch/x86/include/asm/msr-index.h                          |   25 +
 17 files changed, 675 insertions(+), 40 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.15.48

Josh Poimboeuf (1):
      x86/speculation/mmio: Print SMT warning

Pawan Gupta (10):
      Documentation: Add documentation for Processor MMIO Stale Data
      x86/speculation/mmio: Enumerate Processor MMIO Stale Data bug
      x86/speculation: Add a common function for MD_CLEAR mitigation update
      x86/speculation/mmio: Add mitigation for Processor MMIO Stale Data
      x86/bugs: Group MDS, TAA & Processor MMIO Stale Data mitigations
      x86/speculation/mmio: Enable CPU Fill buffer clearing on idle
      x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data
      x86/speculation/srbds: Update SRBDS mitigation selection
      x86/speculation/mmio: Reuse SRBDS mitigation for SBDS
      KVM: x86/speculation: Disable Fill buffer clear within guests

