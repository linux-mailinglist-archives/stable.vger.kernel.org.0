Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC6694954
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjBMO6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjBMO6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927881BCB
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9D54B81250
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57434C433D2;
        Mon, 13 Feb 2023 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300266;
        bh=J8WpD2daCdqOZbyWy0ls5JntKKb8bQsGGgdXAIrvaY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFOOvbtA5WioQC2US5kDydZf/C4HyAF+yetG6pyYakUlLVLUuQ04gt0u0sDMwmkVU
         b+tVkiy/j3xfWFzeDjxLZRcnXTEQZukHVQBRNA/xhgM2+OiSW/5FUtKd+/Wqa4VT7i
         0s4aW9MNI1ol4WioK6QM3mNAj140YA+zSqgWgamw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Luca Di Stefano <luca.distefano@linaro.org>,
        993612@bugs.debian.org, stable@kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 13/67] of/address: Return an error when no valid dma-ranges are found
Date:   Mon, 13 Feb 2023 15:48:54 +0100
Message-Id: <20230213144732.959050272@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit f6933c01e42d2fc83b9133ed755609e4aac6eadd upstream.

Commit 7a8b64d17e35 ("of/address: use range parser for of_dma_get_range")
converted the parsing of dma-range properties to use code shared with the
PCI range parser. The intent was to introduce no functional changes however
in the case where we fail to translate the first resource instead of
returning -EINVAL the new code we return 0. Restore the previous behaviour
by returning an error if we find no valid ranges, the original code only
handled the first range but subsequently support for parsing all supplied
ranges was added.

This avoids confusing code using the parsed ranges which doesn't expect to
successfully parse ranges but have only a list terminator returned, this
fixes breakage with so far as I can tell all DMA for on SoC devices on the
Socionext Synquacer platform which has a firmware supplied DT. A bisect
identified the original conversion as triggering the issues there.

Fixes: 7a8b64d17e35 ("of/address: use range parser for of_dma_get_range")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Luca Di Stefano <luca.distefano@linaro.org>
Cc: 993612@bugs.debian.org
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20230126-synquacer-boot-v2-1-cb80fd23c4e2@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -963,8 +963,19 @@ int of_dma_get_range(struct device_node
 	}
 
 	of_dma_range_parser_init(&parser, node);
-	for_each_of_range(&parser, &range)
+	for_each_of_range(&parser, &range) {
+		if (range.cpu_addr == OF_BAD_ADDR) {
+			pr_err("translation of DMA address(%llx) to CPU address failed node(%pOF)\n",
+			       range.bus_addr, node);
+			continue;
+		}
 		num_ranges++;
+	}
+
+	if (!num_ranges) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	r = kcalloc(num_ranges + 1, sizeof(*r), GFP_KERNEL);
 	if (!r) {
@@ -973,18 +984,16 @@ int of_dma_get_range(struct device_node
 	}
 
 	/*
-	 * Record all info in the generic DMA ranges array for struct device.
+	 * Record all info in the generic DMA ranges array for struct device,
+	 * returning an error if we don't find any parsable ranges.
 	 */
 	*map = r;
 	of_dma_range_parser_init(&parser, node);
 	for_each_of_range(&parser, &range) {
 		pr_debug("dma_addr(%llx) cpu_addr(%llx) size(%llx)\n",
 			 range.bus_addr, range.cpu_addr, range.size);
-		if (range.cpu_addr == OF_BAD_ADDR) {
-			pr_err("translation of DMA address(%llx) to CPU address failed node(%pOF)\n",
-			       range.bus_addr, node);
+		if (range.cpu_addr == OF_BAD_ADDR)
 			continue;
-		}
 		r->cpu_start = range.cpu_addr;
 		r->dma_start = range.bus_addr;
 		r->size = range.size;


