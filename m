Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E07063DF11
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiK3Snc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiK3SnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B4229CB1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3520CE1AC1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBE5C433D6;
        Wed, 30 Nov 2022 18:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833797;
        bh=fxkHNt3VUaj9XKwTdwha6pmTfeX2A5KLwKypreu4b7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJqKNNRUCd5Zw2YEqv1i2YpPdhwp19PhQATkBkUSbbdj/+1DnO4sd1DJ+CrfLJwgz
         hKExwkxldIGEMvAQwQ00g4o0jkPIaowkHVHFjGvU8hdYMbcG+36S7SDy3hoAthNMbM
         v8QPkONN9MTQNtnSx//bYJFoy1N2eAbgCx3BFKNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kenneth Lee <klee33@uw.edu>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 002/289] ceph: Use kcalloc for allocating multiple elements
Date:   Wed, 30 Nov 2022 19:19:47 +0100
Message-Id: <20221130180544.168034112@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Lee <klee33@uw.edu>

[ Upstream commit aa1d627207cace003163dee24d1c06fa4e910c6b ]

Prefer using kcalloc(a, b) over kzalloc(a * b) as this improves
semantics since kcalloc is intended for allocating an array of memory.

Signed-off-by: Kenneth Lee <klee33@uw.edu>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 53cfe026b3ea..1eb2ff0f6bd8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2285,7 +2285,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 		struct ceph_mds_request *req;
 		int i;
 
-		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
+		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
 		if (!sessions) {
 			err = -ENOMEM;
 			goto out;
-- 
2.35.1



