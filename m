Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2293F21FCDE
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgGNSrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729785AbgGNSrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:47:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D434522AB0;
        Tue, 14 Jul 2020 18:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752460;
        bh=W7vStj3YtdpzeydOFVEpUDcx8DzNF5sDUM/w66x1BVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVijbIzMc+SoDEMnvKDhPn3KOJJMjZtA3K/Xakmw5gIwZZyFM6ORi8jXPjmq6JwKE
         2aoyXi5eIb0lAjzKTg9yOwekJxD7CGtwpWZudObhWuZi/joc9tCmRrP5fmzTUsGRiH
         72o0Fx5DNfaGQYEtppjwRxe9xKhMjKBjPO5hijGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 50/58] kprobes: Do not expose probe addresses to non-CAP_SYSLOG
Date:   Tue, 14 Jul 2020 20:44:23 +0200
Message-Id: <20200714184058.655527155@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 60f7bb66b88b649433bf700acfc60c3f24953871 upstream.

The kprobe show() functions were using "current"'s creds instead
of the file opener's creds for kallsyms visibility. Fix to use
seq_file->file->f_cred.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 81365a947de4 ("kprobes: Show address of kprobes if kallsyms does")
Fixes: ffb9bd68ebdb ("kprobes: Show blacklist addresses as same as kallsyms does")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2334,7 +2334,7 @@ static void report_probe(struct seq_file
 	else
 		kprobe_type = "k";
 
-	if (!kallsyms_show_value(current_cred()))
+	if (!kallsyms_show_value(pi->file->f_cred))
 		addr = NULL;
 
 	if (sym)
@@ -2435,7 +2435,7 @@ static int kprobe_blacklist_seq_show(str
 	 * If /proc/kallsyms is not showing kernel address, we won't
 	 * show them here either.
 	 */
-	if (!kallsyms_show_value(current_cred()))
+	if (!kallsyms_show_value(m->file->f_cred))
 		seq_printf(m, "0x%px-0x%px\t%ps\n", NULL, NULL,
 			   (void *)ent->start_addr);
 	else


