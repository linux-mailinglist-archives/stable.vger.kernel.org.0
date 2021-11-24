Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05DB45BD49
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243782AbhKXMhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:37:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344055AbhKXMe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:34:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 637C96108D;
        Wed, 24 Nov 2021 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756476;
        bh=fZXrAMowt1mPhO6b8vKZbcOJ66dxfQP3LqK1emOm2MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjv7DNzpFwNHFZomm7z9OwPAk4woTQCnrolA9C69iu8iL9RSkFtvevUnhDcT8wLXZ
         JIgimBUWGv/MrR9fz7vaqc7dYcGAn6MlPbmDhfw7T1A1NY3KQAhOp8pF/dsTnxLPx1
         wDhPAUAMZ8jV4MaiAYlTgnhofDnyuVXIzef5Y5YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 099/251] ARM: clang: Do not rely on lr register for stacktrace
Date:   Wed, 24 Nov 2021 12:55:41 +0100
Message-Id: <20211124115713.694341545@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index ba9b9a77bcd2c..31af81d46aaed 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -52,8 +52,7 @@ int notrace unwind_frame(struct stackframe *frame)
 
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



