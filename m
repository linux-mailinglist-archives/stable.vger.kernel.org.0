Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B42E475F33
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343934AbhLOR2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344111AbhLOR1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:27:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49F2C06137E;
        Wed, 15 Dec 2021 09:26:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63A72B82049;
        Wed, 15 Dec 2021 17:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C44C36AE2;
        Wed, 15 Dec 2021 17:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589183;
        bh=Y86ow4ktgKGqvGzBEuntdwaatnH7tNTUPsrzvkLuNJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esIyVeJAM5Pwd0TIUX7T0673257pZ/5jjAmsV9imRdXdrp6a39LlH+R5Rjw9FqaWM
         EgTKE+rFIyRGnnhVd79G/wUqlqfUegefG/ZVXBtm/NPxX8bjRwkoewdAeFEi1e9ztG
         IWg/oAYSa895BAdJgp8nAbc8IblVs9mDE1Si72T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.4 16/18] memblock: ensure there is no overflow in memblock_overlaps_region()
Date:   Wed, 15 Dec 2021 18:21:37 +0100
Message-Id: <20211215172023.368732496@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
References: <20211215172022.795825673@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 023accf5cdc1e504a9b04187ec23ff156fe53d90 upstream.

There maybe an overflow in memblock_overlaps_region() if it is called with
base and size such that

	base + size > PHYS_ADDR_MAX

Make sure that memblock_overlaps_region() caps the size to prevent such
overflow and remove now duplicated call to memblock_cap_size() from
memblock_is_region_reserved().

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -164,6 +164,8 @@ bool __init_memblock memblock_overlaps_r
 {
 	unsigned long i;
 
+	memblock_cap_size(base, &size);
+
 	for (i = 0; i < type->cnt; i++)
 		if (memblock_addrs_overlap(base, size, type->regions[i].base,
 					   type->regions[i].size))
@@ -1760,7 +1762,6 @@ bool __init_memblock memblock_is_region_
  */
 bool __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
-	memblock_cap_size(base, &size);
 	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 


