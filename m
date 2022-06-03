Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AF753CFD4
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345753AbiFCR5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345049AbiFCRyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:54:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105BE43ED9;
        Fri,  3 Jun 2022 10:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20119611F3;
        Fri,  3 Jun 2022 17:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DD7C385A9;
        Fri,  3 Jun 2022 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278771;
        bh=003EFPVAWAtkcipXIjXUvRz6XdQ5O2kKi9sJjDH1Xkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtHGhe2iIKTDd3jIhHQr1LI3hoSvKp7kDv8F/M839pWE0yvfLggbxXrICQ284IVbJ
         VO8OVJaRjI6z/OCVans1dER/fd+Jmq7NQ19JjTlq9dN7PQSM1jCIeBTWsbMBvxob/9
         EXyQogBJY81TBGGpf1ozf6nESiUQj2D07FN2scWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 06/75] percpu_ref_init(): clean ->percpu_count_ref on failure
Date:   Fri,  3 Jun 2022 19:42:50 +0200
Message-Id: <20220603173821.931147182@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit a91714312eb16f9ecd1f7f8b3efe1380075f28d4 ]

That way percpu_ref_exit() is safe after failing percpu_ref_init().
At least one user (cgroup_create()) had a double-free that way;
there might be other similar bugs.  Easier to fix in percpu_ref_init(),
rather than playing whack-a-mole in sloppy users...

Usual symptoms look like a messed refcounting in one of subsystems
that use percpu allocations (might be percpu-refcount, might be
something else).  Having refcounts for two different objects share
memory is Not Nice(tm)...

Reported-by: syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/percpu-refcount.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index af9302141bcf..e5c5315da274 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -76,6 +76,7 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 	data = kzalloc(sizeof(*ref->data), gfp);
 	if (!data) {
 		free_percpu((void __percpu *)ref->percpu_count_ptr);
+		ref->percpu_count_ptr = 0;
 		return -ENOMEM;
 	}
 
-- 
2.35.1



