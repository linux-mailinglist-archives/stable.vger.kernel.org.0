Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F6A532E40
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239484AbiEXQCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiEXQBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:01:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04E89D052;
        Tue, 24 May 2022 09:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 822ED61755;
        Tue, 24 May 2022 16:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F06C34116;
        Tue, 24 May 2022 16:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408043;
        bh=dpH0iACmdZliwu7JPRo+bUchXXFIwcB3x+lHvB7xBxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fh50cMdnCmdoOXsUFOGvMISx/g4v82vvuopO8vxhsesr0zbJey4GTd/NJroB649D/
         3UgbBgy+xdkAclFJloOMzMwxflg7jU2TnH2WdR1HBp3NSCDxVpowSn4BggPemhS089
         g6Cdt7rXaz5QYQDKOvgbm1o/C1a2p/+v/U1Z36gomoT/8MQsfNSOzsyuqUHwsVr/bf
         csrw6VW0ALXhoTjEPzokX23KkuaCl47yvFld+afUFttmAQ5EHAdC0XCwFXsH0QiZoE
         h0CZL3UU84TZGBCCZ77FV6ubS4geu2HUeOoZlNu+cgvDcOdjgcT9CWNWkK9j13Uf9U
         QFS+qyhJzL8GA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, dennis@kernel.org,
        tj@kernel.org, cl@linux.com, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.10 3/8] percpu_ref_init(): clean ->percpu_count_ref on failure
Date:   Tue, 24 May 2022 12:00:30 -0400
Message-Id: <20220524160035.827109-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160035.827109-1-sashal@kernel.org>
References: <20220524160035.827109-1-sashal@kernel.org>
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
index e59eda07305e..493093b97093 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -75,6 +75,7 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 	data = kzalloc(sizeof(*ref->data), gfp);
 	if (!data) {
 		free_percpu((void __percpu *)ref->percpu_count_ptr);
+		ref->percpu_count_ptr = 0;
 		return -ENOMEM;
 	}
 
-- 
2.35.1

