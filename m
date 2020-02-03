Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BABC150BF6
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgBCQcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:32:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730352AbgBCQcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:04 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23302051A;
        Mon,  3 Feb 2020 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747523;
        bh=B6Dk8xn/uBzWrLbdX1gWUgO9ftBCd/W5Llg4eiJ+9qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDeunTTVWQwmU8N84JZvSicAKUX11MYMVJ9BVCI90C4B5GbVzRJqJwq3Ks4nmAjPA
         zCWRc8oeTtMlsqgBDfnHS+VbcpyKQHg1eTyYfSVKM1qfIqcqBBzN+lHV09mtNF3AuK
         Jfum1xXc3LE5zO03rp4Ai6AzD5kkLXtE9EE/7Hr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hewenliang <hewenliang4@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Feilong Lin <linfeilong@huawei.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/70] tools lib traceevent: Fix memory leakage in filter_event
Date:   Mon,  3 Feb 2020 16:19:41 +0000
Message-Id: <20200203161916.756297458@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2700f1f17876e..27248a0aad84a 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1227,8 +1227,10 @@ filter_event(struct event_filter *filter, struct event_format *event,
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



