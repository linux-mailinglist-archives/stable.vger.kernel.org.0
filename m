Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E335E6D0266
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 13:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjC3LCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 07:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjC3LCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 07:02:11 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BAC9015;
        Thu, 30 Mar 2023 04:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680174129; x=1711710129;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hoMNmsGYcORYwwc5pC5xJFyZ3P/r29Qsygz770Gm+NY=;
  b=g1uSogY8AyBcoWNa4yUcQTh5KZk+CygiWcPkQ1fk0kRJjg0BWsSAVVcG
   aXan0UoZMKGC/k/zKwO1OvpIObUsnDzXWDzNIqDk5eugFAgscbAteLEQ5
   u5TPu19oOZj5gUSBjQQQ1ASTnm0lgLXYpeIC9BM27qHIhGvGBb+PwqQ/Q
   s=;
X-IronPort-AV: E=Sophos;i="5.98,303,1673913600"; 
   d="scan'208";a="308741436"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 11:02:07 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com (Postfix) with ESMTPS id 811278831F;
        Thu, 30 Mar 2023 11:02:05 +0000 (UTC)
Received: from EX19D002UWA002.ant.amazon.com (10.13.138.246) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Thu, 30 Mar 2023 11:01:59 +0000
Received: from EX19MTAUEA001.ant.amazon.com (10.252.134.203) by
 EX19D002UWA002.ant.amazon.com (10.13.138.246) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 30 Mar 2023 11:01:59 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.252.134.102) with Microsoft SMTP
 Server id 15.2.1118.22 via Frontend Transport; Thu, 30 Mar 2023 11:01:59
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 0C696223C; Thu, 30 Mar 2023 11:01:58 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <gregkh@linuxfoundation.org>, <shaoyi@amazon.com>
CC:     <stable@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shuah@kernel.org>,
        <davem@davemloft.net>, Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.4] selftests: Fix the executable permissions for fib_tests.sh
Date:   Thu, 30 Mar 2023 11:01:47 +0000
Message-ID: <20230330110147.32052-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-10.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 04a331c9dd66 reverted change 2537b637eac0 (ipv4: Fix
incorrect route flushing when source address is deleted) that
added the fib_tests.sh file back with wrong permissions.
Fix that in this commit.

Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 tools/testing/selftests/net/fib_tests.sh | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/net/fib_tests.sh

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
old mode 100644
new mode 100755
-- 
2.39.2

