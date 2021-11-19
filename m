Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EA84575B3
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhKSRlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235663AbhKSRll (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A2161A3A;
        Fri, 19 Nov 2021 17:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343519;
        bh=Ow9bS9xa/lcIRd2EhTFzzgry/Z5eaD8P5hzStwGRXPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HozCFiD2foiEwoxzxUV8OZdWUgoSn6TyjnAXZtxlohdPquciJYOS+AZaOq0At4YNn
         iG8ODuf3wLni7PM4qfllbiIjDcqTqTWiYx27XNUmUi4Mzgzrtm/OLXMooTaNINXka/
         Yyfxi35SsnzR2sQBoiGVtnaeksxxn780ZzntFFas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 04/21] bootconfig: init: Fix memblock leak in xbc_make_cmdline()
Date:   Fri, 19 Nov 2021 18:37:39 +0100
Message-Id: <20211119171444.031906009@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
References: <20211119171443.892729043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 1ae43851b18afe861120ebd7c426dc44f06bb2bd upstream.

Free unused memblock in a error case to fix memblock leak
in xbc_make_cmdline().

Link: https://lkml.kernel.org/r/163177339181.682366.8713781325929549256.stgit@devnote2

Fixes: 51887d03aca1 ("bootconfig: init: Allow admin to use bootconfig for kernel command line")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/init/main.c
+++ b/init/main.c
@@ -380,6 +380,7 @@ static char * __init xbc_make_cmdline(co
 	ret = xbc_snprint_cmdline(new_cmdline, len + 1, root);
 	if (ret < 0 || ret > len) {
 		pr_err("Failed to print extra kernel cmdline.\n");
+		memblock_free(__pa(new_cmdline), len + 1);
 		return NULL;
 	}
 


