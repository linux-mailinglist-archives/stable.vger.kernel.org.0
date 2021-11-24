Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665DD45C011
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345486AbhKXNEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347784AbhKXNDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153A2619F9;
        Wed, 24 Nov 2021 12:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757370;
        bh=n1IioQQzOH0POz7eaWR7ENdja0fn4A3UEsNKmpHT5UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJBfPTkQP5ya7OiXu7dJdQuHKglRqE/qc2nQbqJa6xVR4tGXkNAzN2OP6lc/VJ5Bn
         bCPbOhH9Hyc2tW7qNlAfE7Q4jcAy6lmrdckual3N1U4p+gnWNUWiIPvsjyd9kx+Esd
         H90pbEov8ypkKH6EwS577SF5amUnSLiuFzWUe3Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/323] ARM: clang: Do not rely on lr register for stacktrace
Date:   Wed, 24 Nov 2021 12:55:08 +0100
Message-Id: <20211124115722.931188595@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit b3ea5d56f212ad81328c82454829a736197ebccc ]

Currently the stacktrace on clang compiled arm kernel uses the 'lr'
register to find the first frame address from pt_regs. However, that
is wrong after calling another function, because the 'lr' register
is used by 'bl' instruction and never be recovered.

As same as gcc arm kernel, directly use the frame pointer (r11) of
the pt_regs to find the first frame address.

Note that this fixes kretprobe stacktrace issue only with
CONFIG_UNWINDER_FRAME_POINTER=y. For the CONFIG_UNWINDER_ARM,
we need another fix.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/stacktrace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index d23ab9ec130a3..a452b859f485f 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -53,8 +53,7 @@ int notrace unwind_frame(struct stackframe *frame)
 
 	frame->sp = frame->fp;
 	frame->fp = *(unsigned long *)(fp);
-	frame->pc = frame->lr;
-	frame->lr = *(unsigned long *)(fp + 4);
+	frame->pc = *(unsigned long *)(fp + 4);
 #else
 	/* check current frame pointer is within bounds */
 	if (fp < low + 12 || fp > high - 4)
-- 
2.33.0



