Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9498A540706
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347631AbiFGRlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348560AbiFGRlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B3B120890;
        Tue,  7 Jun 2022 10:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5226961543;
        Tue,  7 Jun 2022 17:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D1CC385A5;
        Tue,  7 Jun 2022 17:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623208;
        bh=5nof6Jt2ksDAMb5Ln0YlWKqlrv9Jw3OM28OWQlEtXTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVk8bJNpXyKctqTipWE1xcDgv2VeVQ5Bva0UonvtcbZFOecFvQLwSfIckBcH2blnk
         tKr7Nto7LH99/3GdklCpJ/WVs98sOKuVdh905/i6bmnZFN66p+T6oXEtx/e35SBs2e
         GHoy+hohh0eFQ+/Yy/xczjSoGg1+UMnptH50WkQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Scott Cheloha <cheloha@linux.vnet.ibm.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/452] drivers/base/memory: fix an unlikely reference counting issue in __add_memory_block()
Date:   Tue,  7 Jun 2022 19:02:30 +0200
Message-Id: <20220607164917.284771638@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f47f758cff59c68015d6b9b9c077110df7c2c828 ]

__add_memory_block() calls both put_device() and device_unregister() when
storing the memory block into the xarray.  This is incorrect because
xarray doesn't take an additional reference and device_unregister()
already calls put_device().

Triggering the issue looks really unlikely and its only effect should be
to log a spurious warning about a ref counted issue.

Link: https://lkml.kernel.org/r/d44c63d78affe844f020dc02ad6af29abc448fc4.1650611702.git.christophe.jaillet@wanadoo.fr
Fixes: 4fb6eabf1037 ("drivers/base/memory.c: cache memory blocks in xarray to accelerate lookup")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Scott Cheloha <cheloha@linux.vnet.ibm.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index de058d15b33e..49eb14271f28 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -560,10 +560,9 @@ int register_memory(struct memory_block *memory)
 	}
 	ret = xa_err(xa_store(&memory_blocks, memory->dev.id, memory,
 			      GFP_KERNEL));
-	if (ret) {
-		put_device(&memory->dev);
+	if (ret)
 		device_unregister(&memory->dev);
-	}
+
 	return ret;
 }
 
-- 
2.35.1



