Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5714CF68E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbiCGJmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241019AbiCGJlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B1D193E3;
        Mon,  7 Mar 2022 01:39:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E3A7B80F9F;
        Mon,  7 Mar 2022 09:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E536BC340F4;
        Mon,  7 Mar 2022 09:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645954;
        bh=7uufl7fOJxR6MEWi6zzls+R5+wCjkkg82U+p4qsirB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+kuDejsGk+s8FBcJdru+q2BvgGFAPjviYJrE5C2sQ+EpaaE5nxnN12y9MaLduIM+
         za4mMIQfWvM2nfZVSDVKeCpUxH2KBfXIImyabBspFRoYOMxxOBTW5ulL0jlzPEgMH5
         dGECCXbZvKlCqn79kT4r+Oq1M+7yApm1XomFvFSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/262] mtd: spi-nor: Fix mtd size for s3an flashes
Date:   Mon,  7 Mar 2022 10:16:31 +0100
Message-Id: <20220307091703.849344962@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit f656b419d41aabafb6b526abc3988dfbf2e5c1ba ]

As it was before the blamed commit, s3an_nor_scan() was called
after mtd size was set with params->size, and it overwrote the mtd
size value with '8 * nor->page_size * nor->info->n_sectors' when
XSR_PAGESIZE was set. With the introduction of
s3an_post_sfdp_fixups(), we missed to update the mtd size for the
s3an flashes. Fix the mtd size by updating both nor->params->size,
(which will update the mtd_info size later on) and nor->mtd.size
(which is used in spi_nor_set_addr_width()).

Fixes: 641edddb4f43 ("mtd: spi-nor: Add s3an_post_sfdp_fixups()")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20211207140254.87681-2-tudor.ambarus@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/xilinx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/xilinx.c b/drivers/mtd/spi-nor/xilinx.c
index 1138bdbf41998..75dd13a390404 100644
--- a/drivers/mtd/spi-nor/xilinx.c
+++ b/drivers/mtd/spi-nor/xilinx.c
@@ -66,7 +66,8 @@ static int xilinx_nor_setup(struct spi_nor *nor,
 		/* Flash in Power of 2 mode */
 		nor->page_size = (nor->page_size == 264) ? 256 : 512;
 		nor->mtd.writebufsize = nor->page_size;
-		nor->mtd.size = 8 * nor->page_size * nor->info->n_sectors;
+		nor->params->size = 8 * nor->page_size * nor->info->n_sectors;
+		nor->mtd.size = nor->params->size;
 		nor->mtd.erasesize = 8 * nor->page_size;
 	} else {
 		/* Flash in Default addressing mode */
-- 
2.34.1



