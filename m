Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3F56BB260
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjCOMfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjCOMf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A238699D6C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 830AF61D71
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A85C433EF;
        Wed, 15 Mar 2023 12:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883651;
        bh=B5f9pzFk1lgO1q76ZOhNXhYImMXbJUNjwv+Qc6KYeKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsXA/PGGF4M9wNwzpRMjLVLu8NoiXDccTTmEfHcq5R1HoIvhYeJV4dpK3tLA4dwg7
         FYfTHVAh8hNJvx05RMNeWYFNIULFgCB0hDGeyk0VOXREX2y1CjiVZg3DTauOiUXR7g
         SujbOB4SaKhj6Qv8Ia63Ha9OMlqCoLIHzb+xXIFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcin Witkowski <marcin.witkowski@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/143] spi: intel: Check number of chip selects after reading the descriptor
Date:   Wed, 15 Mar 2023 13:12:14 +0100
Message-Id: <20230315115741.981607434@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 574fbb95cd9d88bdc9c9c4c64223a38a61d7de9a ]

The flash decriptor contains the number of flash components that we use
to figure out how many flash chips there are connected. Therefore we
need to read it first before deciding how many chip selects the
controller has.

Reported-by: Marcin Witkowski <marcin.witkowski@intel.com>
Fixes: 3f03c618bebb ("spi: intel: Add support for second flash chip")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20230215110040.42186-1-mika.westerberg@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-intel.c b/drivers/spi/spi-intel.c
index 3ac73691fbb54..54fc226e1cdf6 100644
--- a/drivers/spi/spi-intel.c
+++ b/drivers/spi/spi-intel.c
@@ -1366,14 +1366,14 @@ static int intel_spi_populate_chip(struct intel_spi *ispi)
 	if (!spi_new_device(ispi->master, &chip))
 		return -ENODEV;
 
-	/* Add the second chip if present */
-	if (ispi->master->num_chipselect < 2)
-		return 0;
-
 	ret = intel_spi_read_desc(ispi);
 	if (ret)
 		return ret;
 
+	/* Add the second chip if present */
+	if (ispi->master->num_chipselect < 2)
+		return 0;
+
 	chip.platform_data = NULL;
 	chip.chip_select = 1;
 
-- 
2.39.2



