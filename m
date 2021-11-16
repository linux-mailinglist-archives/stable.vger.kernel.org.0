Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD57453B84
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 22:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhKPVP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 16:15:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229532AbhKPVP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 16:15:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0CC161BF5;
        Tue, 16 Nov 2021 21:13:00 +0000 (UTC)
Date:   Tue, 16 Nov 2021 16:12:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     mhiramat@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] bootconfig: init: Fix memblock leak in
 xbc_make_cmdline()" failed to apply to 5.14-stable tree
Message-ID: <20211116161258.55b5e50d@gandalf.local.home>
In-Reply-To: <1634553054181194@kroah.com>
References: <1634553054181194@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Oct 2021 12:30:54 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

This should apply to both 5.14 and 5.10.

-- Steve

> ------------------ original commit in Linus's tree ------------------

>From 1ae43851b18afe861120ebd7c426dc44f06bb2bd Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 16 Sep 2021 15:23:12 +0900
Subject: [PATCH] bootconfig: init: Fix memblock leak in xbc_make_cmdline()

Free unused memblock in a error case to fix memblock leak
in xbc_make_cmdline().

Link: https://lkml.kernel.org/r/163177339181.682366.8713781325929549256.stgit@devnote2

Fixes: 51887d03aca1 ("bootconfig: init: Allow admin to use bootconfig for kernel command line")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/init/main.c
===================================================================
--- linux-test.git.orig/init/main.c
+++ linux-test.git/init/main.c
@@ -382,6 +382,7 @@ static char * __init xbc_make_cmdline(co
 	ret = xbc_snprint_cmdline(new_cmdline, len + 1, root);
 	if (ret < 0 || ret > len) {
 		pr_err("Failed to print extra kernel cmdline.\n");
+		memblock_free(__pa(new_cmdline), len + 1);
 		return NULL;
 	}
 
