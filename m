Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8739664A5E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbjAJScf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239312AbjAJScC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF05B5B480
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:27:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77394B81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAFAC433D2;
        Tue, 10 Jan 2023 18:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375227;
        bh=q5CGp8bn4dsXReRFvVoCcX4BMfwCKfQFTlWG2MLkJSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpDmRCKBVmbaRaesCxG9big+aPB+Ovzzxgmjfe5DpBBFsWF1DV2LCDQyyPmopBuSi
         ZHnBDE+Ab0IBTgr5K8fIPNPIyS5gjlKHcWFIqb7hvz0YHTQWIB5N2nrhio7mXT/Kon
         rwQUk6BRx5W3M61MdeBhPkr42Shp2jXwu58qvUBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.15 120/290] mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()
Date:   Tue, 10 Jan 2023 19:03:32 +0100
Message-Id: <20230110180035.942406933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit 2ebc336be08160debfe27f87660cf550d710f3e9 upstream.

Erase can be zeroed in spi_nor_parse_4bait() or
spi_nor_init_non_uniform_erase_map(). In practice it happened with
mt25qu256a, which supports 4K, 32K, 64K erases with 3b address commands,
but only 4K and 64K erase with 4b address commands.

Fixes: dc92843159a7 ("mtd: spi-nor: fix erase_type array to indicate current map conf")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211119081412.29732-1-alexander.sverdlin@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1409,6 +1409,8 @@ spi_nor_find_best_erase_type(const struc
 			continue;
 
 		erase = &map->erase_type[i];
+		if (!erase->size)
+			continue;
 
 		/* Alignment is not mandatory for overlaid regions */
 		if (region->offset & SNOR_OVERLAID_REGION &&


