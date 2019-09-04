Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A8CA8E81
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387561AbfIDR6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732748AbfIDR6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:58:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2DB022CF5;
        Wed,  4 Sep 2019 17:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619903;
        bh=fLPibfJ42aAIHABvPctEZANEfg5uArP9JzQqEn9pGTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+ysG/ukT8Ta8DPV3eHmyROB4u65FPRO+uUFzi75W7+Cmp6rXx4EUbLQ8fpiM4TUI
         CvdnfsEyItmyd7h6E9bXrHKn0zSNVQxy6UN4aCz9/1NbhKT0lCI9NaS1oZzg25rnKU
         Uc/j1ZOF6/xv9Oboo50AvM9tPpO1bhLkbFBeOMqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Spengler <spender@grsecurity.net>,
        Dianzhang Chen <dianzhangchen0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, bp@alien8.de,
        hpa@zytor.com
Subject: [PATCH 4.4 77/77] x86/ptrace: fix up botched merge of spectrev1 fix
Date:   Wed,  4 Sep 2019 19:54:04 +0200
Message-Id: <20190904175310.513008739@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I incorrectly merged commit 31a2fbb390fe ("x86/ptrace: Fix possible
spectre-v1 in ptrace_get_debugreg()") when backporting it, as was
graciously pointed out at
https://grsecurity.net/teardown_of_a_failed_linux_lts_spectre_fix.php

Resolve the upstream difference with the stable kernel merge to properly
protect things.

Reported-by: Brad Spengler <spender@grsecurity.net>
Cc: Dianzhang Chen <dianzhangchen0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <bp@alien8.de>
Cc: <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ptrace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -698,11 +698,10 @@ static unsigned long ptrace_get_debugreg
 {
 	struct thread_struct *thread = &tsk->thread;
 	unsigned long val = 0;
-	int index = n;
 
 	if (n < HBP_NUM) {
+		int index = array_index_nospec(n, HBP_NUM);
 		struct perf_event *bp = thread->ptrace_bps[index];
-		index = array_index_nospec(index, HBP_NUM);
 
 		if (bp)
 			val = bp->hw.info.address;


