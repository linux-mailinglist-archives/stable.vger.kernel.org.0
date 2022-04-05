Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E144F406E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381363AbiDEMOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242157AbiDEKfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D2033E38;
        Tue,  5 Apr 2022 03:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 952FCCE1C9D;
        Tue,  5 Apr 2022 10:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC477C385A2;
        Tue,  5 Apr 2022 10:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154038;
        bh=MfwX727Q9AFdf92OHAt5EUIUTYfebfheXDoPAwvr16E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHmAfrtnRQ03cXVLeO7OfLRQ8VI6Yg8z/RYhXNtPgZawfthdqu0MQPT+wcnf0XL9n
         nBHs1HMPqgw8P43+qURttXv6/VA3uxN3UgpxMh9gHRmdCgNZMy9UOH+bsZcBCRVptB
         FOqVNoX5SHdk5QHmkOFHsPKWSa8HGIDNjHvLsKq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 408/599] nvdimm/region: Fix default alignment for small regions
Date:   Tue,  5 Apr 2022 09:31:42 +0200
Message-Id: <20220405070310.974175533@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit d9d290d7e659e9db3e4518040cc18b97f5535f4a ]

In preparation for removing BLK aperture support the NVDIMM unit tests
discovered that the default alignment can be set higher than the
capacity of the region. Fall back to PAGE_SIZE in that case.

Given this has not been seen in the wild, elide notifying -stable.

Fixes: 2522afb86a8c ("libnvdimm/region: Introduce an 'align' attribute")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/164688416128.2879318.17890707310125575258.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/region_devs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e05cc9f8a9fd..1d72653b5c8d 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1018,6 +1018,9 @@ static unsigned long default_align(struct nd_region *nd_region)
 		}
 	}
 
+	if (nd_region->ndr_size < MEMREMAP_COMPAT_ALIGN_MAX)
+		align = PAGE_SIZE;
+
 	mappings = max_t(u16, 1, nd_region->ndr_mappings);
 	div_u64_rem(align, mappings, &remainder);
 	if (remainder)
-- 
2.34.1



