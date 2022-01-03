Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6C24832C2
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiACOan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59122 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiACO3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A7796110F;
        Mon,  3 Jan 2022 14:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E81FC36AEB;
        Mon,  3 Jan 2022 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220139;
        bh=gde+0MGjiDKzg9yAHZB053ZG7CKZtiptNN9QN03QLMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=us+qRi0lXOGJYn8iqj4hYTTwkEGIL/5rB5Qxu5XsIXe90TybpMqIBBjff1MG17ZxX
         5VB9rWmI2YzCseA4UoTis994XjNs5XEsjn+rFEDCLQqxiddxXrN9pozxONfr9gqgrv
         kBqYf7X7LX8oEfPFkRo6SOePEdDtkUFqDtSpTvh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/48] tomoyo: use hwight16() in tomoyo_domain_quota_is_ok()
Date:   Mon,  3 Jan 2022 15:23:41 +0100
Message-Id: <20220103142053.635397905@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit f702e1107601230eec707739038a89018ea3468d ]

hwight16() is much faster. While we are at it, no need to include
"perm =" part into data_race() macro, for perm is a local variable
that cannot be accessed by other threads.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/util.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
index ee9c2aa0c8df9..11dd8260c9cc7 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -1051,7 +1051,6 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list,
 				srcu_read_lock_held(&tomoyo_ss)) {
 		u16 perm;
-		u8 i;
 
 		if (ptr->is_deleted)
 			continue;
@@ -1062,23 +1061,23 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 		 */
 		switch (ptr->type) {
 		case TOMOYO_TYPE_PATH_ACL:
-			data_race(perm = container_of(ptr, struct tomoyo_path_acl, head)->perm);
+			perm = data_race(container_of(ptr, struct tomoyo_path_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_PATH2_ACL:
-			data_race(perm = container_of(ptr, struct tomoyo_path2_acl, head)->perm);
+			perm = data_race(container_of(ptr, struct tomoyo_path2_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_PATH_NUMBER_ACL:
-			data_race(perm = container_of(ptr, struct tomoyo_path_number_acl, head)
+			perm = data_race(container_of(ptr, struct tomoyo_path_number_acl, head)
 				  ->perm);
 			break;
 		case TOMOYO_TYPE_MKDEV_ACL:
-			data_race(perm = container_of(ptr, struct tomoyo_mkdev_acl, head)->perm);
+			perm = data_race(container_of(ptr, struct tomoyo_mkdev_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_INET_ACL:
-			data_race(perm = container_of(ptr, struct tomoyo_inet_acl, head)->perm);
+			perm = data_race(container_of(ptr, struct tomoyo_inet_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_UNIX_ACL:
-			data_race(perm = container_of(ptr, struct tomoyo_unix_acl, head)->perm);
+			perm = data_race(container_of(ptr, struct tomoyo_unix_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_MANUAL_TASK_ACL:
 			perm = 0;
@@ -1086,9 +1085,7 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 		default:
 			perm = 1;
 		}
-		for (i = 0; i < 16; i++)
-			if (perm & (1 << i))
-				count++;
+		count += hweight16(perm);
 	}
 	if (count < tomoyo_profile(domain->ns, domain->profile)->
 	    pref[TOMOYO_PREF_MAX_LEARNING_ENTRY])
-- 
2.34.1



