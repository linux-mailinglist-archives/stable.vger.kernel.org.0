Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D681A53CF17
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345420AbiFCRwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345890AbiFCRuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F15562E4;
        Fri,  3 Jun 2022 10:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A0B660A24;
        Fri,  3 Jun 2022 17:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4BAC385A9;
        Fri,  3 Jun 2022 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278391;
        bh=dpH0iACmdZliwu7JPRo+bUchXXFIwcB3x+lHvB7xBxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3bwi/X9thv2YiLcr7xsmaw7QhIi27EvjXsSBwHXA+iqDom1MfTqHZsa0zKDyyTur
         Sg3hDS7PlfdB/ZhXrLnIx+wxcHlr77fK22Kz+CmJaYTlJ0lkjGVw1n99qwMIfTohsS
         w52K+GZRntVL2L4PhIh+0DEFDNCdxi0NqBB78BlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/53] percpu_ref_init(): clean ->percpu_count_ref on failure
Date:   Fri,  3 Jun 2022 19:42:47 +0200
Message-Id: <20220603173818.789968820@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
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



