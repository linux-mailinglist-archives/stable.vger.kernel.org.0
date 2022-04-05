Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A074F29DB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiDEI1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239468AbiDEIUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ACF98F6C;
        Tue,  5 Apr 2022 01:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAE37B81A37;
        Tue,  5 Apr 2022 08:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BFEC385A0;
        Tue,  5 Apr 2022 08:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146429;
        bh=2valnc8op0vBurNY+QIL/EnW2wscb8NHYd9VGwj8E/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8KxXoPAjYI0bZ7w4Ihy5TfKg+Ix3fJLx1asa4VDcCi0mw+/2Gm7zi+l22cFlr8km
         1EiY0vM7rk8yYT00k4410kClEcWl44KUtcb6DcOcvSzPtT5XTab/xeKvE1Vvf0EGna
         4ZLmIOimp0jamC7St2msDhdYo8On1FoyIvwBSF/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0754/1126] nvdimm/region: Fix default alignment for small regions
Date:   Tue,  5 Apr 2022 09:25:01 +0200
Message-Id: <20220405070429.716466121@linuxfoundation.org>
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
index 9ccf3d608799..70ad891a76ba 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1025,6 +1025,9 @@ static unsigned long default_align(struct nd_region *nd_region)
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



