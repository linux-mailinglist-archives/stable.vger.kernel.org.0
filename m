Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C9D36EE77
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhD2RAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:00:48 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:19104 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbhD2RAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619715601; x=1651251601;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pwWACMutRRf/vENNfq16JaVK0svpWCRPXO5OfA+s6Ls=;
  b=ULKiEI3gER9wBnWZcA93JaOIxE6+p3AnPRA286i15oLh9MxcTREmQBD/
   hpQo33c5Lb17nj0uZTGjHtvHMbusZcZYVWKqJhez0cdZF7cP1pXhMIOge
   tqWoFyMwLYkSOoe2dQ7gympcpwT/3nvloctILMEPgNy2FcxchlAKkGxjj
   g=;
X-IronPort-AV: E=Sophos;i="5.82,259,1613433600"; 
   d="scan'208";a="106325076"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 29 Apr 2021 16:59:53 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id A676DA2019;
        Thu, 29 Apr 2021 16:59:52 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.85) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 16:59:47 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Mathias Krause <minipli@grsecurity.net>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        stable <stable@vger.kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v1 0/1] Nitro Enclaves kernel driver issue fix
Date:   Thu, 29 Apr 2021 19:59:40 +0300
Message-ID: <20210429165941.27020-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D11UWC003.ant.amazon.com (10.43.162.162) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An issue was found in the Nitro Enclaves kernel driver codebase [1] included in
the v5.10 upstream Linux kernel. The fix for it has been tested on the AWS side.
The issue does not break the isolation or security of what is running inside the
enclave. Nitro Enclaves already assumes that the instance running the Nitro
Enclaves kernel driver is untrusted.

We would like to thank Mathias Krause from Open Source Security, Inc. for
reporting and providing a fix for this issue directly to AWS.

The patch will be merged into the latest upstream Linux kernel release and into
the v5.10+ stable kernel releases.

Thanks,
Andra

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/virt/nitro_enclaves

Mathias Krause (1):
  nitro_enclaves: Fix stale file descriptors on failed usercopy

 drivers/virt/nitro_enclaves/ne_misc_dev.c | 43 +++++++++--------------
 1 file changed, 17 insertions(+), 26 deletions(-)

-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

