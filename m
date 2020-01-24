Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB2C148A10
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390820AbgAXOSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390808AbgAXOSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C800D2087E;
        Fri, 24 Jan 2020 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875511;
        bh=IO9VbcI3uUwDUmwFpNRvGb7+MdliZwybJcqPxKfZbI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qECIe04c6BIoNwMZ2vIwUWHWihi5bfxQY7NbfOzZoG/5bYNAxrYHCmZcGaqSmBH3E
         EpY9UrRzs9NqSX0taS5hpQO0Om5Ompill7vzPZeMNBkk1nkItWH5zoBbNdpzUhuIoH
         BULISW7shAtR/RC7l9Vo0Tt0Uf1moy93c5F25eGw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hewenliang <hewenliang4@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Feilong Lin <linfeilong@huawei.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 012/107] tools lib traceevent: Fix memory leakage in filter_event
Date:   Fri, 24 Jan 2020 09:16:42 -0500
Message-Id: <20200124141817.28793-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hewenliang <hewenliang4@huawei.com>

[ Upstream commit f84ae29a6169318f9c929720c49d96323d2bbab9 ]

It is necessary to call free_arg(arg) when add_filter_type() returns NULL
in filter_event().

Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Link: http://lore.kernel.org/lkml/20191209063549.59941-1-hewenliang4@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index f3cbf86e51acf..20eed719542e5 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1228,8 +1228,10 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
 	}
 
 	filter_type = add_filter_type(filter, event->id);
-	if (filter_type == NULL)
+	if (filter_type == NULL) {
+		free_arg(arg);
 		return TEP_ERRNO__MEM_ALLOC_FAILED;
+	}
 
 	if (filter_type->filter)
 		free_arg(filter_type->filter);
-- 
2.20.1

