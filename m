Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D999532EB03
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhCEMl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232288AbhCEMlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:41:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D6CA6502C;
        Fri,  5 Mar 2021 12:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948076;
        bh=UA7kM1YSUvyFkHA+LB4CsP59vVgFeTQm0Av8wunOy4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsV3ft7mpXdiPRQYuQLCrP3dfvWr8ai8uWj0LHznAqtk6ROHXAGbgxtFSzlAQ2ApX
         DnjXKTC46TdtNOYbKOzgz9qlpuuWIWgAbZa2FbsXnOCb+Xm1AsuNSjaM4+nKZqNUDK
         Mfw9MS2/zOYQ7Ei6q5dWpk8OZRnb9FOs9p1CCxlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Jon Medhurst <tixy@linaro.org>,
        huangshaobo <huangshaobo6@huawei.com>
Subject: [PATCH 4.9 09/41] arm: kprobes: Allow to handle reentered kprobe on single-stepping
Date:   Fri,  5 Mar 2021 13:22:16 +0100
Message-Id: <20210305120851.737335023@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit f3fbd7ec62dec1528fb8044034e2885f2b257941 upstream.

This is arm port of commit 6a5022a56ac3 ("kprobes/x86: Allow to
handle reentered kprobe on single-stepping")

Since the FIQ handlers can interrupt in the single stepping
(or preparing the single stepping, do_debug etc.), we should
consider a kprobe is hit in the NMI handler. Even in that
case, the kprobe is allowed to be reentered as same as the
kprobes hit in kprobe handlers
(KPROBE_HIT_ACTIVE or KPROBE_HIT_SSDONE).

The real issue will happen when a kprobe hit while another
reentered kprobe is processing (KPROBE_REENTER), because
we already consumed a saved-area for the previous kprobe.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jon Medhurst <tixy@linaro.org>
Fixes: 24ba613c9d6c ("ARM kprobes: core code")
Cc: stable@vger.kernel.org #v2.6.25~v4.11
Signed-off-by: huangshaobo <huangshaobo6@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/probes/kprobes/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -270,6 +270,7 @@ void __kprobes kprobe_handler(struct pt_
 			switch (kcb->kprobe_status) {
 			case KPROBE_HIT_ACTIVE:
 			case KPROBE_HIT_SSDONE:
+			case KPROBE_HIT_SS:
 				/* A pre- or post-handler probe got us here. */
 				kprobes_inc_nmissed_count(p);
 				save_previous_kprobe(kcb);
@@ -278,6 +279,11 @@ void __kprobes kprobe_handler(struct pt_
 				singlestep(p, regs, kcb);
 				restore_previous_kprobe(kcb);
 				break;
+			case KPROBE_REENTER:
+				/* A nested probe was hit in FIQ, it is a BUG */
+				pr_warn("Unrecoverable kprobe detected at %p.\n",
+					p->addr);
+				/* fall through */
 			default:
 				/* impossible cases */
 				BUG();


