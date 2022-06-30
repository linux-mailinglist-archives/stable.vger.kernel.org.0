Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE580561BBD
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiF3Nsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiF3NsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:48:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFEB38D;
        Thu, 30 Jun 2022 06:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFF6FB82AED;
        Thu, 30 Jun 2022 13:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2A0C34115;
        Thu, 30 Jun 2022 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596889;
        bh=jnYrvhpOjtPsZoLxpSm3lR+OsLMdO0LuIl9CHFPgdyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+6t2UAKO09vOQUzv0YKG0Fc5D97VKsYtopwVuY0xE75IhcIRYOTMQDVkvnvksgkH
         wqM1XnIqj2cUmTtrk4q5Mv7DQweRMOmoz6RT9z00/9uC1lIju1ZzNq+ktEX5olJBVV
         tcfctiXW4Od1ezZ1oeBht2EAcecDYWJ14rxR97iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sumit Dubey2 <Sumit.Dubey2@ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 18/29] powerpc: Enable execve syscall exit tracepoint
Date:   Thu, 30 Jun 2022 15:46:18 +0200
Message-Id: <20220630133231.740297091@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
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
@@ -1591,7 +1591,7 @@ void start_thread(struct pt_regs *regs,
 		tm_reclaim_current(0);
 #endif
 
-	memset(regs->gpr, 0, sizeof(regs->gpr));
+	memset(&regs->gpr[1], 0, sizeof(regs->gpr) - sizeof(regs->gpr[0]));
 	regs->ctr = 0;
 	regs->link = 0;
 	regs->xer = 0;


