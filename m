Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF41323DC8
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhBXNSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234112AbhBXNIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D93464F10;
        Wed, 24 Feb 2021 12:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171300;
        bh=rxFk4IJfwyIsOo132xiwLCKmsrp6jZ81JqfH0aKVHcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXeLHB4WptHYyg5ZQLg6530y+VmCiPT8snj8mJ2t7b8YR3ortOGoImrt2ldEQyVh6
         VTQdl0wmg0wU9lzVYCXTsXgDhmjFdXCww4qudAvPI6a7YOOqvFDTM3v7tCNTRkcQAa
         k3wwPlNru8O2QAbeESufr8w8D24C8Oqx9Dp9CLSFdLtIc7OpNl3/pVVwQLHu/RfHrR
         dP+K0gQNGmnmKMqTPqQMeglNwz4mOLrd2556MJgNaX94HbaIb6tf1xphqiBPmho7y5
         Us44VgFrFsL6SB7Q5Ar+Vg11yn1pZntsuAuYcj6zAiRLsO32gTNDjsksq65QW4H9xS
         ZXLpuF2QrE/ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+0789a72b46fd91431bd8@syzkaller.appspotmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/26] tomoyo: ignore data race while checking quota
Date:   Wed, 24 Feb 2021 07:54:27 -0500
Message-Id: <20210224125435.483539-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125435.483539-1-sashal@kernel.org>
References: <20210224125435.483539-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 5797e861e402fff2bedce4ec8b7c89f4248b6073 ]

syzbot is reporting that tomoyo's quota check is racy [1]. But this check
is tolerant of some degree of inaccuracy. Thus, teach KCSAN to ignore
this data race.

[1] https://syzkaller.appspot.com/bug?id=999533deec7ba6337f8aa25d8bd1a4d5f7e50476

Reported-by: syzbot <syzbot+0789a72b46fd91431bd8@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/file.c    | 16 ++++++++--------
 security/tomoyo/network.c |  8 ++++----
 security/tomoyo/util.c    | 24 ++++++++++++------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/security/tomoyo/file.c b/security/tomoyo/file.c
index 2a374b4da8f5c..cbe0dc87bb919 100644
--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -356,13 +356,13 @@ static bool tomoyo_merge_path_acl(struct tomoyo_acl_info *a,
 {
 	u16 * const a_perm = &container_of(a, struct tomoyo_path_acl, head)
 		->perm;
-	u16 perm = *a_perm;
+	u16 perm = READ_ONCE(*a_perm);
 	const u16 b_perm = container_of(b, struct tomoyo_path_acl, head)->perm;
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -428,14 +428,14 @@ static bool tomoyo_merge_mkdev_acl(struct tomoyo_acl_info *a,
 {
 	u8 *const a_perm = &container_of(a, struct tomoyo_mkdev_acl,
 					 head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_mkdev_acl, head)
 		->perm;
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -505,13 +505,13 @@ static bool tomoyo_merge_path2_acl(struct tomoyo_acl_info *a,
 {
 	u8 * const a_perm = &container_of(a, struct tomoyo_path2_acl, head)
 		->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_path2_acl, head)->perm;
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -640,14 +640,14 @@ static bool tomoyo_merge_path_number_acl(struct tomoyo_acl_info *a,
 {
 	u8 * const a_perm = &container_of(a, struct tomoyo_path_number_acl,
 					  head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_path_number_acl, head)
 		->perm;
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
diff --git a/security/tomoyo/network.c b/security/tomoyo/network.c
index 9094f4b3b367b..2ea0da6e5180f 100644
--- a/security/tomoyo/network.c
+++ b/security/tomoyo/network.c
@@ -233,14 +233,14 @@ static bool tomoyo_merge_inet_acl(struct tomoyo_acl_info *a,
 {
 	u8 * const a_perm =
 		&container_of(a, struct tomoyo_inet_acl, head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_inet_acl, head)->perm;
 
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
@@ -259,14 +259,14 @@ static bool tomoyo_merge_unix_acl(struct tomoyo_acl_info *a,
 {
 	u8 * const a_perm =
 		&container_of(a, struct tomoyo_unix_acl, head)->perm;
-	u8 perm = *a_perm;
+	u8 perm = READ_ONCE(*a_perm);
 	const u8 b_perm = container_of(b, struct tomoyo_unix_acl, head)->perm;
 
 	if (is_delete)
 		perm &= ~b_perm;
 	else
 		perm |= b_perm;
-	*a_perm = perm;
+	WRITE_ONCE(*a_perm, perm);
 	return !perm;
 }
 
diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
index d3d9d9f1edb04..16d488f963b12 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -1020,30 +1020,30 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 		u8 i;
 		if (ptr->is_deleted)
 			continue;
+		/*
+		 * Reading perm bitmap might race with tomoyo_merge_*() because
+		 * caller does not hold tomoyo_policy_lock mutex. But exceeding
+		 * max_learning_entry parameter by a few entries does not harm.
+		 */
 		switch (ptr->type) {
 		case TOMOYO_TYPE_PATH_ACL:
-			perm = container_of(ptr, struct tomoyo_path_acl, head)
-				->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_path_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_PATH2_ACL:
-			perm = container_of(ptr, struct tomoyo_path2_acl, head)
-				->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_path2_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_PATH_NUMBER_ACL:
-			perm = container_of(ptr, struct tomoyo_path_number_acl,
-					    head)->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_path_number_acl, head)
+				  ->perm);
 			break;
 		case TOMOYO_TYPE_MKDEV_ACL:
-			perm = container_of(ptr, struct tomoyo_mkdev_acl,
-					    head)->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_mkdev_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_INET_ACL:
-			perm = container_of(ptr, struct tomoyo_inet_acl,
-					    head)->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_inet_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_UNIX_ACL:
-			perm = container_of(ptr, struct tomoyo_unix_acl,
-					    head)->perm;
+			data_race(perm = container_of(ptr, struct tomoyo_unix_acl, head)->perm);
 			break;
 		case TOMOYO_TYPE_MANUAL_TASK_ACL:
 			perm = 0;
-- 
2.27.0

