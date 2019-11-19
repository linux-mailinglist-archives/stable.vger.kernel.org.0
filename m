Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E98B10171B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbfKSFrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730978AbfKSFrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:47:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF4F208C3;
        Tue, 19 Nov 2019 05:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142464;
        bh=ZD0xjZxf+rBGGbulxvdMIUcuFcIPAo9Xn7A7JcL8GCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVDylcLy2MzlnRY+QXIbCv4efRawyixXg8KmhEYae5/or1hgNoPRcGIHX4ecqplNs
         msxKv9VuSaNDRlR1Obdprx0NCJAISRi/jNK9Jtz2FChY166dfrDiTaJxAlai4YPiNS
         QxGWuKqraTAMUGNEe4R6iFykEiVjAFJRi+IDy+eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/239] signal: Always ignore SIGKILL and SIGSTOP sent to the global init
Date:   Tue, 19 Nov 2019 06:18:11 +0100
Message-Id: <20191119051319.779339966@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 86989c41b5ea08776c450cb759592532314a4ed6 ]

If the first process started (aka /sbin/init) receives a SIGKILL it
will panic the system if it is delivered.  Making the system unusable
and undebugable.  It isn't much better if the first process started
receives SIGSTOP.

So always ignore SIGSTOP and SIGKILL sent to init.

This is done in a separate clause in sig_task_ignored as force_sig_info
can clear SIG_UNKILLABLE and this protection should work even then.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index bb801156628ee..c9b203875001e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -77,6 +77,10 @@ static int sig_task_ignored(struct task_struct *t, int sig, bool force)
 
 	handler = sig_handler(t, sig);
 
+	/* SIGKILL and SIGSTOP may not be sent to the global init */
+	if (unlikely(is_global_init(t) && sig_kernel_only(sig)))
+		return true;
+
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
 	    handler == SIG_DFL && !(force && sig_kernel_only(sig)))
 		return 1;
-- 
2.20.1



