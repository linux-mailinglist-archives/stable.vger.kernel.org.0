Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C142C4FD72C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiDLHTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351658AbiDLHMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2739129829;
        Mon, 11 Apr 2022 23:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B98636149D;
        Tue, 12 Apr 2022 06:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBE6C385A8;
        Tue, 12 Apr 2022 06:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746260;
        bh=PYLZrxg0aezzpobDXdHRgrI8u0w+vJG252MHRYdhv/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5IWT7Q2Kg+g8Wt3BqVGEVsaM30h6ofoSfdkKGf49zC5DsP3XMZynXvFU+8AbXukJ
         dxhBTMp21ClHJrMqiy83KxDS+ZtftzXoyL8ZXr4teKGmfCRkiSEOua7b/iOV0t5J4A
         JV/NcToHWNzcCINvok8oShV6UHE8V9rdeZjDPU6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 217/277] mm/mempolicy: fix mpol_new leak in shared_policy_replace
Date:   Tue, 12 Apr 2022 08:30:20 +0200
Message-Id: <20220412062948.320606515@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
@@ -2561,6 +2561,7 @@ alloc_new:
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
 		goto err_out;
+	atomic_set(&mpol_new->refcnt, 1);
 	goto restart;
 }
 


