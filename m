Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03773178112
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387767AbgCCSA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732698AbgCCSAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 607B420728;
        Tue,  3 Mar 2020 18:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258424;
        bh=YcuXAvjdUZaz93rApUSzNq11TGPMtEnbZIjQWbayKQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=li+opimUPv0rgmzNpO7Gr9Re7Jx+jyuvT2AR1NcaXjMN75ytRLXPnie0Pu5O45HmQ
         0lahCyod9x9tOh1RmbJ4kObvn30qOhZGmHQ6wBMYXENr30Cc4Jh3QZOW/8lsFsU+m4
         WYKjRCJWK5Jlqk5++l3cB/IB/m/tqNlNUuq3/V/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH 4.19 27/87] sysrq: Restore original console_loglevel when sysrq disabled
Date:   Tue,  3 Mar 2020 18:43:18 +0100
Message-Id: <20200303174353.190378657@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
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


