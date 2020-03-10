Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27DB17FE78
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgCJMo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCJMoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:44:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E074246B0;
        Tue, 10 Mar 2020 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844265;
        bh=ZS4NWjPF89qGwdTMi7uro6qcefhdn5CGU51aYRCvVuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGBULySQQu+rz0FNoHPUFLfjS4Hr7PCMZrCjKSuiiJAwxlLSUIYFlkMQ5Fg3HE2hn
         k3Trt6D79wX7K1ILlw8GRh4QnLLAJQ5kHHITlp6PKv2JPV0vBXgYbMVLn2FncT8kMV
         1UdbG1oGG1c+72GGMRa1Tk+nXJE1zKEdPXBoCNaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH 4.9 19/88] sysrq: Restore original console_loglevel when sysrq disabled
Date:   Tue, 10 Mar 2020 13:38:27 +0100
Message-Id: <20200310123610.895390183@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
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
@@ -557,6 +557,7 @@ void __handle_sysrq(int key, bool check_
 			op_p->handler(key);
 		} else {
 			pr_cont("This sysrq operation is disabled.\n");
+			console_loglevel = orig_log_level;
 		}
 	} else {
 		pr_cont("HELP : ");


