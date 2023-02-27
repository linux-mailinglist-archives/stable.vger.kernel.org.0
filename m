Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD966A4CD6
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 22:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjB0VMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 16:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjB0VMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 16:12:45 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C937241E5
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 13:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677532358; x=1709068358;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UFNhFRZnWMdjwa3bw+dyQLTvq5EUsR4Zd+dZgC1Ij/w=;
  b=KZSIhfzAo6zvrP+YRsIDH+i+rL6j9WydZt+JnNUZEDm5Sqlw0sQFjnN6
   wDCb1C9YCKWrXH8Ib+jrnksIFYs3eHREPDjhezk9BorOJpuEWZY5CWP0r
   erf597AXhRzePIuBxpN+tY6smWJCSeFSYD/XQaRykaPDwZaCUQrMTHp4v
   Q=;
X-IronPort-AV: E=Sophos;i="5.98,220,1673913600"; 
   d="scan'208";a="187227750"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 20:55:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id 2F4E244757;
        Mon, 27 Feb 2023 20:55:42 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 27 Feb 2023 20:55:41 +0000
Received: from 88665a182662.ant.amazon.com.com (10.88.170.65) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 27 Feb 2023 20:55:39 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Subject: 6.1.y: Please backport 2ec33b44e0f7168ff2886520fec6fb62d03b5a3
Date:   Mon, 27 Feb 2023 12:55:31 -0800
Message-ID: <20230227205531.12036-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.88.170.65]
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I have received two reports [0][1] about WARN_ON_ONCE() in
sk_stream_kill_queues().

This is because the stable tree backported ca43ccf41224 ("dccp/tcp:
Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.") without
62ec33b44e0f ("net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from
sk_stream_kill_queues().").

The reports are about 6.1.14 and 5.15.95 though, 62ec33b44e0f can be
applied cleanly on 6.1.y only, and 4.14 ~ 5.10 will have the same
issue.

So, please backport 62ec33b44e0f to 6.1.y.  I will post patches for
other trees later.

[0]: https://lore.kernel.org/netdev/eb5ad452-0abe-8ea6-7e9e-1dd16852e8db@hauke-m.de/
[1]: https://bodhi.fedoraproject.org/updates/FEDORA-2023-3b67299c42

Thanks,
Kuniyuki
