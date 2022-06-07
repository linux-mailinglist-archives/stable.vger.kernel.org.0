Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC41541BFD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382368AbiFGVzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384255AbiFGVyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1439824A1D8;
        Tue,  7 Jun 2022 12:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66621618D9;
        Tue,  7 Jun 2022 19:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E574C385A2;
        Tue,  7 Jun 2022 19:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629174;
        bh=42ZT3DX00fIum0t1J+6Opa8Rq3Y6zavv3Rpl3Ycz3gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Syg7k/xgpHVND+7qrDwZ79WEDkMSqSAafXeql+Q0hlmPtd2pQEwzrd3y6iW6P1w40
         qm0UKmVXX8o5NRkhvk6ytn24USCcZP0fF1SW1oW2P1sD9Shlt/fFq5pbIdK2g0lC3R
         URPFzKbW3b/+QuubryOItXZVdAUdemt2OTiwYOxY=
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
Subject: [PATCH 5.18 597/879] drivers/base/memory: fix an unlikely reference counting issue in __add_memory_block()
Date:   Tue,  7 Jun 2022 19:01:55 +0200
Message-Id: <20220607165020.182006756@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 7222ff9b5e05..084d67fd55cc 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -636,10 +636,9 @@ static int __add_memory_block(struct memory_block *memory)
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



