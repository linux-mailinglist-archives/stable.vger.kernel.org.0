Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5C459D70C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiHWJWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350433AbiHWJVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:21:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944A08E0E6;
        Tue, 23 Aug 2022 01:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1147D61499;
        Tue, 23 Aug 2022 08:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181B7C433D6;
        Tue, 23 Aug 2022 08:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243629;
        bh=XMqlULsVRDZW+IEUfiphA3cJNCqcrWzjUawBkqNX6W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmctdUQG7628qXMTkuyidLA2afXhOF8EKNro7oNP1FfIBkv+GNKPRC6zbFzNlYCIw
         fB5Oq+wlA63vdUPoYVQIrUVaUMKaDw0uhe7sti0PUkw1Vkn86rfNpbJOXX60sF3/v5
         dacefLa0I9hCxP/ZLB7UAEFJJ9PHbRzRyPMLXqjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 330/365] ASoC: SOF: sof-client-probes: Only load the driver if IPC3 is used
Date:   Tue, 23 Aug 2022 10:03:51 +0200
Message-Id: <20220823080132.023341441@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 9b93eda355089b36482f7a2f134bdd24be70f907 ]

The current implementation of probes only supports IPC3 and should not be
loaded for other IPC implementation.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220712131022.1124-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-client-probes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/sof/sof-client-probes.c b/sound/soc/sof/sof-client-probes.c
index 34e6bd356e71..60e4250fac87 100644
--- a/sound/soc/sof/sof-client-probes.c
+++ b/sound/soc/sof/sof-client-probes.c
@@ -693,6 +693,10 @@ static int sof_probes_client_probe(struct auxiliary_device *auxdev,
 	if (!sof_probes_enabled)
 		return -ENXIO;
 
+	/* only ipc3 is supported */
+	if (sof_client_get_ipc_type(cdev) != SOF_IPC)
+		return -ENXIO;
+
 	if (!dev->platform_data) {
 		dev_err(dev, "missing platform data\n");
 		return -ENODEV;
-- 
2.35.1



