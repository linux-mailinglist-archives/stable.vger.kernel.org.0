Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1A87BDC
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436655AbfHINr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406889AbfHINrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A3C21882;
        Fri,  9 Aug 2019 13:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358471;
        bh=zVXtUSMMLf5kQNv2o0MQ6TzFMU207uN96pyBGf1T2vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQJsZf9rCuD4VFkTldZCrJIza6sP9JCnF3U6UtsiorFBea7DsFzHsVJjdsmCcia7H
         CjTrJtIpnpdw79zrwirREX1toleBpK2A7kG6Vg6pAdEJL7KtySy9wZiVcIDmZPtlq7
         hzVVuyek06UJP2dFSDAjo01niPHnudZJahtAumEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4.9 13/32] objtool: Add rewind_stack_do_exit() to the noreturn list
Date:   Fri,  9 Aug 2019 15:45:16 +0200
Message-Id: <20190809133923.396660809@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
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


