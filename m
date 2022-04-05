Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBE04F26C4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiDEIFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiDEH6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDCA98F74;
        Tue,  5 Apr 2022 00:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61366B81B90;
        Tue,  5 Apr 2022 07:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7C5C34110;
        Tue,  5 Apr 2022 07:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145116;
        bh=6rWeWZOC3ktBYreoC88HJB7ZluW+5NlAEBSobv0dqyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1SC5foyPbx6qQEQnSHbL44DmpJ0qTTCU7FQzkt2sEs2EiEB6YwT6o2HIEniFg8ue
         fwIm/Wf+rCC06JwFR0STxSA/lvx+IW+VVa/0DPi1STZ6mc5ByYGFYSLRQkxe53mdHp
         Nx7Qk/Ejizbw3sJf6Wi4l3saTQQyXTU24kPwh2OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0289/1126] drivers/base/memory: add memory block to memory group after registration succeeded
Date:   Tue,  5 Apr 2022 09:17:16 +0200
Message-Id: <20220405070416.096535710@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 7ea0d2d79da09d1f7d71c96a9c9bc1b5229360b5 ]

If register_memory() fails, we freed the memory block but already added
the memory block to the group list, not good.  Let's defer adding the
block to the memory group to after registering the memory block device.

We do handle it properly during unregister_memory(), but that's not
called when the registration fails.

Link: https://lkml.kernel.org/r/20220128144540.153902-1-david@redhat.com
Fixes: 028fc57a1c36 ("drivers/base/memory: introduce "memory groups" to logically group memory blocks")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 365cd4a7f239..60c38f9cf1a7 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -663,14 +663,16 @@ static int init_memory_block(unsigned long block_id, unsigned long state,
 	mem->nr_vmemmap_pages = nr_vmemmap_pages;
 	INIT_LIST_HEAD(&mem->group_next);
 
+	ret = register_memory(mem);
+	if (ret)
+		return ret;
+
 	if (group) {
 		mem->group = group;
 		list_add(&mem->group_next, &group->memory_blocks);
 	}
 
-	ret = register_memory(mem);
-
-	return ret;
+	return 0;
 }
 
 static int add_memory_block(unsigned long base_section_nr)
-- 
2.34.1



