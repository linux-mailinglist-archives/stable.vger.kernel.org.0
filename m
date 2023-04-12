Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EB66DEEA5
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjDLIoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDLInx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:43:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FD372A2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABBF7630AF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB76C433D2;
        Wed, 12 Apr 2023 08:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288964;
        bh=QXDQ4fKp07JfAMbjgZVFjQtYq5POj2EW3Qsxq/izZSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZdOYjvEmKN91D+ujXw3jGhfR1jJmyUtH+/HDI2LDXbME76dbEShFAcUSAxF6ZZE9
         CcHRmZD8auQUjeTfXqhP2sfP2ZW/lgS6SQrf0Ak8Caf7Ya0W7RmzuM108VdO1iZqXD
         6lQ9jkgzMWl6oHhLi8x5LFHL1pUUxQreWPeH39mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhi Li <yieli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/164] sunrpc: only free unix grouplist after RCU settles
Date:   Wed, 12 Apr 2023 10:32:46 +0200
Message-Id: <20230412082838.723495759@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 5085e41f9e83a1bec51da1f20b54f2ec3a13a3fe ]

While the unix_gid object is rcu-freed, the group_info list that it
contains is not. Ensure that we only put the group list reference once
we are really freeing the unix_gid object.

Reported-by: Zhi Li <yieli@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2183056
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Fixes: fd5d2f78261b ("SUNRPC: Make server side AUTH_UNIX use lockless lookups")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcauth_unix.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index b1efc34db6ed8..609ade4fb49ed 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -416,14 +416,23 @@ static int unix_gid_hash(kuid_t uid)
 	return hash_long(from_kuid(&init_user_ns, uid), GID_HASHBITS);
 }
 
-static void unix_gid_put(struct kref *kref)
+static void unix_gid_free(struct rcu_head *rcu)
 {
-	struct cache_head *item = container_of(kref, struct cache_head, ref);
-	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+	struct unix_gid *ug = container_of(rcu, struct unix_gid, rcu);
+	struct cache_head *item = &ug->h;
+
 	if (test_bit(CACHE_VALID, &item->flags) &&
 	    !test_bit(CACHE_NEGATIVE, &item->flags))
 		put_group_info(ug->gi);
-	kfree_rcu(ug, rcu);
+	kfree(ug);
+}
+
+static void unix_gid_put(struct kref *kref)
+{
+	struct cache_head *item = container_of(kref, struct cache_head, ref);
+	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+
+	call_rcu(&ug->rcu, unix_gid_free);
 }
 
 static int unix_gid_match(struct cache_head *corig, struct cache_head *cnew)
-- 
2.39.2



