Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC0427CCDF
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgI2MkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbgI2LQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:16:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE3F206DB;
        Tue, 29 Sep 2020 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378179;
        bh=1A9kQmECskEl4gPJ+6UrYq13lluTiE+z2WhigvhzBpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zetuUP2pFURImGIABe9RjRK120Cia/SnhIibU08BiES/UdZkbAA3KX4QYMEBg3EL
         4RKrvFYwZ/nTaqFXrsGES8Z4wIR6UWXwRSLAVObUdnZK47tVPgt/Pvllp9zqA78IBh
         ofbkeLZpAH6L1MoLRIDC7oGDpGQFuO310+ddlatM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 060/166] audit: CONFIG_CHANGE dont log internal bookkeeping as an event
Date:   Tue, 29 Sep 2020 12:59:32 +0200
Message-Id: <20200929105938.216049161@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
index 35f1d706bd5b4..ac87820cc0825 100644
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



