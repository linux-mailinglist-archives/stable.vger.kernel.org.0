Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA91C14FA
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgEANoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731332AbgEANoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:44:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 999C720757;
        Fri,  1 May 2020 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340684;
        bh=XJaNe5pXks9bL5KapSdiW5O2hhPV6fdgJmwFmiAry0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt4JXX8lHBWL+ULYvj6ZK63tmlpWw4RyjwX75WMb4cZAnIQwBxvcKZs7LlkfCUKuE
         4vdmKM2SyIXFKMQVkMXx7yKV825osH7xuwR0oHt/WCDepVAn0hWqDT/237QeqCIs8F
         iQ8CmBMFCpRjLnExAtM/fg6Y6FD2FIqJLqLLJOvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Xu <peterx@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 086/106] sched/isolation: Allow "isolcpus=" to skip unknown sub-parameters
Date:   Fri,  1 May 2020 15:23:59 +0200
Message-Id: <20200501131553.927400371@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

[ Upstream commit 3662daf023500dc084fa3b96f68a6f46179ddc73 ]

The "isolcpus=" parameter allows sub-parameters before the cpulist is
specified, and if the parser detects an unknown sub-parameters the whole
parameter will be ignored.

This design is incompatible with itself when new sub-parameters are added.
An older kernel will not recognize the new sub-parameter and will
invalidate the whole parameter so the CPU isolation will not take
effect. It emits a warning:

    isolcpus: Error, unknown flag

The better and compatible way is to allow "isolcpus=" to skip unknown
sub-parameters, so that even if new sub-parameters are added an older
kernel will still be able to behave as usual even if with the new
sub-parameter specified on the command line.

Ideally this should have been there when the first sub-parameter for
"isolcpus=" was introduced.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20200403223517.406353-1-peterx@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/isolation.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 008d6ac2342b7..808244f3ddd98 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -149,6 +149,9 @@ __setup("nohz_full=", housekeeping_nohz_full_setup);
 static int __init housekeeping_isolcpus_setup(char *str)
 {
 	unsigned int flags = 0;
+	bool illegal = false;
+	char *par;
+	int len;
 
 	while (isalpha(*str)) {
 		if (!strncmp(str, "nohz,", 5)) {
@@ -169,8 +172,22 @@ static int __init housekeeping_isolcpus_setup(char *str)
 			continue;
 		}
 
-		pr_warn("isolcpus: Error, unknown flag\n");
-		return 0;
+		/*
+		 * Skip unknown sub-parameter and validate that it is not
+		 * containing an invalid character.
+		 */
+		for (par = str, len = 0; *str && *str != ','; str++, len++) {
+			if (!isalpha(*str) && *str != '_')
+				illegal = true;
+		}
+
+		if (illegal) {
+			pr_warn("isolcpus: Invalid flag %.*s\n", len, par);
+			return 0;
+		}
+
+		pr_info("isolcpus: Skipped unknown flag %.*s\n", len, par);
+		str++;
 	}
 
 	/* Default behaviour for isolcpus without flags */
-- 
2.20.1



