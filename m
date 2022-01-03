Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0DB483342
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiACOf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234734AbiACOdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:33:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E88DC08E845;
        Mon,  3 Jan 2022 06:32:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3FCAB80F10;
        Mon,  3 Jan 2022 14:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E7DC36AED;
        Mon,  3 Jan 2022 14:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220320;
        bh=e6+pXrEBPpHq42k1fiqzkjtZ/G+OfbbfNM0/EKa6+YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R87VQf6K7YgMM1ODI7IF97CwOc5iRKomRbNRteeeHLatl/Vf57w72R69rmkfuJ9JK
         wDLvdG5J5JF+1g6uMwCWqsMEXp2yTLlUYic/L0TvQNc2L5kzwtqSMDoccUW0e2x47A
         ECbGffI427WMsrIde8p6tan022wAGMfmZVSYp23s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/73] tomoyo: use hwight16() in tomoyo_domain_quota_is_ok()
Date:   Mon,  3 Jan 2022 15:23:25 +0100
Message-Id: <20220103142057.059476654@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
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
index af8cd2af3466d..6799b1122c9d8 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -1056,7 +1056,6 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list,
 				srcu_read_lock_held(&tomoyo_ss)) {
 		u16 perm;
-		u8 i;
 
 		if (ptr->is_deleted)
 			continue;
@@ -1067,23 +1066,23 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
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
@@ -1091,9 +1090,7 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
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



