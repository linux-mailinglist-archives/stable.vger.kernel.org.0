Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4530C24B86E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgHTLUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730553AbgHTKHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:07:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD5920724;
        Thu, 20 Aug 2020 10:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918062;
        bh=5Cxc/JTD2AWvCQ8Ig0+Bvy3TqT/qgwnJhSi5I7O7hfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cv/kuhTCA1w9RTEfhpy4XtYqIvHVQU9ZTknWLtJfvevKbE9Mv4HFn36usfImEJcdn
         6n/A5REfhXxSyaCRls0IX9xUmi3WUgD9k7W2yDg4AL3SSVa3ASbk6ckAd0+IXeQ+H2
         0f8YA+3O/9FBtc3fip+gy5jlXNvKdA7P6HKoHhas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 039/228] selftests/net: relax cpu affinity requirement in msg_zerocopy test
Date:   Thu, 20 Aug 2020 11:20:14 +0200
Message-Id: <20200820091609.491060451@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 16f6458f2478b55e2b628797bc81a4455045c74e ]

The msg_zerocopy test pins the sender and receiver threads to separate
cores to reduce variance between runs.

But it hardcodes the cores and skips core 0, so it fails on machines
with the selected cores offline, or simply fewer cores.

The test mainly gives code coverage in automated runs. The throughput
of zerocopy ('-z') and non-zerocopy runs is logged for manual
inspection.

Continue even when sched_setaffinity fails. Just log to warn anyone
interpreting the data.

Fixes: 07b65c5b31ce ("test: add msg_zerocopy test")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/msg_zerocopy.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/msg_zerocopy.c
+++ b/tools/testing/selftests/net/msg_zerocopy.c
@@ -121,9 +121,8 @@ static int do_setcpu(int cpu)
 	CPU_ZERO(&mask);
 	CPU_SET(cpu, &mask);
 	if (sched_setaffinity(0, sizeof(mask), &mask))
-		error(1, 0, "setaffinity %d", cpu);
-
-	if (cfg_verbose)
+		fprintf(stderr, "cpu: unable to pin, may increase variance.\n");
+	else if (cfg_verbose)
 		fprintf(stderr, "cpu: %u\n", cpu);
 
 	return 0;


