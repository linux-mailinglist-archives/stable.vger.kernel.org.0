Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B1817FC76
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgCJNGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbgCJNGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:06:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAADD24694;
        Tue, 10 Mar 2020 13:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845572;
        bh=YcuXAvjdUZaz93rApUSzNq11TGPMtEnbZIjQWbayKQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfeRPwCLUmWyIm+HaX2b/sTwRovl8T9L+5m90fTKdTq6onuDxwFLhMJYtKRFrHrRE
         8a/+Cw7XAEqlvtQX2svPiTdKUtU6yRv3pdPly2EooRDfeLlbL2pAr9+1qRkbWpgFaM
         yDs8CYOc8qt00KALCJtt43aBGPcBTicTDbU7B/S0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH 4.14 024/126] sysrq: Restore original console_loglevel when sysrq disabled
Date:   Tue, 10 Mar 2020 13:40:45 +0100
Message-Id: <20200310124206.055710550@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

commit 075e1a0c50f59ea210561d0d0fedbd945615df78 upstream.

The sysrq header line is printed with an increased loglevel
to provide users some positive feedback.

The original loglevel is not restored when the sysrq operation
is disabled. This bug was introduced in 2.6.12 (pre-git-history)
by the commit ("Allow admin to enable only some of the Magic-Sysrq
functions").

Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tommi Rantala <tommi.t.rantala@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/sysrq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -560,6 +560,7 @@ void __handle_sysrq(int key, bool check_
 			op_p->handler(key);
 		} else {
 			pr_cont("This sysrq operation is disabled.\n");
+			console_loglevel = orig_log_level;
 		}
 	} else {
 		pr_cont("HELP : ");


