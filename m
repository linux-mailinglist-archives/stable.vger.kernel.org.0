Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D632B621433
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiKHN6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiKHN62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:58:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A9F1169
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94034B816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87556C433D6;
        Tue,  8 Nov 2022 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915904;
        bh=W6j01F9EMX/Hx3k89AF5Ezv1f7O76wGyyFDJEEXqJqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfGe8JRzGo7NSikSk5RbDQviKxFYp1r7VoQ6on4iuri3yunpIgXqY7aTh+wbstJX2
         ZGZHW3Z7Jc1VztDHUzstUZERHgKkoFONxvc6309Q2H9hTnwfaGCJ7UCEbhk5870Ewb
         E3Uhj3ERIPTSWBI9ZHMEJNSekIV9qqNPvkfYoCYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Averin <vvs@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 118/118] ipc: remove memcg accounting for sops objects in do_semtimedop()
Date:   Tue,  8 Nov 2022 14:39:56 +0100
Message-Id: <20221108133345.796855939@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Vasily Averin <vvs@virtuozzo.com>

commit 6a4746ba06191e23d30230738e94334b26590a8a upstream.

Linus proposes to revert an accounting for sops objects in
do_semtimedop() because it's really just a temporary buffer
for a single semtimedop() system call.

This object can consume up to 2 pages, syscall is sleeping
one, size and duration can be controlled by user, and this
allocation can be repeated by many thread at the same time.

However Shakeel Butt pointed that there are much more popular
objects with the same life time and similar memory
consumption, the accounting of which was decided to be
rejected for performance reasons.

Considering at least 2 pages for task_struct and 2 pages for
the kernel stack, a back of the envelope calculation gives a
footprint amplification of <1.5 so this temporal buffer can be
safely ignored.

The factor would IMO be interesting if it was >> 2 (from the
PoV of excessive (ab)use, fine-grained accounting seems to be
currently unfeasible due to performance impact).

Link: https://lore.kernel.org/lkml/90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com/
Fixes: 18319498fdd4 ("memcg: enable accounting of ipc resources")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/sem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2001,8 +2001,7 @@ static long do_semtimedop(int semid, str
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops),
-				      GFP_KERNEL_ACCOUNT);
+		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
 		if (sops == NULL)
 			return -ENOMEM;
 	}


