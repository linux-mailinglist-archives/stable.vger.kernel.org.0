Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF6B119816
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLJVg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:36:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbfLJVfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B9FF206D5;
        Tue, 10 Dec 2019 21:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013750;
        bh=nOkPPpLBDp48L0BmNz08TffGbuVhBHVy5yiEru9/Pyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/lmXmN9KRmq1dnlh5iuraIfoYFele6our7A2KvV0LHEvLNjrbh6fjUorfMBU57l2
         INkCIBcXs31PM+bdwu5PSNef5D8JhwgLn8W4YU2kbfrr3IulIQsjDuuE1Rsu1cd4Ud
         Fp8AZmnh0gOIIrnzMOplHC1YF2B0SbjwhdkeZiGs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hewenliang <hewenliang4@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 172/177] libtraceevent: Fix memory leakage in copy_filter_type
Date:   Tue, 10 Dec 2019 16:32:16 -0500
Message-Id: <20191210213221.11921-172-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hewenliang <hewenliang4@huawei.com>

[ Upstream commit 10992af6bf46a2048ad964985a5b77464e5563b1 ]

It is necessary to free the memory that we have allocated when error occurs.

Fixes: ef3072cd1d5c ("tools lib traceevent: Get rid of die in add_filter_type()")
Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Link: http://lore.kernel.org/lkml/20191119014415.57210-1-hewenliang4@huawei.com
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index e76154c02ee7a..2700f1f17876e 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1475,8 +1475,10 @@ static int copy_filter_type(struct event_filter *filter,
 	if (strcmp(str, "TRUE") == 0 || strcmp(str, "FALSE") == 0) {
 		/* Add trivial event */
 		arg = allocate_arg();
-		if (arg == NULL)
+		if (arg == NULL) {
+			free(str);
 			return -1;
+		}
 
 		arg->type = FILTER_ARG_BOOLEAN;
 		if (strcmp(str, "TRUE") == 0)
@@ -1485,8 +1487,11 @@ static int copy_filter_type(struct event_filter *filter,
 			arg->boolean.value = 0;
 
 		filter_type = add_filter_type(filter, event->id);
-		if (filter_type == NULL)
+		if (filter_type == NULL) {
+			free(str);
+			free_arg(arg);
 			return -1;
+		}
 
 		filter_type->filter = arg;
 
-- 
2.20.1

