Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7330C3AEEDE
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhFUQdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231229AbhFUQbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:31:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C2E6613B3;
        Mon, 21 Jun 2021 16:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292719;
        bh=1v5CHjuYtHE2u+2LumkgKLtHQCqJpHWDSomu6XY6KKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lyhu9YxOaXU1fUmGit+lPoOgcVNeRQDoQaA1Tel9PIScnpkgdPH50yOUPJRKXdir4
         oXH9srtUNzBr6Pczz+BZA/gyGYaNynk4K6C6CIBYrD2Y5IVO+r6Gwp8MQ02fc5eqdY
         Vt8mAg7JtG4EpCINUdgcoVAU+MXYM9BmKbHCFD3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 104/146] tracing: Do not stop recording cmdlines when tracing is off
Date:   Mon, 21 Jun 2021 18:15:34 +0200
Message-Id: <20210621154917.871758324@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 85550c83da421fb12dc1816c45012e1e638d2b38 upstream.

The saved_cmdlines is used to map pids to the task name, such that the
output of the tracing does not just show pids, but also gives a human
readable name for the task.

If the name is not mapped, the output looks like this:

    <...>-1316          [005] ...2   132.044039: ...

Instead of this:

    gnome-shell-1316    [005] ...2   132.044039: ...

The names are updated when tracing is running, but are skipped if tracing
is stopped. Unfortunately, this stops the recording of the names if the
top level tracer is stopped, and not if there's other tracers active.

The recording of a name only happens when a new event is written into a
ring buffer, so there is no need to test if tracing is on or not. If
tracing is off, then no event is written and no need to test if tracing is
off or not.

Remove the check, as it hides the names of tasks for events in the
instance buffers.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2483,8 +2483,6 @@ static bool tracing_record_taskinfo_skip
 {
 	if (unlikely(!(flags & (TRACE_RECORD_CMDLINE | TRACE_RECORD_TGID))))
 		return true;
-	if (atomic_read(&trace_record_taskinfo_disabled) || !tracing_is_on())
-		return true;
 	if (!__this_cpu_read(trace_taskinfo_save))
 		return true;
 	return false;


