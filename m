Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396D968D765
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjBGM7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjBGM7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1271E21A2E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C169EB818E8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A38C433EF;
        Tue,  7 Feb 2023 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774760;
        bh=/u3LLcaZPBeM1fkbFDsPQ+V6YqDBk3lNBM4GfT5s1NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIgTw9605k2xiSpGSrAg6w8luUAo8S4T087lTE1u1CUQtKO7a54zeniZTeawVqKD+
         KX7ClEmNfth1li8JgeHvp6rDiKtnrt6y4agjrRY7YGriQ4MQNR8t1aZUpAQA5uy6hw
         Rk2LSfj5bwLQP6caCmygh2NUDy8zl/ZuSqwrkYxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/208] ASoC: Intel: bytcr_wm5102: Drop reference count of ACPI device after use
Date:   Tue,  7 Feb 2023 13:54:23 +0100
Message-Id: <20230207125634.757304973@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c8aa49abdeda2ab587aadb083e670f6aa0236f93 ]

Theoretically the device might gone if its reference count drops to 0.
This might be the case when we try to find the first physical node of
the ACPI device. We need to keep reference to it until we get a result
of the above mentioned call. Refactor the code to drop the reference
count at the correct place.

While at it, move to acpi_dev_put() as symmetrical call to the
acpi_dev_get_first_match_dev().

Fixes: 9a87fc1e0619 ("ASoC: Intel: bytcr_wm5102: Add machine driver for BYT/WM5102")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230112112852.67714-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_wm5102.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/bytcr_wm5102.c b/sound/soc/intel/boards/bytcr_wm5102.c
index 45a6805787f5..f8da1bcd010e 100644
--- a/sound/soc/intel/boards/bytcr_wm5102.c
+++ b/sound/soc/intel/boards/bytcr_wm5102.c
@@ -411,9 +411,9 @@ static int snd_byt_wm5102_mc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 	snprintf(codec_name, sizeof(codec_name), "spi-%s", acpi_dev_name(adev));
-	put_device(&adev->dev);
 
 	codec_dev = bus_find_device_by_name(&spi_bus_type, NULL, codec_name);
+	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
 
-- 
2.39.0



