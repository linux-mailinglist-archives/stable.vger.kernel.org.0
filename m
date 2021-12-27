Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669014803DA
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhL0TF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:05:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40830 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbhL0TF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:05:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 742B760FB3;
        Mon, 27 Dec 2021 19:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E962DC36AEC;
        Mon, 27 Dec 2021 19:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631926;
        bh=gde+0MGjiDKzg9yAHZB053ZG7CKZtiptNN9QN03QLMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcTHuXl30F0DFde2A8j6TykITQVuXY2B6i79Q8wbLjTIQ7LRac8XgLnzgUdYHm9aK
         BIcC29jM3l6HgtqiLZeQDxvR59hTTWmYwuHGnJvlvfbPPVL53iJV5/1f5Q8UtWlyGm
         Ss9b1lQZZwSWxeGaeUDER3TM/70g7nbRws9UMUaVG56eIuNNDNTWbShBZG8wwv4qph
         hTd3FpWabZhMpDZ168RjHCkyvEBKo0q0oNsaZUXv2zrQPlvm4L/jxgZn0gHNtAxQ+Q
         NahgDY+F5oJ280M775PH8sAmq8QrwtGG6AG76zXcncVlN1QuRN+RP5BF4BSWm5k1Nn
         EQBcn6Tw/zr5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>, takedakn@nttdata.co.jp,
        jmorris@namei.org, serge@hallyn.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/14] tomoyo: use hwight16() in tomoyo_domain_quota_is_ok()
Date:   Mon, 27 Dec 2021 14:04:47 -0500
Message-Id: <20211227190452.1042714-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190452.1042714-1-sashal@kernel.org>
References: <20211227190452.1042714-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

