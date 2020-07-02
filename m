Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EFE213019
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 01:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgGBX1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 19:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGBX0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 19:26:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCE1C08C5DF
        for <stable@vger.kernel.org>; Thu,  2 Jul 2020 16:26:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bj10so6672387plb.11
        for <stable@vger.kernel.org>; Thu, 02 Jul 2020 16:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q1PVeb6fv9O4tcp1xeI7Kv1tDhwIRUamp8uOCGfdP9I=;
        b=nLitFGMZ3iJQ+NRe4yjSjJbhuNgzdznGk3v2RtpFpP1PwlQyUH1mf7WdnvMVmN1Cnh
         xvPi9UCeh1KJ97EtRpXU8S0CGS0Ah25ME5FCI5J+l7/VWtNFrQ49fbHVY7DSeQEHd6Wr
         7fXIVlmNBDLWtmc/JFkRnpElggzpZi018W3FQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q1PVeb6fv9O4tcp1xeI7Kv1tDhwIRUamp8uOCGfdP9I=;
        b=boDMi3U8F1BvRP7T39w+nY1F5lDeUuvPNOijjm+LLBel7n4Y19IXquAGQnBnzxzHTP
         YQi7IAJprMTCZWlyeRSHidKeWcNmsTKsY4BLB+BUsWkTFw23IKjJ/hoRm3ZwzIr/cQb3
         V4fYHlLcChJ1TBl/bK3UfCJkGwIEg4ul2EnHtAD6b6qd4wy9i4kp5wm5SDrRZ4jk8ePe
         qNj5wRBXoi1FoX/B02ioxp7GstbClaHYzArNMgRxqX9WuxLF6NWdcjT3w9h5ShCZrd+B
         Srs3QB2zaOE11DBxqnWUyPTNjli1vzuq4pNke42C6ChRpB5DS2EeNa/i/e9BaASU+oUo
         DDHQ==
X-Gm-Message-State: AOAM5300qx+nwHOww2CF4Jt84AyW7FgBI7n8UrooaaMph62dIjpjpJhF
        PACT9FlLOJ8inMTYsl9S6mB9uw==
X-Google-Smtp-Source: ABdhPJyfu/BBE/tRGfv7q63oFA9soDlr/Q/7lQtwkudUknUb/EPWGsu38RkavOGbv6Eo5VV1Ay7F3w==
X-Received: by 2002:a17:90a:840b:: with SMTP id j11mr26740951pjn.188.1593732403292;
        Thu, 02 Jul 2020 16:26:43 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e6sm2120192pfh.176.2020.07.02.16.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:26:41 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Dominik Czarnota <dominik.czarnota@trailofbits.com>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] kprobes: Do not expose probe addresses to non-CAP_SYSLOG
Date:   Thu,  2 Jul 2020 16:26:37 -0700
Message-Id: <20200702232638.2946421-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702232638.2946421-1-keescook@chromium.org>
References: <20200702232638.2946421-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The kprobe show() functions were using "current"'s creds instead
of the file opener's creds for kallsyms visibility. Fix to use
seq_file->file->f_cred.

Cc: stable@vger.kernel.org
Fixes: 81365a947de4 ("kprobes: Show address of kprobes if kallsyms does")
Fixes: ffb9bd68ebdb ("kprobes: Show blacklist addresses as same as kallsyms does")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/kprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index d4de217e4a91..2e97febeef77 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2448,7 +2448,7 @@ static void report_probe(struct seq_file *pi, struct kprobe *p,
 	else
 		kprobe_type = "k";
 
-	if (!kallsyms_show_value(current_cred()))
+	if (!kallsyms_show_value(pi->file->f_cred))
 		addr = NULL;
 
 	if (sym)
@@ -2540,7 +2540,7 @@ static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
 	 * If /proc/kallsyms is not showing kernel address, we won't
 	 * show them here either.
 	 */
-	if (!kallsyms_show_value(current_cred()))
+	if (!kallsyms_show_value(m->file->f_cred))
 		seq_printf(m, "0x%px-0x%px\t%ps\n", NULL, NULL,
 			   (void *)ent->start_addr);
 	else
-- 
2.25.1

