Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBAE4F2EAC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347660AbiDEJ2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244756AbiDEIwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E030DFB3;
        Tue,  5 Apr 2022 01:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23C60609D0;
        Tue,  5 Apr 2022 08:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B61DC385A0;
        Tue,  5 Apr 2022 08:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148210;
        bh=6rWeWZOC3ktBYreoC88HJB7ZluW+5NlAEBSobv0dqyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1G3KapPe3gNRLLPToJaTprNcP02D0flenlCGX3yM771/HxzjzxlrtrH1ZwirBqePi
         OLDUQj++P2REEEXRv8A+y9fSdBjDItJq+YVXR1AFevRx72DyD0MzzBo9fclb/m3DgA
         rSAJ7UPOp2IcoUdqYSIrocGzYV3I2xBhGcT7Bn7o=
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
Subject: [PATCH 5.16 0275/1017] drivers/base/memory: add memory block to memory group after registration succeeded
Date:   Tue,  5 Apr 2022 09:19:48 +0200
Message-Id: <20220405070402.429332890@linuxfoundation.org>
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



