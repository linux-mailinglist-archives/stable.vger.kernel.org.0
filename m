Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F2717F796
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgCJMkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJMkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:40:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A6A24691;
        Tue, 10 Mar 2020 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844042;
        bh=NzvRe/2oE5dJlgq8qNCZO77anKN8MyVNsNq6AYjQr5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4VaX/7ArRbtK8KPjnP6jn4eK2aR6shDV5R4iJiOI+a06K4QQIeQj0zLb8sWmOfnl
         4aI/8yuqJfN/bXD5D78yOGapPoGSJ9Ufw3tDFA5omFyOsO6VS3zqc7rcJYSH58rfw2
         NNpaZD8SiD5B+VY3Oke0rY3B7XCuhKrOEREctrYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH 4.4 10/72] sysrq: Restore original console_loglevel when sysrq disabled
Date:   Tue, 10 Mar 2020 13:38:23 +0100
Message-Id: <20200310123604.157751943@linuxfoundation.org>
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
@@ -556,6 +556,7 @@ void __handle_sysrq(int key, bool check_
 			op_p->handler(key);
 		} else {
 			pr_cont("This sysrq operation is disabled.\n");
+			console_loglevel = orig_log_level;
 		}
 	} else {
 		pr_cont("HELP : ");


