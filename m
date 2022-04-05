Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBBA4F3121
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245688AbiDEKjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238743AbiDEJcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC7C2709;
        Tue,  5 Apr 2022 02:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2921161654;
        Tue,  5 Apr 2022 09:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E083C385A3;
        Tue,  5 Apr 2022 09:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150398;
        bh=YUCc5UqSEUaFbLJxDPjS3UTbOuylShiOg0+98LUc49c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B99IpNuDbtcSg8RjORkuJmwcD1vKs3ECnJwn/mxUUMKovGZYuNnxk+loWGhcciYe4
         wuhG+axQ7fcQNpQuPF5C/XQqKMZ++OVot4lrvGD5+ZKzXeKlfluD2Qt3mFXL5AoYYk
         MkjeOL/gkdQvItuH5lGwOEw7NMDyhxjpluoXTlB8=
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
Subject: [PATCH 5.15 006/913] mm: kfence: fix missing objcg housekeeping for SLAB
Date:   Tue,  5 Apr 2022 09:17:48 +0200
Message-Id: <20220405070340.002225263@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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


