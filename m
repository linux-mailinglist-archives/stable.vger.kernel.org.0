Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B163B27CDC0
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgI2LGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbgI2LFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:05:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E6421924;
        Tue, 29 Sep 2020 11:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377515;
        bh=87+WqOweEGv6JEXprGAxQOqHXrbLFDAJA78HEXX6/N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2H3KSGY8xX3oOsRhBZeLq8VccUJn5D3ZxL5jRXGHTa7P9HAJTE87T/y5nYBTZc+p
         r4iB7HZ0QYQHwUNxmf9Ut7jE6vUMzXyvXZHbvAw4yZXOXlHRmXFwvKjFnpxXlXNKOs
         Z9/hLJ8x43hOPQeigmrA4pwI6qPtDO6aDpzbmVDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 33/85] audit: CONFIG_CHANGE dont log internal bookkeeping as an event
Date:   Tue, 29 Sep 2020 13:00:00 +0200
Message-Id: <20200929105929.883679131@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Grubb <sgrubb@redhat.com>

[ Upstream commit 70b3eeed49e8190d97139806f6fbaf8964306cdb ]

Common Criteria calls out for any action that modifies the audit trail to
be recorded. That usually is interpreted to mean insertion or removal of
rules. It is not required to log modification of the inode information
since the watch is still in effect. Additionally, if the rule is a never
rule and the underlying file is one they do not want events for, they
get an event for this bookkeeping update against their wishes.

Since no device/inode info is logged at insertion and no device/inode
information is logged on update, there is nothing meaningful being
communicated to the admin by the CONFIG_CHANGE updated_rules event. One
can assume that the rule was not "modified" because it is still watching
the intended target. If the device or inode cannot be resolved, then
audit_panic is called which is sufficient.

The correct resolution is to drop logging config_update events since
the watch is still in effect but just on another unknown inode.

Signed-off-by: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/audit_watch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index f45a9a5d3e47a..af453f3c2b3dd 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -316,8 +316,6 @@ static void audit_update_watch(struct audit_parent *parent,
 			if (oentry->rule.exe)
 				audit_remove_mark(oentry->rule.exe);
 
-			audit_watch_log_rule_change(r, owatch, "updated_rules");
-
 			call_rcu(&oentry->rcu, audit_free_rule_rcu);
 		}
 
-- 
2.25.1



