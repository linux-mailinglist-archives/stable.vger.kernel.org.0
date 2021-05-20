Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6FC38A901
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbhETK4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238470AbhETKyK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:54:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 114CE61CDD;
        Thu, 20 May 2021 10:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504855;
        bh=owzgNn2Tak6GCVFk1gVTPH/OnCO54fe/wccwmr06aVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7ts8xGbjYNbmJIeY5OUrdkn5ogyaDKXsKR5Fx/fi8zzx1GpY+39PGYBfnK94cJvS
         L+Dh0eJ1nn9vLZB/JHcBDvXj/DgDZdpwuqAU8GJT3Hqxv9Qc/5YaoNpq5sogQHAXYZ
         YfBK6Ch+0k71hCrBoXC6IOLs5oovEtwlL3xa9/tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel-team@android.com,
        Ingo Molnar <mingo@redhat.com>,
        Michael Sartain <mikesart@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 076/240] tracing: Treat recording comm for idle task as a success
Date:   Thu, 20 May 2021 11:21:08 +0200
Message-Id: <20210520092111.232931810@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Fernandes <joelaf@google.com>

commit eaf260ac04d9b4cf9f458d5c97555bfff2da526e upstream.

Currently we stop recording comm for non-idle tasks when switching from/to idle
task since we treat that as a record failure. Fix that by treat recording of
comm for idle task as a success.

Link: http://lkml.kernel.org/r/20170706230023.17942-1-joelaf@google.com

Cc: kernel-team@android.com
Cc: Ingo Molnar <mingo@redhat.com>
Reported-by: Michael Sartain <mikesart@gmail.com>
Signed-off-by: Joel Fernandes <joelaf@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1811,7 +1811,11 @@ static int trace_save_cmdline(struct tas
 {
 	unsigned pid, idx;
 
-	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
+	/* treat recording of idle task as a success */
+	if (!tsk->pid)
+		return 1;
+
+	if (unlikely(tsk->pid > PID_MAX_DEFAULT))
 		return 0;
 
 	/*


