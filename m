Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673EB4FD868
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244925AbiDLHhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353698AbiDLHZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EF926AE6;
        Tue, 12 Apr 2022 00:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CDD460B2E;
        Tue, 12 Apr 2022 07:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28182C385A6;
        Tue, 12 Apr 2022 07:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747030;
        bh=J1aS2TvbmzFAHejZI/i7umfoY7zFKn7+Ucs2BIKv+RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dP6SwxLqGv91XU6TCLbHtLSCZhdJ04GYnn6tXx5CF7T6cuig84Qcp7LTlPJKS1x9e
         4d4lkon1z8/0LMlMWrBhDp+zWhH75tTBRERqTjFrjK7uxaOEqlN+PxuxvSa/8xDtzw
         yqDPaDtL//5QS+sMskD//ukYlJX0E7EKzUNHJDMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Avri Altman <Avri.Altman@wdc.com>,
        Michael Wu <michael@allwinnertech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.16 219/285] mmc: core: Fixup support for writeback-cache for eMMC and SD
Date:   Tue, 12 Apr 2022 08:31:16 +0200
Message-Id: <20220412062949.978843512@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
@@ -2376,6 +2376,8 @@ static struct mmc_blk_data *mmc_blk_allo
 	struct mmc_blk_data *md;
 	int devidx, ret;
 	char cap_str[10];
+	bool cache_enabled = false;
+	bool fua_enabled = false;
 
 	devidx = ida_simple_get(&mmc_blk_ida, 0, max_devices, GFP_KERNEL);
 	if (devidx < 0) {
@@ -2457,13 +2459,17 @@ static struct mmc_blk_data *mmc_blk_allo
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


