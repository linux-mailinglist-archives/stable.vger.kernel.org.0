Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFF06DD030
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjDKDaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjDKDaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:30:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F0C212F;
        Mon, 10 Apr 2023 20:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7EDE620D4;
        Tue, 11 Apr 2023 03:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA24C433EF;
        Tue, 11 Apr 2023 03:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681183797;
        bh=e0INewHg+IAWunSFE0ZuZUkLF87/Vemb0s4FjQycHCA=;
        h=Date:To:From:Subject:From;
        b=vmsyxanz5QaGl07bFPyR9nBBS0I3fVMYm3rqejqJ3u9v07IOBaVF/ZM7inKozucOZ
         7ztIaEvInRT59tsq4e5gcq84mAfVGCp3FUKbR+YmC3HVCK7/0jW/GJnHL4akovqMTe
         F2o84CTQX+G65AV/8c7NwsG02NC4ONPpRo+aiIj8=
Date:   Mon, 10 Apr 2023 20:29:56 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, dcb314@hotmail.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-correct-variable-type-in-sizeof.patch added to mm-hotfixes-unstable branch
Message-Id: <20230411032957.3AA24C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: maple_tree: use correct variable type in sizeof
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-use-correct-variable-type-in-sizeof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-correct-variable-type-in-sizeof.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: use correct variable type in sizeof
Date: Tue, 11 Apr 2023 10:35:13 +0800

The type of variable pointed to by pivs is unsigned long, but the type
used in sizeof is a pointer type. Change it to unsigned long.

Link: https://lkml.kernel.org/r/20230411023513.15227-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-correct-variable-type-in-sizeof
+++ a/lib/maple_tree.c
@@ -3279,7 +3279,7 @@ static inline void mas_destroy_rebalance
 
 		if (tmp < max_p)
 			memset(pivs + tmp, 0,
-			       sizeof(unsigned long *) * (max_p - tmp));
+			       sizeof(unsigned long) * (max_p - tmp));
 
 		if (tmp < mt_slots[mt])
 			memset(slots + tmp, 0, sizeof(void *) * (max_s - tmp));
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch
maple_tree-use-correct-variable-type-in-sizeof.patch
mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-add-a-test-case-to-check-maple_alloc.patch

