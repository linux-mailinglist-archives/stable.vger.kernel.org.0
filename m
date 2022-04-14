Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA0E5010BA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244968AbiDNNh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344265AbiDNNb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:31:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9541B6;
        Thu, 14 Apr 2022 06:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 912AA619FC;
        Thu, 14 Apr 2022 13:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BB6C385A5;
        Thu, 14 Apr 2022 13:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942943;
        bh=siseCTkTn/p2uQp13G4IuVZzWPFcKD/bxA1MpmnAmr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=difMpS9LR54J7wqQHxbuPZAmoZ2q56N0aNumK3C8cIN0yUcwG3zPg0A4qeEAodLtb
         0i+QX0V5ZqNFmrRUkcCDTWN2ndVB/BS9DaGSc9dKh9ktaXT+m+osxcbYlDjNMBDOXb
         By0zONjtZgNySRXCIluL9Z2BwH4S7ERLSWxtqhqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 316/338] mm/mempolicy: fix mpol_new leak in shared_policy_replace
Date:   Thu, 14 Apr 2022 15:13:39 +0200
Message-Id: <20220414110847.881434205@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

commit 4ad099559b00ac01c3726e5c95dc3108ef47d03e upstream.

If mpol_new is allocated but not used in restart loop, mpol_new will be
freed via mpol_put before returning to the caller.  But refcnt is not
initialized yet, so mpol_put could not do the right things and might
leak the unused mpol_new.  This would happen if mempolicy was updated on
the shared shmem file while the sp->lock has been dropped during the
memory allocation.

This issue could be triggered easily with the below code snippet if
there are many processes doing the below work at the same time:

  shmid = shmget((key_t)5566, 1024 * PAGE_SIZE, 0666|IPC_CREAT);
  shm = shmat(shmid, 0, 0);
  loop many times {
    mbind(shm, 1024 * PAGE_SIZE, MPOL_LOCAL, mask, maxnode, 0);
    mbind(shm + 128 * PAGE_SIZE, 128 * PAGE_SIZE, MPOL_DEFAULT, mask,
          maxnode, 0);
  }

Link: https://lkml.kernel.org/r/20220329111416.27954-1-linmiaohe@huawei.com
Fixes: 42288fe366c4 ("mm: mempolicy: Convert shared_policy mutex to spinlock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>	[3.8]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2563,6 +2563,7 @@ alloc_new:
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
 		goto err_out;
+	atomic_set(&mpol_new->refcnt, 1);
 	goto restart;
 }
 


