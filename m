Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60F64FD41A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377344AbiDLHty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358894AbiDLHmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B59546A2;
        Tue, 12 Apr 2022 00:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41E196153F;
        Tue, 12 Apr 2022 07:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDA0C385A5;
        Tue, 12 Apr 2022 07:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747970;
        bh=GCdtRzbsd0giU9kuDnboH1OnpD7l/gKMxIAu4hzgLeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EznmDd6V5AJQ6tGCZBRFpohhkoiy+w41PgDgKefef1QJoJBwdJVgqc++1ih+dFSRC
         Gj5G8KmhFLHtGoHyrF/7/o4bCLPybEasHTUTQyFqPa2CYzRNPi8K6FU7pDiyg8xiFA
         7eNEAOYyPmG69SwqQEIJI3BLNOI3y7sU/UGluHJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Avri Altman <Avri.Altman@wdc.com>,
        Michael Wu <michael@allwinnertech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.17 271/343] mmc: core: Fixup support for writeback-cache for eMMC and SD
Date:   Tue, 12 Apr 2022 08:31:29 +0200
Message-Id: <20220412062959.145752165@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Michael Wu <michael@allwinnertech.com>

commit 08ebf903af57cda6d773f3dd1671b64f73b432b8 upstream.

During the card initialization process, the mmc core checks whether the
eMMC/SD card supports an internal writeback-cache and then enables it
inside the card.

Unfortunately, this isn't according to what the mmc core reports to the
upper block layer. Instead, the writeback-cache support with REQ_FLUSH and
REQ_FUA, are being enabled depending on whether the host supports the CMD23
(MMC_CAP_CMD23) and whether an eMMC supports the reliable-write command.

This is wrong and it may also sound awkward. In fact, it's a remnant
from when both eMMC/SD cards didn't have dedicated commands/support to
control the internal writeback-cache. In other words, it was the best we
could do at that point in time.

To fix the problem, but also without breaking backwards compatibility,
let's align the REQ_FLUSH support with whether the writeback-cache became
successfully enabled - for both eMMC and SD cards.

Cc: stable@kernel.org
Fixes: 881d1c25f765 ("mmc: core: Add cache control for eMMC4.5 device")
Fixes: 130206a615a9 ("mmc: core: Add support for cache ctrl for SD cards")
Depends-on: 97fce126e279 ("mmc: block: Issue a cache flush only when it's enabled")
Reviewed-by: Avri Altman <Avri.Altman@wdc.com>
Signed-off-by: Michael Wu <michael@allwinnertech.com>
Link: https://lore.kernel.org/r/20220331073223.106415-1-michael@allwinnertech.com
[Ulf: Re-wrote the commit message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2382,6 +2382,8 @@ static struct mmc_blk_data *mmc_blk_allo
 	struct mmc_blk_data *md;
 	int devidx, ret;
 	char cap_str[10];
+	bool cache_enabled = false;
+	bool fua_enabled = false;
 
 	devidx = ida_simple_get(&mmc_blk_ida, 0, max_devices, GFP_KERNEL);
 	if (devidx < 0) {
@@ -2461,13 +2463,17 @@ static struct mmc_blk_data *mmc_blk_allo
 			md->flags |= MMC_BLK_CMD23;
 	}
 
-	if (mmc_card_mmc(card) &&
-	    md->flags & MMC_BLK_CMD23 &&
+	if (md->flags & MMC_BLK_CMD23 &&
 	    ((card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN) ||
 	     card->ext_csd.rel_sectors)) {
 		md->flags |= MMC_BLK_REL_WR;
-		blk_queue_write_cache(md->queue.queue, true, true);
+		fua_enabled = true;
+		cache_enabled = true;
 	}
+	if (mmc_cache_enabled(card->host))
+		cache_enabled  = true;
+
+	blk_queue_write_cache(md->queue.queue, cache_enabled, fua_enabled);
 
 	string_get_size((u64)size, 512, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));


