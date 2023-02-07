Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2054E68CAFE
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 01:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBGAS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 19:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBGAS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 19:18:28 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942E72F793
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 16:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675729107; x=1707265107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TG7FAlKwGhTnH4xTRczXDRPIM3IapIN06/D8DB0+icc=;
  b=pD/6dXaKVGdy2MfARMZqE+VSRV0jd85s2KYBfIPlmTiLWrhjpU77NYx4
   eafyo2rvdk8+6lu0SnvtyO4INzL7ZtpAkSNs9xjU6J9XD+DnC6rRyI3mb
   RRt1dg+nmHnWxYRKeXLEY/Vt/XEAZnC/y57LNaP7TcrNaBjSd/m2fut4W
   8=;
X-IronPort-AV: E=Sophos;i="5.97,276,1669075200"; 
   d="scan'208";a="295983268"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 00:18:25 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 8947CA32C5;
        Tue,  7 Feb 2023 00:18:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 00:18:21 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Tue, 7 Feb 2023 00:18:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <alexs@kernel.org>, <jpoimboe@redhat.com>, <korantwork@gmail.com>,
        <peterz@infradead.org>, <stable@vger.kernel.org>,
        <tglx@linutronix.de>, <x86@kernel.org>, <kuniyu@amazon.com>
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
Date:   Mon, 6 Feb 2023 16:18:10 -0800
Message-ID: <20230207001810.76336-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Y+DK4fP/u7iYi7Kt@kroah.com>
References: <Y+DK4fP/u7iYi7Kt@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D43UWA004.ant.amazon.com (10.43.160.108) To
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

From:   Greg KH <gregkh@linuxfoundation.org>
Date:   Mon, 6 Feb 2023 10:39:45 +0100
> On Mon, Feb 06, 2023 at 05:22:54PM +0800, Xinghui Li wrote:
> > Greg KH <gregkh@linuxfoundation.org> 于2023年2月6日周一 13:40写道：
> > 
> > > If you rely on the 5.4.y kernel tree, and you need this speculation
> > > fixes and feel this is a real problem, please provide some backported
> > > patches to resolve the problem.
> > >
> > > It's been reported many times in the past, but no one seems to actually
> > > want to fix this bad enough to send in a patch :(
> > >
> > > Usually people just move to a newer kernel, what is preventing you from
> > > doing that right now?
> > >
> > > thanks,
> > >
> > > greg k-h
> > Thanks for your reply~ I am sorry about reporting the known Issue.
> > I am trying to fix this issue right now. And I met the CFA issue, so I
> > just want to discuss it with the community.
> 
> Is this an actual real problem that you can detect with testing?  Or is
> it just a warning message in the build?

I've just received a related report from a customer and I found the
same commit was the first bad one while investigating.  I've attached
a simple repro below.

After 8afd1c7da2b0 ("x86/speculation: Change FILL_RETURN_BUFFER to
work with objtool"), calling stack_trace_save_tsk_reliable() from
the kernel module below fails with -EINVAL if CONFIG_UNWINDER_ORC=y
and CONFIG_RETPOLINE=y.

I confirmed that this issue does not happen on 5.10 and 5.15 at
least (and told the customer to use either).

Interestingly, after the commit, stack_trace_save_tsk_reliable()
fails but seems to fill the buffer with the correct stack trace.

---8<---
#include <linux/module.h>
#include <linux/kallsyms.h>

typedef int (*func_t)(struct task_struct *tsk,
		      unsigned long *store, unsigned int size);

static __init int buggy_orc_init(void)
{
	unsigned long store[32] = {0};
	func_t func;
	int ret, i;

	func = (func_t)kallsyms_lookup_name("stack_trace_save_tsk_reliable");
	if (!func)
		return -ENOENT;

	ret = func(current, store, ARRAY_SIZE(store));

	for (i = 0; i < ARRAY_SIZE(store); i++)
		printk(KERN_ERR "%px: %pS\n", (void *)store[i], (void *)store[i]);

	return ret > 0 ? 0 : ret;
}

module_init(buggy_orc_init);

MODULE_LICENSE("GPL");
---8<---

---8<---
# insmod buggy_orc.ko
[    8.576683] buggy_orc: loading out-of-tree module taints kernel.
[    8.578414] ffffffff810d1538: stack_trace_save_tsk_reliable+0x78/0xc0
[    8.578414] ffffffffc000405c: buggy_orc_init+0x5c/0x1000 [buggy_orc]
[    8.579066] ffffffff81000b56: do_one_initcall+0x46/0x1f0
[    8.579066] ffffffff810f005c: do_init_module+0x4c/0x240
[    8.579066] ffffffff810f2cbf: __do_sys_finit_module+0xbf/0xe0
[    8.580379] ffffffff81002198: do_syscall_64+0x48/0x110
[    8.580379] ffffffff81c00094: entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[    8.581328] 0000000000000000: 0x0
[    8.581328] 0000000000000000: 0x0
[    8.581328] 0000000000000000: 0x0
[    8.582145] 0000000000000000: 0x0
[    8.582145] 0000000000000000: 0x0
[    8.582145] 0000000000000000: 0x0
[    8.582145] 0000000000000000: 0x0
[    8.583229] 0000000000000000: 0x0
[    8.583229] 0000000000000000: 0x0
[    8.583229] 0000000000000000: 0x0
[    8.584046] 0000000000000000: 0x0
[    8.584046] 0000000000000000: 0x0
[    8.584046] 0000000000000000: 0x0
[    8.584046] 0000000000000000: 0x0
[    8.585130] 0000000000000000: 0x0
[    8.585130] 0000000000000000: 0x0
[    8.585130] 0000000000000000: 0x0
[    8.585130] 0000000000000000: 0x0
[    8.586221] 0000000000000000: 0x0
[    8.586221] 0000000000000000: 0x0
[    8.586221] 0000000000000000: 0x0
[    8.587038] 0000000000000000: 0x0
[    8.587038] 0000000000000000: 0x0
[    8.587038] 0000000000000000: 0x0
[    8.587038] 0000000000000000: 0x0
insmod: ERROR: could not insert module buggy_orc.ko: Invalid parameters
---8<---

Thank you,
Kuniyuki

> 
> > We keep staying in v5.4 because we developed the product base on v5.4
> > 3 years ago.
> > So it is unstable and difficult to update the kernel version.
> 
> That is very odd, why is it hard to update to a new kernel?  What
> happens if 5.4 stops being maintained tomorrow, what are your plans to
> move to a more modern kernel?  Being stuck with an old kernel version
> with no plans to move does not seem like a wise business decision:(
> 
> > I will try to find out a way to fix this issue.
> 
> Great, and we will be glad to review patches.
> 
> thanks,
> 
> greg k-h
