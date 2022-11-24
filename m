Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622D2636EBE
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 01:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKXAL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 19:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKXAL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 19:11:28 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E33D2D740;
        Wed, 23 Nov 2022 16:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669248687; x=1700784687;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WEHHMHmAbC3y7/sIYj2mPueeyoULLmYszFzqAgbKTL4=;
  b=SyPHf/aPDryPRp2m5FtxXerfX69uaHrhYFL93nM4kcENS6MgPM4F9jk9
   IEeRi/1DdjxhOwVgExvGqMGXfYKAbwJTkk2ayUAzlWWb42KHcE0dPm1bq
   exqNn+lvpCtLktvnClXCHT7F5LjDJwhwYuL8D0tZXrZIne4FHAOGHqn03
   Q=;
X-IronPort-AV: E=Sophos;i="5.96,187,1665446400"; 
   d="scan'208";a="154218801"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 00:11:27 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id 5CE1D41A0F;
        Thu, 24 Nov 2022 00:11:27 +0000 (UTC)
Received: from EX19D002UWA003.ant.amazon.com (10.13.138.235) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 24 Nov 2022 00:11:25 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWA003.ant.amazon.com (10.13.138.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 24 Nov 2022 00:11:25 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Thu, 24 Nov 2022 00:11:25
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 74476ABFD; Thu, 24 Nov 2022 00:11:25 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <gregkh@linuxfoundation.org>, <shakeelb@google.com>,
        <viro@zeniv.linux.org.uk>, <bsegall@google.com>
CC:     <mdecandia@gmail.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.4 0/2] Fix epoll issue in 5.4 kernels
Date:   Thu, 24 Nov 2022 00:11:21 +0000
Message-ID: <20221124001123.3248571-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg
After upgrading to 5.4.211 we were started seeing some nodes getting
stuck in our Kubernetes cluster. All nodes are running this kernel
version. After taking a closer look it seems that runc was command getting
stuck. Looking at the stack it appears the thread is stuck in epoll wait for
sometime. 
[<0>] do_syscall_64+0x48/0xf0
[<0>] entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[<0>] ep_poll+0x48d/0x4e0
[<0>] do_epoll_wait+0xab/0xc0
[<0>] __x64_sys_epoll_pwait+0x4d/0xa0
[<0>] do_syscall_64+0x48/0xf0
[<0>] entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[<0>] futex_wait_queue_me+0xb6/0x110
[<0>] futex_wait+0xe2/0x260
[<0>] do_futex+0x372/0x4f0
[<0>] __x64_sys_futex+0x134/0x180
[<0>] do_syscall_64+0x48/0xf0
[<0>] entry_SYSCALL_64_after_hwframe+0x5c/0xc1

I noticed there are other discussions going on as well
regarding this.
https://lore.kernel.org/all/Y1pY2n6E1Xa58MXv@kroah.com/
Reverting the below patch does fix the issue:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=cf2db24ec4b8e9d399005ececd6f6336916ab6fc
We don't see this issue in latest upstream kernel or even latest 5.10
stable tree. Looking at the patches that went in for 5.10 stable there's
one that stands out that seems to be missing in 5.4.
289caf5d8f6c61c6d2b7fd752a7f483cd153f182 (epoll: check for events when removing
a timed out thread from the wait queue)

Backporting this patch to 5.4 we don't see the hangups anymore. Looks like
this patch fixes time out scenarios which might cause missed wake ups.
The other patch in the patch series also fixes a race and is needed for
the second patch to apply.

Roman Penyaev (1):
  epoll: call final ep_events_available() check under the lock

Soheil Hassas Yeganeh (1):
  epoll: check for events when removing a timed out thread from the wait
    queue

 fs/eventpoll.c | 68 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 27 deletions(-)

-- 
2.37.1

