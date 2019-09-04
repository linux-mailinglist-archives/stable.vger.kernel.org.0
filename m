Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2B7A8C8C
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbfIDQOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732449AbfIDP7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B5F2070C;
        Wed,  4 Sep 2019 15:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612785;
        bh=iqudMozqhnICU8g0jgukQ+85UGagEzqQzHuZp5btJuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7ZHcs1L8E+k3SmfO8/lb7RjSD8rL15GsuxRA+n16VN5WyxOp2VChAAHIS4ls6AhH
         iu9vOzAJTf2eXyX/2gY5b78SZVJG7WJi4ssIfBuDfJ8EZM7R7Skaq+SKFor8bXpt8X
         BnFU6/9h+YsKoZEY8vPtF6CrGW+FBouoBa3H2Zks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 80/94] tools/power x86_energy_perf_policy: Fix argument parsing
Date:   Wed,  4 Sep 2019 11:57:25 -0400
Message-Id: <20190904155739.2816-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>

[ Upstream commit 03531482402a2bc4ab93cf6dde46833775e035e9 ]

The -w argument in x86_energy_perf_policy currently triggers an
unconditional segfault.

This is because the argument string reads: "+a:c:dD:E:e:f:m:M:rt:u:vw" and
yet the argument handler expects an argument.

When parse_optarg_string is called with a null argument, we then proceed to
crash in strncmp, not horribly friendly.

The man page describes -w as taking an argument, the long form
(--hwp-window) is correctly marked as taking a required argument, and the
code expects it.

As such, this patch simply marks the short form (-w) as requiring an
argument.

Signed-off-by: Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 7663abef51e96..3fe1eed900d41 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -545,7 +545,7 @@ void cmdline(int argc, char **argv)
 
 	progname = argv[0];
 
-	while ((opt = getopt_long_only(argc, argv, "+a:c:dD:E:e:f:m:M:rt:u:vw",
+	while ((opt = getopt_long_only(argc, argv, "+a:c:dD:E:e:f:m:M:rt:u:vw:",
 				long_options, &option_index)) != -1) {
 		switch (opt) {
 		case 'a':
-- 
2.20.1

