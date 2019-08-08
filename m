Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E77869BE
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405301AbfHHTKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405286AbfHHTKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:10:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAAD5214C6;
        Thu,  8 Aug 2019 19:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291429;
        bh=zVXtUSMMLf5kQNv2o0MQ6TzFMU207uN96pyBGf1T2vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5b3ypBtZJBoQLUsApwVRQODji1u1WS/2XGg8Rog/tT6B1m1iP1oD2e10SCxRpkNM
         T7o3kNGpkxbaYcfdmQwVaM3IQdMDluW85GAan2hqezeFPU1VhfD4oU+3YLM0PZurFL
         5TLTltQpAjdqOUcthYetEQX0i8TKzhzOZVtrw6jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4.14 11/33] objtool: Add rewind_stack_do_exit() to the noreturn list
Date:   Thu,  8 Aug 2019 21:05:18 +0200
Message-Id: <20190808190454.122580323@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 4fa5ecda2bf96be7464eb406df8aba9d89260227 upstream.

This fixes the following warning seen on GCC 7.3:

  arch/x86/kernel/dumpstack.o: warning: objtool: oops_end() falls through to next function show_regs()

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/3418ebf5a5a9f6ed7e80954c741c0b904b67b5dc.1554398240.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -166,6 +166,7 @@ static int __dead_end_function(struct ob
 		"lbug_with_loc",
 		"fortify_panic",
 		"machine_real_restart",
+		"rewind_stack_do_exit",
 	};
 
 	if (func->bind == STB_WEAK)


