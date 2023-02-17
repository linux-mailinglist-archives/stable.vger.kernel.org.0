Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC97E69B55D
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 23:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBQWR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 17:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBQWR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 17:17:29 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536F75A3B6;
        Fri, 17 Feb 2023 14:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1676672248; x=1708208248;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ERQol1L+FhZXlEPdKYpI7+OtNPCVRnj9iAT1/PZiMj8=;
  b=IOAIwuXfsKuJFKDUgarosZUYQH6sx8CqCFvGyilW2lWdWOm7P0Tlvmje
   xEc1cSF1NAFgK9nUhZgJjIAYUgfmtEWlx3IogSikvq8s9S0BXTQyHsyc2
   6p6FdnhohdqpxU00thP9oiTy0Xo4PMAdC8s+MRODPD6iQIIhIYNU5K77I
   4=;
X-IronPort-AV: E=Sophos;i="5.97,306,1669075200"; 
   d="scan'208";a="183147594"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 22:17:26 +0000
Received: from EX13D43EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id 1F762C0632;
        Fri, 17 Feb 2023 22:17:25 +0000 (UTC)
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX13D43EUB003.ant.amazon.com (10.43.166.195) with Microsoft SMTP Server (TLS)
 id 15.0.1497.46; Fri, 17 Feb 2023 22:17:23 +0000
Received: from uc3ecf78c6baf56.ant.amazon.com (10.88.197.97) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Fri, 17 Feb 2023 22:17:22 +0000
From:   Andrew Paniakin <apanyaki@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <luizcap@amazon.com>, <keescook@chromium.org>, <shuah@kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <apanyaki@amazon.com>
Subject: [5.15] Please apply 'selftest/lkdtm: Skip stack-entropy test if lkdtm is not available'
Date:   Fri, 17 Feb 2023 14:17:05 -0800
Message-ID: <20230217221705.2525177-1-apanyaki@amazon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.88.197.97]
X-ClientProxiedBy: EX19D039UWB001.ant.amazon.com (10.13.138.119) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 90091c367e74d5b58d9ebe979cc363f7468f58d3 upstream.

This patch fixes the stack-entropy.sh test to exit gracefully when the LKDTM is
not available. Test will hang otherwise as reported in [1].

Applicability of this fix to other LTS kernels:
- 4.14: No lkdtm selftest
- 4.19: No lkdtm selftest
- 5.4:  No lkdtm selftests
- 5.10: Inital selftest version introduced in 46d1a0f03d661 ("selftests/lkdtm:
  Add tests for LKDTM targets") is a single script which has the LKDTM
  availability check
- 6.1: Fix applied

This patch applies cleanly to stable-5.15 tree. Updated test was executed in
Qemu VM with different kernels:
- CONFIG_LKDTM not enabled. Test finished with status SKIP.
- CONFIG_LKDTM enabled. Test failed (but not hanged) with error 'Stack entropy
  is low'.
- CONFIG_LKDTM enabled and randomize_kstack_offset=on boot argument provided.
  Test succeed.

[1] https://lore.kernel.org/lkml/2836f48a-d4e2-7f00-f06c-9f556fbd6332@linuxfoundation.org
