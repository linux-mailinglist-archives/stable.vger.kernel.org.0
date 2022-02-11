Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7122D4B2150
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343501AbiBKJPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:15:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiBKJPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:15:06 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6335102F
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644570905; x=1676106905;
  h=from:to:cc:subject:date:message-id;
  bh=BKVHAF735bhfs7XFdmtGhLRQqzuIbnzJOOj4npZ3P90=;
  b=ghzoOKBJSULAIcN0DcbhNe7eb1TTn5Uv/yZ+fykD8BxurKtRm2jLHVHd
   ichBb/rZx0cEjteE5YYaNK+lFe3Wp/BX+Qwzl9/umCY/tYhVPS8TPbN1Q
   vQje1JSEB7SUmhW0ZNHjax0KGXtO6tNoRKDNZP3Ky4fMBktWCpEJiOU8V
   Zlm2zAuygpBx4DzzLJ7IhrZCHSSURxf82rajcUJqE8MhAxqDGBOPzUYQM
   iKRwJsGYFQopDVLzLDgCUuPWF0NTLySFcCCe+g5kQ2J2Kw4qgic08OYUN
   h7QNF43qrxAW4LKIXzJk3DF3bw13zFVXVG5mBU4RcDScqPKz1fA6AWN0i
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="310432753"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="310432753"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 01:15:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="702037549"
Received: from srpawnik-desktop.iind.intel.com ([10.223.141.132])
  by orsmga005.jf.intel.com with ESMTP; 11 Feb 2022 01:15:03 -0800
From:   Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, srinivas.pandruvada@linux.intel.com
Cc:     sumeet.r.pawnikar@intel.com
Subject: [PATCH  0/4] Backport intel thermal driver patches to 5.15-stable
Date:   Fri, 11 Feb 2022 15:04:33 +0530
Message-Id: <20220211093437.8713-1-sumeet.r.pawnikar@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We need to apply 2685c77b80a8 ("thermal/drivers/int340x: Fix RFIM mailbox write commands")
to the 5.15-stable tree but it does not apply. This patch fix the write
operation for mailbox command for RFIM (cmd = 0x08) which is ignored.
This results in failing to store RFI restriction.

To apply this fix, we need to backport below set of three patches on
5.15-stable tree because this fix depended on these three patches.
Without these three dependent patches, we cannot directly apply
fix (fourth) patch.

Backport three patches:
 [1] c4fcf1ada4ae ("thermal/drivers/int340x: Improve the tcc offset saving for suspend/resume")
 [2] 994a04a20b03 ("thermal: int340x: Limit Kconfig to 64-bit")
 [3] aeb58c860dc5 ("thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM responses")

Fix RFIM patch:
 [4] 2685c77b80a8 ("thermal/drivers/int340x: Fix RFIM mailbox write commands")


*** BLURB HERE ***

Antoine Tenart (1):
  thermal/drivers/int340x: Improve the tcc offset saving for
    suspend/resume

Arnd Bergmann (1):
  thermal: int340x: Limit Kconfig to 64-bit

Srinivas Pandruvada (1):
  thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM
    responses

Sumeet Pawnikar (1):
  thermal/drivers/int340x: Fix RFIM mailbox write commands

 drivers/thermal/intel/int340x_thermal/Kconfig |   4 +-
 .../intel/int340x_thermal/int3401_thermal.c   |   8 +-
 .../processor_thermal_device.c                |  36 ++++--
 .../processor_thermal_device.h                |   4 +-
 .../processor_thermal_device_pci.c            |  18 ++-
 .../processor_thermal_device_pci_legacy.c     |   8 +-
 .../int340x_thermal/processor_thermal_mbox.c  | 104 +++++++++++-------
 .../int340x_thermal/processor_thermal_rfim.c  |  23 ++--
 8 files changed, 139 insertions(+), 66 deletions(-)

-- 
2.17.1

