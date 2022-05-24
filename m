Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641C2532E49
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239314AbiEXQB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiEXQAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:00:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CEEA0D31;
        Tue, 24 May 2022 09:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A649CB81A2B;
        Tue, 24 May 2022 16:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D67C3411D;
        Tue, 24 May 2022 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408019;
        bh=003EFPVAWAtkcipXIjXUvRz6XdQ5O2kKi9sJjDH1Xkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IC+ovL0nDg3sYrxw7fREcYuemoky9I3xbWoB7zboOmVgOipbgeqIs5oF4NcW7dzBv
         qOkNqypAhhInxkSNuUZ7Tp/WKH/5WICJSMfEzhT52UsyM7kcXzQdaGXqOTTkr269Ua
         OwAyZNzAGaPrq/u3amWpZI1Ew2bmnFI6e8Lcz4qKyO4m1g6iC4FNcE1m2x8S0tu6a2
         3W30AtZtTvI5jdyQaWdh8cmvPkYbg8JRR7xBM8RtvAfaBJN0Z8QdNz3MgBHCuzG22v
         0iW7OQgo0fO+p1EPI7viuHFJnsShqh8qeldiGTv3Xnpnh/hz14woggZhTo8gCfRln1
         3DAoLezWf8GxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, dennis@kernel.org,
        tj@kernel.org, cl@linux.com, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.15 05/10] percpu_ref_init(): clean ->percpu_count_ref on failure
Date:   Tue, 24 May 2022 12:00:02 -0400
Message-Id: <20220524160009.826957-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160009.826957-1-sashal@kernel.org>
References: <20220524160009.826957-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

