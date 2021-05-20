Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD7438A904
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbhETK4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238958AbhETKyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D41A61CDC;
        Thu, 20 May 2021 10:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504857;
        bh=xkd1Q8CSeWpBA7drdtVw5G4L7ki6h1sqEX7D2Ik1PMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beGOulgwFQvBsja9zL1/CzIRukZC150FV0Ws4fi4/6QYpCqfVsxVopEWBUiQIUm3t
         vKhuKpoMCloLhBZ8otD9EkbgOQQjamM8tObM26m6RF8uYG4Q1PTAJs5cprUx+xZ05a
         z2t6PIDNleCi40nVfIU7hKtHiQlA+Xbo2sAa95lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amey Telawane <ameyt@codeaurora.org>,
        Amit Pundir <amit.pundir@linaro.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 077/240] tracing: Use strlcpy() instead of strcpy() in __trace_find_cmdline()
Date:   Thu, 20 May 2021 11:21:09 +0200
Message-Id: <20210520092111.263634972@linuxfoundation.org>
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

From: Amey Telawane <ameyt@codeaurora.org>

commit e09e28671cda63e6308b31798b997639120e2a21 upstream.

Strcpy is inherently not safe, and strlcpy() should be used instead.
__trace_find_cmdline() uses strcpy() because the comms saved must have a
terminating nul character, but it doesn't hurt to add the extra protection
of using strlcpy() instead of strcpy().

Link: http://lkml.kernel.org/r/1493806274-13936-1-git-send-email-amit.pundir@linaro.org

Signed-off-by: Amey Telawane <ameyt@codeaurora.org>
[AmitP: Cherry-picked this commit from CodeAurora kernel/msm-3.10
https://source.codeaurora.org/quic/la/kernel/msm-3.10/commit/?id=2161ae9a70b12cf18ac8e5952a20161ffbccb477]
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
[ Updated change log and removed the "- 1" from len parameter ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1875,7 +1875,7 @@ static void __trace_find_cmdline(int pid
 
 	map = savedcmd->map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
-		strcpy(comm, get_saved_cmdlines(map));
+		strlcpy(comm, get_saved_cmdlines(map), TASK_COMM_LEN);
 	else
 		strcpy(comm, "<...>");
 }


