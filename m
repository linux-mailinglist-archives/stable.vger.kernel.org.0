Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4078B64EC34
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 14:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiLPNnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 08:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLPNnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 08:43:05 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396C5167E7;
        Fri, 16 Dec 2022 05:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1671198183; x=1702734183;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NBqV0S/NrkjAjfsbG61ehP8Z4OJavtUZCdDZHryrRTM=;
  b=fkZHRSxWv7XXPQBU8AZSBWuUPFcpMC8ExNX2jwBq+ks86M/RWD1i2rXi
   PshPFs+7/C3jIfeFRw3rZoNFcYq3g3odlYZ1KG+hqpeKor+laxIvBmsvM
   wZVJiMwwn8h13FDzosaLUtSWlHD1QIT6WYgVSo7bQgFo43+vgc5v7BOEZ
   4=;
X-IronPort-AV: E=Sophos;i="5.96,249,1665446400"; 
   d="scan'208";a="279704532"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 13:43:00 +0000
Received: from EX13D50EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id 0138541B19;
        Fri, 16 Dec 2022 13:42:58 +0000 (UTC)
Received: from EX19D028EUB002.ant.amazon.com (10.252.61.43) by
 EX13D50EUB003.ant.amazon.com (10.43.166.146) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 16 Dec 2022 13:42:57 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com
 (10.43.161.114) by EX19D028EUB002.ant.amazon.com (10.252.61.43) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Fri, 16 Dec
 2022 13:42:54 +0000
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     <stable@vger.kernel.org>
CC:     Pratyush Yadav <ptyadav@amazon.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <patches@lists.linux.dev>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Primiano Tucci <primiano@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4] tracing/ring-buffer: Only do full wait when cpu != RING_BUFFER_ALL_CPUS
Date:   Fri, 16 Dec 2022 14:42:41 +0100
Message-ID: <20221216134241.81381-1-ptyadav@amazon.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX19D028EUB002.ant.amazon.com (10.252.61.43)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

full_hit() directly uses cpu as an array index. Since
RING_BUFFER_ALL_CPUS == -1, calling full_hit() with cpu ==
RING_BUFFER_ALL_CPUS will cause an invalid memory access.

The upstream commit 42fb0a1e84ff ("tracing/ring-buffer: Have polling
block on watermark") already does this. This was missed when backporting
to v5.4.y.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: e65ac2bdda54 ("tracing/ring-buffer: Have polling block on watermark")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---

I am not familiar with this code. This was just pointed out by our
static analysis tool and I wrote a quick patch fixing this. Only
compile-tested.

 kernel/trace/ring_buffer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 176d858903bd..11e8189dd8ae 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -727,6 +727,7 @@ __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,

 	if (cpu == RING_BUFFER_ALL_CPUS) {
 		work = &buffer->irq_work;
+		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return -EINVAL;
--
2.38.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



