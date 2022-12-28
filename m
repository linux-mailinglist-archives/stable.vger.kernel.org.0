Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6E657EEA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiL1P7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiL1P7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:59:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56B018E00
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:59:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4093D6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232A4C433D2;
        Wed, 28 Dec 2022 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243146;
        bh=TePuMiNa2pNC63XpVcgQ1xVINJebu79XDAKz+0GVs9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3t7m5LehrV9tKR13OVerPt6xGw0/ZaoKoIc1PXsrwmceS0h6kvVyBAz2rizrAPju
         IEB/Seq8UN25jwve1LPCdIgPrzpTn/uyka3A8GDISHdfPrYDj6rug525f5YbqBBKIW
         FNFISW6PNmDF4hEVyuB63XFUNA+hWyEj2w2Vq7s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihlaf.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 688/731] ASoC: Intel: Skylake: Fix driver hang during shutdown
Date:   Wed, 28 Dec 2022 15:43:15 +0100
Message-Id: <20221228144316.408959382@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 171107237246d66bce04f3769d33648f896b4ce3 ]

AudioDSP cores and HDAudio links need to be turned off on shutdown to
ensure no communication or data transfer occurs during the procedure.

Fixes: c5a76a246989 ("ASoC: Intel: Skylake: Add shutdown callback")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihlaf.com>
Link: https://lore.kernel.org/r/20221205085330.857665-6-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index 148ddf4cace0..46bb3b8bd5af 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -1096,7 +1096,10 @@ static void skl_shutdown(struct pci_dev *pci)
 	if (!skl->init_done)
 		return;
 
-	snd_hdac_stop_streams_and_chip(bus);
+	snd_hdac_stop_streams(bus);
+	snd_hdac_ext_bus_link_power_down_all(bus);
+	skl_dsp_sleep(skl->dsp);
+
 	list_for_each_entry(s, &bus->stream_list, list) {
 		stream = stream_to_hdac_ext_stream(s);
 		snd_hdac_ext_stream_decouple(bus, stream, false);
-- 
2.35.1



