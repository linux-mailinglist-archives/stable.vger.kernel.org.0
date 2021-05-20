Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF37C38AA8D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbhETLPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239439AbhETLNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:13:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC09761D57;
        Thu, 20 May 2021 10:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505278;
        bh=8LgiR+npoFqEB1JNgPzV+J/DXcKVw+ekEdRPhgyEXis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7mvKluYaaxd7zwaeb+wPrx4Vkw46wZmeA/fPMKR1ueVLk57rgkKW0PeELAXHKGIX
         ri86acKxpAWwlXdWytnngPWf9q3bw2n1ihOJR34vN+1l7KrmTGhqBCS04MqjDBm0h4
         cEGzzVKaazNKpW6F6G3r+TfOayL+SvZagqRwu9II=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel-team@android.com,
        Ingo Molnar <mingo@redhat.com>,
        Michael Sartain <mikesart@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.4 062/190] tracing: Treat recording comm for idle task as a success
Date:   Thu, 20 May 2021 11:22:06 +0200
Message-Id: <20210520092104.215509374@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
@@ -1564,7 +1564,11 @@ static int trace_save_cmdline(struct tas
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


