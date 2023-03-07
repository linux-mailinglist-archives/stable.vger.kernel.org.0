Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280CB6AECED
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCGR7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjCGR7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:59:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D50FA54FA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:53:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B57F96150B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF1AC4339B;
        Tue,  7 Mar 2023 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211607;
        bh=hPewh0/nGVNuEzvBReTd2k8UkTZtWu+4RhUM1c16L3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j72p/PCDHV38yNqL+m47xkZFGxfl5/q4OVZca8pMcWI/+0Yj8Fi4moGK7Q6Pt+/ac
         SQi9Ke0fo+G+n6+A8QS67803CnePkEdq+SqWgyZvmbHM0T9TZlh6m3IDdsUm/HVT1O
         E8X30bjxr6NJZ0jMtJ8JOHYDEABiF6CHvXf0K4Vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcin Witkowski <marcin.witkowski@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 0917/1001] spi: intel: Check number of chip selects after reading the descriptor
Date:   Tue,  7 Mar 2023 18:01:29 +0100
Message-Id: <20230307170101.863281058@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 574fbb95cd9d88bdc9c9c4c64223a38a61d7de9a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-intel.c b/drivers/spi/spi-intel.c
index f619212b0d5c..627287925fed 100644
--- a/drivers/spi/spi-intel.c
+++ b/drivers/spi/spi-intel.c
@@ -1368,14 +1368,14 @@ static int intel_spi_populate_chip(struct intel_spi *ispi)
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



