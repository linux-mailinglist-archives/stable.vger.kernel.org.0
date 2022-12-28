Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2808D657C29
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiL1P3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiL1P3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:29:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3709C1571A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:29:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA0C6155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEC1C433D2;
        Wed, 28 Dec 2022 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241371;
        bh=J1eQpWRD7dauu8lTpjDHvkOmf4Mpsta51pLJZPdOdww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpvIjvd3FWdiCCVETCJFHcOsGMYCPH7iAGcKFiWpiSh7EodfXewDbObBdGFoc1y1B
         iYDyAsES/ehroiPdfbjAzuz7gsEcVhCa554boA8Ebbl+4l9aBa2D9JnZyOsoDP1Y6f
         r38LiGbJ/TXiqobpktNoXNa3Uk++AVqPVoWPvNz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Tommaso Merciai <tommaso.merciai@amarulasolutions.com>,
        Martin Kepplinger <martink@posteo.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0238/1146] media: i2c: hi846: Fix memory leak in hi846_parse_dt()
Date:   Wed, 28 Dec 2022 15:29:37 +0100
Message-Id: <20221228144336.602967346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 80113026d415e27483669db7a88b548d1ec3d3d1 ]

If any of the checks related to the supported link frequencies fail, then
the V4L2 fwnode resources don't get released before returning, which leads
to a memleak. Fix this by properly freeing the V4L2 fwnode data in a
designated label.

Fixes: e8c0882685f9 ("media: i2c: add driver for the SK Hynix Hi-846 8M pixel camera")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Reviewed-by: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/hi846.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/hi846.c b/drivers/media/i2c/hi846.c
index c5b69823f257..7c61873b7198 100644
--- a/drivers/media/i2c/hi846.c
+++ b/drivers/media/i2c/hi846.c
@@ -2008,22 +2008,24 @@ static int hi846_parse_dt(struct hi846 *hi846, struct device *dev)
 	    bus_cfg.bus.mipi_csi2.num_data_lanes != 4) {
 		dev_err(dev, "number of CSI2 data lanes %d is not supported",
 			bus_cfg.bus.mipi_csi2.num_data_lanes);
-		v4l2_fwnode_endpoint_free(&bus_cfg);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto check_hwcfg_error;
 	}
 
 	hi846->nr_lanes = bus_cfg.bus.mipi_csi2.num_data_lanes;
 
 	if (!bus_cfg.nr_of_link_frequencies) {
 		dev_err(dev, "link-frequency property not found in DT\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto check_hwcfg_error;
 	}
 
 	/* Check that link frequences for all the modes are in device tree */
 	fq = hi846_check_link_freqs(hi846, &bus_cfg);
 	if (fq) {
 		dev_err(dev, "Link frequency of %lld is not supported\n", fq);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto check_hwcfg_error;
 	}
 
 	v4l2_fwnode_endpoint_free(&bus_cfg);
@@ -2044,6 +2046,10 @@ static int hi846_parse_dt(struct hi846 *hi846, struct device *dev)
 	}
 
 	return 0;
+
+check_hwcfg_error:
+	v4l2_fwnode_endpoint_free(&bus_cfg);
+	return ret;
 }
 
 static int hi846_probe(struct i2c_client *client)
-- 
2.35.1



