Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 834D717F799
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgCJMkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJMkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:40:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A1E124686;
        Tue, 10 Mar 2020 12:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844045;
        bh=6vgnEVKPxfD/pdUoe5UTAYqvaq18nWzg0dsew9eFp2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3WNmNhwcYtUE4spk3/ugKJoJO6prP3p8JuuFMf0po1DfzpUWc0VEBwTEDHJGv6rz
         XORrk/G/ncf9rqcVJS0w7EB0GkdU7WaWApTlCIRuLT1Nw0XmpbSFRhOUi70cULklkI
         vz7AzFXYPRjTrDKyhJnbp+PBCvPE8zgK8O4J6JFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH 4.4 11/72] sysrq: Remove duplicated sysrq message
Date:   Tue, 10 Mar 2020 13:38:24 +0100
Message-Id: <20200310123604.449673448@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

commit c3fee60908db4a8594f2e4a2131998384b8fa006 upstream.

The commit 97f5f0cd8cd0a0544 ("Input: implement SysRq as a separate input
handler") added pr_fmt() definition. It caused a duplicated message
prefix in the sysrq header messages, for example:

[  177.053931] sysrq: SysRq : Show backtrace of all active CPUs
[  742.864776] sysrq: SysRq : HELP : loglevel(0-9) reboot(b) crash(c)

Fixes: 97f5f0cd8cd0a05 ("Input: implement SysRq as a separate input handler")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Tommi Rantala  <tommi.t.rantala@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/sysrq.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -542,7 +542,6 @@ void __handle_sysrq(int key, bool check_
 	 */
 	orig_log_level = console_loglevel;
 	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
-	pr_info("SysRq : ");
 
         op_p = __sysrq_get_key_op(key);
         if (op_p) {
@@ -551,15 +550,15 @@ void __handle_sysrq(int key, bool check_
 		 * should not) and is the invoked operation enabled?
 		 */
 		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
-			pr_cont("%s\n", op_p->action_msg);
+			pr_info("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
 			op_p->handler(key);
 		} else {
-			pr_cont("This sysrq operation is disabled.\n");
+			pr_info("This sysrq operation is disabled.\n");
 			console_loglevel = orig_log_level;
 		}
 	} else {
-		pr_cont("HELP : ");
+		pr_info("HELP : ");
 		/* Only print the help msg once per handler */
 		for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++) {
 			if (sysrq_key_table[i]) {


