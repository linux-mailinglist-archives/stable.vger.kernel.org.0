Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D9D1483B6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391285AbgAXLXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:23:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391075AbgAXLXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:07 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 357412077C;
        Fri, 24 Jan 2020 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864986;
        bh=GPTfT/Dw8oHWzYbKZ2TEPSNSimgFWxfxLI6V1CO7c7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PojXByxQCGrxVK3P3tTevpDVDFBoxKoOEhOoCPrZmQjKupFbSfjwLXyJlHtmoHcgV
         0I6kI7HvXUuTTnC3PZqQSUE7FPLDtD6bUk2jU1/JMFebHjZKJ22+leoWvdoHvjP4E8
         TWvkK5jOVPHGR7wvVz+yH4i8XOJkoWMFXi4TwvZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 398/639] signal/bpfilter: Fix bpfilter_kernl to use send_sig not force_sig
Date:   Fri, 24 Jan 2020 10:29:28 +0100
Message-Id: <20200124093136.789272210@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 1dfd1711de2952fd1bfeea7152bd1687a4eea771 ]

The locking in force_sig_info is not prepared to deal with
a task that exits or execs (as sighand may change).  As force_sig
is only built to handle synchronous exceptions.

Further the function force_sig_info changes the signal state if the
signal is ignored, or blocked or if SIGNAL_UNKILLABLE will prevent the
delivery of the signal.  The signal SIGKILL can not be ignored and can
not be blocked and SIGNAL_UNKILLABLE won't prevent it from being
delivered.

So using force_sig rather than send_sig for SIGKILL is pointless.

Because it won't impact the sending of the signal and and because
using force_sig is wrong, replace force_sig with send_sig.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Fixes: d2ba09c17a06 ("net: add skeleton of bpfilter kernel module")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpfilter/bpfilter_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 94e88f510c5b8..450b257afa84d 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -25,7 +25,7 @@ static void shutdown_umh(struct umh_info *info)
 		return;
 	tsk = get_pid_task(find_vpid(info->pid), PIDTYPE_PID);
 	if (tsk) {
-		force_sig(SIGKILL, tsk);
+		send_sig(SIGKILL, tsk, 1);
 		put_task_struct(tsk);
 	}
 	fput(info->pipe_to_umh);
-- 
2.20.1



