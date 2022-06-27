Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2738E55C525
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbiF0Lo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbiF0Lmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D34DF70;
        Mon, 27 Jun 2022 04:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25703B8111C;
        Mon, 27 Jun 2022 11:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93445C3411D;
        Mon, 27 Jun 2022 11:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329799;
        bh=P6fzE7iXoVUT+eQqAEMea/LZbGUVwRj9OH5L+AQ5ztY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xT8GmHWWsfSXu9okzK1oqRR2U8Zg57WmFp2WDIGyUPnRFHddhUIsDTbuaxu4QwckJ
         3mlwwOsRjaiZxBfzAl6rMEyVVZY+u/Bk7WuRknDFOxODHPyUqqFsUn+iqGmJEgvGZR
         k/VPg89yrXNObuBmLiSiot0GV9nm5Zkb6Pm9Jw8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sumit Dubey2 <Sumit.Dubey2@ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 117/135] powerpc: Enable execve syscall exit tracepoint
Date:   Mon, 27 Jun 2022 13:22:04 +0200
Message-Id: <20220627111941.549090742@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit ec6d0dde71d760aa60316f8d1c9a1b0d99213529 upstream.

On execve[at], we are zero'ing out most of the thread register state
including gpr[0], which contains the syscall number. Due to this, we
fail to trigger the syscall exit tracepoint properly. Fix this by
retaining gpr[0] in the thread register state.

Before this patch:
  # tail /sys/kernel/debug/tracing/trace
	       cat-123     [000] .....    61.449351: sys_execve(filename:
  7fffa6b23448, argv: 7fffa6b233e0, envp: 7fffa6b233f8)
	       cat-124     [000] .....    62.428481: sys_execve(filename:
  7fffa6b23448, argv: 7fffa6b233e0, envp: 7fffa6b233f8)
	      echo-125     [000] .....    65.813702: sys_execve(filename:
  7fffa6b23378, argv: 7fffa6b233a0, envp: 7fffa6b233b0)
	      echo-125     [000] .....    65.822214: sys_execveat(fd: 0,
  filename: 1009ac48, argv: 7ffff65d0c98, envp: 7ffff65d0ca8, flags: 0)

After this patch:
  # tail /sys/kernel/debug/tracing/trace
	       cat-127     [000] .....   100.416262: sys_execve(filename:
  7fffa41b3448, argv: 7fffa41b33e0, envp: 7fffa41b33f8)
	       cat-127     [000] .....   100.418203: sys_execve -> 0x0
	      echo-128     [000] .....   103.873968: sys_execve(filename:
  7fffa41b3378, argv: 7fffa41b33a0, envp: 7fffa41b33b0)
	      echo-128     [000] .....   103.875102: sys_execve -> 0x0
	      echo-128     [000] .....   103.882097: sys_execveat(fd: 0,
  filename: 1009ac48, argv: 7fffd10d2148, envp: 7fffd10d2158, flags: 0)
	      echo-128     [000] .....   103.883225: sys_execveat -> 0x0

Cc: stable@vger.kernel.org
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Tested-by: Sumit Dubey2 <Sumit.Dubey2@ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220609103328.41306-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1818,7 +1818,7 @@ void start_thread(struct pt_regs *regs,
 		tm_reclaim_current(0);
 #endif
 
-	memset(regs->gpr, 0, sizeof(regs->gpr));
+	memset(&regs->gpr[1], 0, sizeof(regs->gpr) - sizeof(regs->gpr[0]));
 	regs->ctr = 0;
 	regs->link = 0;
 	regs->xer = 0;


