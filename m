Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18FA26F0F9
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIRCrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgIRCJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146FA23770;
        Fri, 18 Sep 2020 02:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394970;
        bh=7PWxJ2DjwJblVKEIRQXBa7nuPNBbxj/XlqvELehCn4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwSMVCc4yx7sEVZK91dz8l+K9xLbidT0mnWjKTypHyrhrVnOOpcKFdQM5BK3fpCou
         QDKEDg6aQxmPBKDn/SWtFHW9y2V3YPhIadUkK9TCi69PrPgCJh7cu9Hiq7zkaHgK/m
         9L7w92CJqSEURC1tDw2dE+AavzYmtt4aIH6grq54=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Grubb <sgrubb@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, linux-audit@redhat.com
Subject: [PATCH AUTOSEL 4.19 072/206] audit: CONFIG_CHANGE don't log internal bookkeeping as an event
Date:   Thu, 17 Sep 2020 22:05:48 -0400
Message-Id: <20200918020802.2065198-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4f7262eba73d8..50952d6d81209 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -317,8 +317,6 @@ static void audit_update_watch(struct audit_parent *parent,
 			if (oentry->rule.exe)
 				audit_remove_mark(oentry->rule.exe);
 
-			audit_watch_log_rule_change(r, owatch, "updated_rules");
-
 			call_rcu(&oentry->rcu, audit_free_rule_rcu);
 		}
 
-- 
2.25.1

