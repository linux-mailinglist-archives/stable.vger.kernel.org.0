Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8822F6047C0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiJSNpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiJSNoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:44:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B57153812;
        Wed, 19 Oct 2022 06:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B499CE217A;
        Wed, 19 Oct 2022 09:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C03C433D7;
        Wed, 19 Oct 2022 09:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170385;
        bh=AlKGxA5oHb1mhMs88++LuDXBhLryEnVpofotGpHubyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTIuw+ePg+vXqGAtp1sxkpp5EtoGrjocBtpW5LBCnYBvh8eHSAZrmBqQhvmJCi6jq
         TU7TQ/1sq3u4233rya3rKsb9x68Rjpd+ErJluYX5HY3eqfXbR6D5OTNi+Ii+s/aKzm
         Kn70pjhvR7XsYry5R1MPu8LezkmsDRq4hVC76UjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 634/862] iommu/omap: Fix buffer overflow in debugfs
Date:   Wed, 19 Oct 2022 10:32:01 +0200
Message-Id: <20221019083317.948269189@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 184233a5202786b20220acd2d04ddf909ef18f29 ]

There are two issues here:

1) The "len" variable needs to be checked before the very first write.
   Otherwise if omap2_iommu_dump_ctx() with "bytes" less than 32 it is a
   buffer overflow.
2) The snprintf() function returns the number of bytes that *would* have
   been copied if there were enough space.  But we want to know the
   number of bytes which were *actually* copied so use scnprintf()
   instead.

Fixes: bd4396f09a4a ("iommu/omap: Consolidate OMAP IOMMU modules")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/YuvYh1JbE3v+abd5@kili
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/omap-iommu-debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index a99afb5d9011..259f65291d90 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -32,12 +32,12 @@ static inline bool is_omap_iommu_detached(struct omap_iommu *obj)
 		ssize_t bytes;						\
 		const char *str = "%20s: %08x\n";			\
 		const int maxcol = 32;					\
-		bytes = snprintf(p, maxcol, str, __stringify(name),	\
+		if (len < maxcol)					\
+			goto out;					\
+		bytes = scnprintf(p, maxcol, str, __stringify(name),	\
 				 iommu_read_reg(obj, MMU_##name));	\
 		p += bytes;						\
 		len -= bytes;						\
-		if (len < maxcol)					\
-			goto out;					\
 	} while (0)
 
 static ssize_t
-- 
2.35.1



