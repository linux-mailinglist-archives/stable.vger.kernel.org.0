Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27701CB014
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgEHMh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbgEHMhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2199B21473;
        Fri,  8 May 2020 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941474;
        bh=pVVlKO1UvyZw+Re9QxKjrJrqRNOU00yFDpihtZAWbrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zoRjKOw0/wfSSsaJeG5nPVZWoS8bsKYkscipLTzMtWsa3UaMdsfa/oVIimONNSiF
         yfvBc8kEX7RzxwizTyPXcJ1yvwSV9vM4R7TgSq4p3W9/nhxlLMNKwCDI1okLsr1nRP
         84hSbJTuzliULa8WAvB4aQiaj4SMRdTjnb1Lyt7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.4 046/312] x86/LDT: Print the real LDT base address
Date:   Fri,  8 May 2020 14:30:37 +0200
Message-Id: <20200508123127.795627191@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

commit 0d430e3fb3f7cdc13c0d22078b820f682821b45a upstream.

This was meant to print base address and entry count; make it do so
again.

Fixes: 37868fe113ff "x86/ldt: Make modify_ldt synchronous"
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Andy Lutomirski <luto@kernel.org>
Link: http://lkml.kernel.org/r/56797D8402000078000C24F0@prv-mh.provo.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/process_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -128,7 +128,7 @@ void release_thread(struct task_struct *
 		if (dead_task->mm->context.ldt) {
 			pr_warn("WARNING: dead process %s still has LDT? <%p/%d>\n",
 				dead_task->comm,
-				dead_task->mm->context.ldt,
+				dead_task->mm->context.ldt->entries,
 				dead_task->mm->context.ldt->size);
 			BUG();
 		}


