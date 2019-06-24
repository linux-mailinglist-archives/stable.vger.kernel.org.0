Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF4150874
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbfFXKRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbfFXKRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:17:21 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB822089F;
        Mon, 24 Jun 2019 10:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371441;
        bh=ywxrxoFTOsh/Ojn1ACIcc0LeWwbqwSqBK72Jfd6p7i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCV/wNUOAEZkxt1yrN7igJPViS8kgJPab414heSqI5ja88Exw9j6HHtBif8D/Kiq3
         KUWG9Cfs8RPKtmAlHi2C5aqdEBIpiU0mLNPj5JUlE3ZG2U/2KW48FbktI7pAl3OSlh
         VFc9iRTTg3J71XDEvOWiby9pMq3Mjpdv6+PmdFwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anisse Astier <aastier@freebox.fr>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 5.1 103/121] arm64: ssbd: explicitly depend on <linux/prctl.h>
Date:   Mon, 24 Jun 2019 17:57:15 +0800
Message-Id: <20190624092325.971109924@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anisse Astier <aastier@freebox.fr>

commit adeaa21a4b6954e878f3f7d1c5659ed9c1fe567a upstream.

Fix ssbd.c which depends implicitly on asm/ptrace.h including
linux/prctl.h (through for example linux/compat.h, then linux/time.h,
linux/seqlock.h, linux/spinlock.h and linux/irqflags.h), and uses
PR_SPEC* defines.

This is an issue since we'll soon be removing the include from
asm/ptrace.h.

Fixes: 9cdc0108baa8 ("arm64: ssbd: Add prctl interface for per-thread mitigation")
Cc: stable@vger.kernel.org
Signed-off-by: Anisse Astier <aastier@freebox.fr>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/ssbd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/ssbd.c
+++ b/arch/arm64/kernel/ssbd.c
@@ -5,6 +5,7 @@
 
 #include <linux/compat.h>
 #include <linux/errno.h>
+#include <linux/prctl.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/thread_info.h>


