Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADAD4F2559
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiDEHtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbiDEHrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0CC9D066;
        Tue,  5 Apr 2022 00:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3A7DB81BB2;
        Tue,  5 Apr 2022 07:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE53C34110;
        Tue,  5 Apr 2022 07:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144595;
        bh=iTOfois0ZYqCKY2NqBrvbMomRaXgDpO4cM8qbhCxGl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Y1O/F0bPaSM1ke7IKNa6LxY2+qQ3UQ2LSA9wgfu6nJ9YP9+avlS2rJAPQdeQ3yKJ
         vH8IgeJDhYftu1PQJgXa6kcIwa0oLjsh6FG2At7Z4Ma1OHscuqH+3Q4yN7sXC3zHpN
         5oeBgxN/gSa0p+0yRU8In1l5soSWF0277LvqAb5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.17 0063/1126] mm/mlock: fix two bugs in user_shm_lock()
Date:   Tue,  5 Apr 2022 09:13:30 +0200
Message-Id: <20220405070409.420000846@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit e97824ff663ce3509fe040431c713182c2f058b1 upstream.

user_shm_lock forgets to set allowed to 0 when get_ucounts fails. So the
later user_shm_unlock might do the extra dec_rlimit_ucounts. Also in the
RLIM_INFINITY case, user_shm_lock will success regardless of the value of
memlock where memblock == LONG_MAX && !capable(CAP_IPC_LOCK) should fail.
Fix all of these by changing the code to leave lock_limit at ULONG_MAX aka
RLIM_INFINITY, leave "allowed" initialized to 0 and remove the special case
of RLIM_INFINITY as nothing can be greater than ULONG_MAX.

Credit goes to Eric W. Biederman for proposing simplifying the code and
thus catching the later bug.

Fixes: d7c9e99aee48 ("Reimplement RLIMIT_MEMLOCK on top of ucounts")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: stable@vger.kernel.org
v1: https://lkml.kernel.org/r/20220310132417.41189-1-linmiaohe@huawei.com
v2: https://lkml.kernel.org/r/20220314064039.62972-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220322080918.59861-1-linmiaohe@huawei.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mlock.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -827,13 +827,12 @@ int user_shm_lock(size_t size, struct uc
 
 	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
-	if (lock_limit == RLIM_INFINITY)
-		allowed = 1;
-	lock_limit >>= PAGE_SHIFT;
+	if (lock_limit != RLIM_INFINITY)
+		lock_limit >>= PAGE_SHIFT;
 	spin_lock(&shmlock_user_lock);
 	memlock = inc_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
 
-	if (!allowed && (memlock == LONG_MAX || memlock > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	if ((memlock == LONG_MAX || memlock > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
 		goto out;
 	}


