Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1501B7539
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgDXMbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDXMXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F2B21473;
        Fri, 24 Apr 2020 12:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730987;
        bh=XJaNe5pXks9bL5KapSdiW5O2hhPV6fdgJmwFmiAry0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grzgqEbkD4qmlzYjJ/1Siw0m+3GIz0Fyk/lByfuOyEJ5h7CQEsN4slQhJrMdZy3eH
         ROb2nX2UJD37KyMR3CR3h6Gn70VKdBX8LL2EiwYym9XiD0CaHCURV2Ds4l1978nFlD
         hMgUJzlAc+ow1Fz5tlW7Jbx+UJ7u8JgmDsKU2xEY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 26/38] sched/isolation: Allow "isolcpus=" to skip unknown sub-parameters
Date:   Fri, 24 Apr 2020 08:22:24 -0400
Message-Id: <20200424122237.9831-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

