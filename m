Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F32475F3A
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhLOR2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:28:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46434 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343517AbhLORZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA42E61A02;
        Wed, 15 Dec 2021 17:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF675C36AE0;
        Wed, 15 Dec 2021 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589152;
        bh=BbrEHS8mkl7vtOLV1WBEmEOkHpo4FpDOySJK7kS53RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn27EoWM9hjlYaSPhXPr2McTX9Gi7GWZ2fsHHDz7t2RcJbBbJ4y/S8mVan+M3NyfM
         UEepka0wGoMkJcJ/ubvrUfj/a1WdsOSKnsiwWTGr494oeRm4kCqOj4Cxc0ZdNzleGt
         HTDGKkLtux7cGSjDyxDFxeMLJahtiVgMqL6p4ml4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.10 31/33] memblock: ensure there is no overflow in memblock_overlaps_region()
Date:   Wed, 15 Dec 2021 18:21:29 +0100
Message-Id: <20211215172025.863819272@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit 023accf5cdc1e504a9b04187ec23ff156fe53d90 ]

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
@@ -182,6 +182,8 @@ bool __init_memblock memblock_overlaps_r
 {
 	unsigned long i;
 
+	memblock_cap_size(base, &size);
+
 	for (i = 0; i < type->cnt; i++)
 		if (memblock_addrs_overlap(base, size, type->regions[i].base,
 					   type->regions[i].size))
@@ -1792,7 +1794,6 @@ bool __init_memblock memblock_is_region_
  */
 bool __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
-	memblock_cap_size(base, &size);
 	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 


