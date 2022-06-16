Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51854E010
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 13:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiFPLgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 07:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiFPLgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 07:36:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35C95E75A;
        Thu, 16 Jun 2022 04:36:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87E8A619D0;
        Thu, 16 Jun 2022 11:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1DAC34114;
        Thu, 16 Jun 2022 11:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655379364;
        bh=WTyrk1KBzECI1U851OAtJ6a7eMlqKBhrBy1AsQzgsMs=;
        h=From:To:Cc:Subject:Date:From;
        b=TUrhvb6xw27w/HGWA030YcDF3Xj8OXijbVb0CXSyxM5Q+DADQ2FqPOO1eMfTKFPRl
         uEgKookUghgJ9BlZd6OD5usObt6r3HXAKNkPyEagBP6CheQOfmWo7sAkTf8gSr0xdO
         cWmkzJy2NU0yvbcTDt1MUDGOXnHI4F894G/WjRgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.319
Date:   Thu, 16 Jun 2022 13:36:01 +0200
Message-Id: <165537936119752@kroah.com>
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

I'm announcing the release of the 4.9.319 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu  |    1 
 Documentation/hw-vuln/index.rst                     |    1 
 Documentation/hw-vuln/processor_mmio_stale_data.rst |  246 ++++++++++++++++++++
 Documentation/kernel-parameters.txt                 |   36 ++
 Makefile                                            |    2 
 arch/x86/include/asm/cpufeatures.h                  |    1 
 arch/x86/include/asm/intel-family.h                 |   25 ++
 arch/x86/include/asm/msr-index.h                    |   25 ++
 arch/x86/include/asm/nospec-branch.h                |    2 
 arch/x86/kernel/cpu/bugs.c                          |  235 ++++++++++++++++---
 arch/x86/kernel/cpu/common.c                        |   52 +++-
 arch/x86/kvm/vmx.c                                  |   77 ++++++
 arch/x86/kvm/x86.c                                  |    4 
 drivers/base/cpu.c                                  |    8 
 include/linux/cpu.h                                 |    4 
 15 files changed, 678 insertions(+), 41 deletions(-)

Gayatri Kammela (2):
      x86/cpu: Add Elkhart Lake to Intel family
      x86/cpu: Add another Alder Lake CPU to the Intel family

Greg Kroah-Hartman (1):
      Linux 4.9.319

Guenter Roeck (1):
      cpu/speculation: Add prototype for cpu_show_srbds()

Josh Poimboeuf (1):
      x86/speculation/mmio: Print SMT warning

Kan Liang (2):
      x86/CPU: Add more Icelake model numbers
      x86/cpu: Add Comet Lake to the Intel CPU models header

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

Rajneesh Bhardwaj (2):
      x86/cpu: Add Cannonlake to Intel family
      x86/CPU: Add Icelake model number

Tony Luck (1):
      x86/cpu: Add Lakefield, Alder Lake and Rocket Lake models to the to Intel CPU family

Zhang Rui (1):
      x86/cpu: Add Jasper Lake to Intel family

