Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BA16452C6
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 04:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLGD5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 22:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGD5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 22:57:08 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647F55217A
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 19:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670385427; x=1701921427;
  h=from:to:cc:subject:date:message-id;
  bh=bYpSzbxXVlu2TVbGO/NK0IPz343H/Q4xYjXc3dj+6F0=;
  b=Pq6ypKC+OaUap6KcN1oDVxZADlLOotPYNwtoEQxTiPY+Enrs73EhB07W
   AoaRmu2aSwawl7mY48vsYwXu2SLD/J3vFrHt+mIXZ0XA4P65czFgDYTky
   gwQLlvz67+ZYC2WugAlP4NSNH0vqFc304Us7w1edrFoCL1rimMXm/BadP
   b0NIavsO9eizgDMoN6aaTlutq7oryxRr8peIwGRu/WDxB/H5I//UFNuV1
   GiNnOkzoarelSixkY0pG3iCd5B0GcYO1CfMtf7KfjJFSK3yIlAdy50ECA
   6XONuyXWgJUREvaCjUDKT/M7seV+77BYZ0kZyK0HdpJUyvLa28nOwaS+p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="378963527"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="378963527"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 19:57:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="646457288"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="646457288"
Received: from kkgame-x299-aorus-gaming-3-pro.itwn.intel.com ([10.5.253.159])
  by orsmga002.jf.intel.com with ESMTP; 06 Dec 2022 19:57:06 -0800
From:   Kane Chen <kane.chen@intel.com>
To:     stable@vger.kernel.org
Cc:     kane.chen@intel.com
Subject: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
Date:   Wed,  7 Dec 2022 11:57:22 +0800
Message-Id: <20221207035722.15749-1-kane.chen@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While runnings s0ix cycling test based on rtc alarm wakeup on ADL-P devices,
We found the data from CMOS_READ is not reasonable and causes RTC wake up fail.

With the below changes, we don't see unreasonable data from cmos and issue is gone.

cd17420: rtc: cmos: avoid UIP when writing alarm time
cdedc45: rtc: cmos: avoid UIP when reading alarm time
ec5895c: rtc: mc146818-lib: extract mc146818_avoid_UIP
ea6fa49: rtc: mc146818-lib: fix RTC presence check
13be2ef: rtc: cmos: Disable irq around direct invocation of cmos_interrupt()
0dd8d6c: rtc: Check return value from mc146818_get_time()
e1aba37: rtc: cmos: remove stale REVISIT comments
6950d04: rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard IRQ
d35786b: rtc: mc146818-lib: change return values of mc146818_get_time()
ebb22a0: rtc: mc146818: Dont test for bit 0-5 in Register D
211e5db: rtc: mc146818: Detect and handle broken RTCs
dcf257e: rtc: mc146818: Reduce spinlock section in mc146818_set_time()
05a0302: rtc: mc146818: Prevent reading garbage


All of the above patches are landed on 6.0.11 stable kernel
I'd like pick the above patches back to 5.10 longterm kernel
Thanks


-- 
2.17.1

