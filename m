Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616121A597E
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgDKXIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbgDKXIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 163DF20787;
        Sat, 11 Apr 2020 23:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646494;
        bh=6ujQpcxIGithtYCTLKGJdniW/4CHxY9NdvXu1hLNzmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkSfLtQm4EJ3UrEhxjS01KvuOX9Vm7xrIShz8fw8Tg2zYqSQNT36hbbuvekGaHO2A
         SVrWH3gWhFH6cFI6FcX1CnMt1UlpWxYaXHszDc/+lc0rRg+CuB4QaycB0gF3MklvrJ
         bi4QCF43QDwI0XccFXed52eKn1j8tPQb0xj1VgDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Grubb <sgrubb@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, linux-audit@redhat.com
Subject: [PATCH AUTOSEL 5.5 057/121] audit: CONFIG_CHANGE don't log internal bookkeeping as an event
Date:   Sat, 11 Apr 2020 19:06:02 -0400
Message-Id: <20200411230706.23855-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index 4508d5e0cf696..8a8fd732ff6d0 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -302,8 +302,6 @@ static void audit_update_watch(struct audit_parent *parent,
 			if (oentry->rule.exe)
 				audit_remove_mark(oentry->rule.exe);
 
-			audit_watch_log_rule_change(r, owatch, "updated_rules");
-
 			call_rcu(&oentry->rcu, audit_free_rule_rcu);
 		}
 
-- 
2.20.1

