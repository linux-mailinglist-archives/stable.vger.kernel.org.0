Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86E64C771D
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiB1SLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241330AbiB1SJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FCFB2533;
        Mon, 28 Feb 2022 09:49:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A48F3B81085;
        Mon, 28 Feb 2022 17:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2256C340F0;
        Mon, 28 Feb 2022 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070590;
        bh=GCSuhudy+EoWfGl+etGbjGYE4CLlfJerNz4VeCQwXh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nORkQk5Uchy2mnceeqCzYlDf6nXz8AoEWrr/vZoNvzExNLagfk3VJGuXpS9MmOaLP
         KlUGDC6pkPPCIfRm7+Yegk34xC/pT6n9GUuQcLc5mNtgTbWnR/bJhnwG6aPJEP+HXW
         jF3oSAkArmSPdMu99TMlAaYNm2Gn1zBkJ+OKed5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH 5.16 164/164] memblock: use kfree() to release kmalloced memblock regions
Date:   Mon, 28 Feb 2022 18:25:26 +0100
Message-Id: <20220228172414.476506653@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit c94afc46cae7ad41b2ad6a99368147879f4b0e56 upstream.

memblock.{reserved,memory}.regions may be allocated using kmalloc() in
memblock_double_array(). Use kfree() to release these kmalloced regions
indicated by memblock_{reserved,memory}_in_slab.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Fixes: 3010f876500f ("mm: discard memblock data later")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -366,14 +366,20 @@ void __init memblock_discard(void)
 		addr = __pa(memblock.reserved.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.reserved.max);
-		memblock_free_late(addr, size);
+		if (memblock_reserved_in_slab)
+			kfree(memblock.reserved.regions);
+		else
+			memblock_free_late(addr, size);
 	}
 
 	if (memblock.memory.regions != memblock_memory_init_regions) {
 		addr = __pa(memblock.memory.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
-		memblock_free_late(addr, size);
+		if (memblock_memory_in_slab)
+			kfree(memblock.memory.regions);
+		else
+			memblock_free_late(addr, size);
 	}
 
 	memblock_memory = NULL;


