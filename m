Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8B91CACBD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgEHMzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgEHMzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:55:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A40D124963;
        Fri,  8 May 2020 12:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942535;
        bh=wNcfpUZNdC8GZXWSQLabHe2MZTpS/tgVvFvWTu9TVew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlcwY52SnLHta4xKayzJVPPWL4mkp5B0EwYVSFCNWPMeYmQ3z1kHEyvpNGJU5HCra
         6TldMCOFZ4phyzvMc8WB/jS6FhDE7ZXJoSnM+0ckGUh5px1NZaJPnEsANsRtuoQKHX
         B46MqjADZK9+voCYMaEXHOk1EFPxXCdF+V5ZJ/XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 34/49] ftrace: Fix memory leak caused by not freeing entry in unregister_ftrace_direct()
Date:   Fri,  8 May 2020 14:35:51 +0200
Message-Id: <20200508123047.916721099@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 353da87921a5ec654e7e9024e083f099f1b33c97 ]

kmemleak reported the following:

unreferenced object 0xffff90d47127a920 (size 32):
  comm "modprobe", pid 1766, jiffies 4294792031 (age 162.568s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 22 01 00 00 00 00 ad de  ........".......
    00 78 12 a7 ff ff ff ff 00 00 b6 c0 ff ff ff ff  .x..............
  backtrace:
    [<00000000bb79e72e>] register_ftrace_direct+0xcb/0x3a0
    [<00000000295e4f79>] do_one_initcall+0x72/0x340
    [<00000000873ead18>] do_init_module+0x5a/0x220
    [<00000000974d9de5>] load_module+0x2235/0x2550
    [<0000000059c3d6ce>] __do_sys_finit_module+0xc0/0x120
    [<000000005a8611b4>] do_syscall_64+0x60/0x230
    [<00000000a0cdc49e>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

The entry used to save the direct descriptor needs to be freed
when unregistering.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fd81c7de77a70..63089c70adbb6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5155,6 +5155,7 @@ int unregister_ftrace_direct(unsigned long ip, unsigned long addr)
 			list_del_rcu(&direct->next);
 			synchronize_rcu_tasks();
 			kfree(direct);
+			kfree(entry);
 			ftrace_direct_func_count--;
 		}
 	}
-- 
2.20.1



