Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0586354E04C
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 13:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376977AbiFPLxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 07:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376975AbiFPLxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 07:53:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540D5583A4;
        Thu, 16 Jun 2022 04:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8D7FBCE2407;
        Thu, 16 Jun 2022 11:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65581C34114;
        Thu, 16 Jun 2022 11:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655380424;
        bh=AuK5tN4Nz/HN+y1lQRR9BgUZTDHwVlk/U5s01VCG3Rs=;
        h=From:To:Cc:Subject:Date:From;
        b=omHNLQo9Gv71GQxNAmoxSmgEtKSrdeiY8Q3xTuNS+pcJrzm9484MMvkH9ufEYk9wR
         JGId/R+aTM24UVzvSHhzTP/HgdRLqaxS6aYrWcJLTsj4UiaMqmtNoPJE2pPYY/Y0yT
         Dv89o59i0eWY4aNqkKUuJ5tyrV9ihfMb3sMX7sdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.199
Date:   Thu, 16 Jun 2022 13:53:40 +0200
Message-Id: <165538042197173@kroah.com>
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

I'm announcing the release of the 5.4.199 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
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
 arch/x86/include/asm/intel-family.h                             |    9 
 arch/x86/include/asm/msr-index.h                                |   25 +
 arch/x86/include/asm/nospec-branch.h                            |    2 
 arch/x86/kernel/cpu/bugs.c                                      |  235 ++++++++-
 arch/x86/kernel/cpu/common.c                                    |   52 +-
 arch/x86/kvm/vmx/vmx.c                                          |   75 +++
 arch/x86/kvm/vmx/vmx.h                                          |    3 
 arch/x86/kvm/x86.c                                              |    4 
 drivers/base/cpu.c                                              |    8 
 include/linux/cpu.h                                             |    4 
 16 files changed, 663 insertions(+), 41 deletions(-)

Gayatri Kammela (1):
      x86/cpu: Add another Alder Lake CPU to the Intel family

Greg Kroah-Hartman (1):
      Linux 5.4.199

Guenter Roeck (1):
      cpu/speculation: Add prototype for cpu_show_srbds()

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

Tony Luck (1):
      x86/cpu: Add Lakefield, Alder Lake and Rocket Lake models to the to Intel CPU family

Zhang Rui (1):
      x86/cpu: Add Jasper Lake to Intel family

