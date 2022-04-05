Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BDD4F3541
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343590AbiDEI5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241901AbiDEIf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:35:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233B417AAD;
        Tue,  5 Apr 2022 01:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F50CB81A32;
        Tue,  5 Apr 2022 08:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC046C385A0;
        Tue,  5 Apr 2022 08:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147536;
        bh=YUCc5UqSEUaFbLJxDPjS3UTbOuylShiOg0+98LUc49c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QODScXiQvD01BKjqcjD9YjA00zYoSUHyouef5h2IlAEsxIL1wXNWRfqAUnksbae58
         HfIhq5fc6jSz30fdCEMsAmVCfVLpZyU1xF56vuBBIWbG6sDs0jxxBjweq21vsVws5y
         fSszPHX+yAJOa8xjNJJrE9n43s4p8mxzcF7fIN5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f8c45ccc7d5d45fc5965@syzkaller.appspotmail.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 0006/1017] mm: kfence: fix missing objcg housekeeping for SLAB
Date:   Tue,  5 Apr 2022 09:15:19 +0200
Message-Id: <20220405070354.358398291@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

commit ae085d7f9365de7da27ab5c0d16b12d51ea7fca9 upstream.

The objcg is not cleared and put for kfence object when it is freed,
which could lead to memory leak for struct obj_cgroup and wrong
statistics of NR_SLAB_RECLAIMABLE_B or NR_SLAB_UNRECLAIMABLE_B.

Since the last freed object's objcg is not cleared,
mem_cgroup_from_obj() could return the wrong memcg when this kfence
object, which is not charged to any objcgs, is reallocated to other
users.

A real word issue [1] is caused by this bug.

Link: https://lore.kernel.org/all/000000000000cabcb505dae9e577@google.com/ [1]
Reported-by: syzbot+f8c45ccc7d5d45fc5965@syzkaller.appspotmail.com
Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3429,6 +3429,7 @@ static __always_inline void __cache_free
 
 	if (is_kfence_address(objp)) {
 		kmemleak_free_recursive(objp, cachep->flags);
+		memcg_slab_free_hook(cachep, &objp, 1);
 		__kfence_free(objp);
 		return;
 	}


