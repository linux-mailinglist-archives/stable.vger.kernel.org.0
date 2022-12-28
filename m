Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C81D6583E1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiL1QxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiL1Qwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:52:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90BD15801
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70069B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FAEC433D2;
        Wed, 28 Dec 2022 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246021;
        bh=nm/Wbr7NOedjlZ8vmENF15cTaDCD/Qv+rae9dVuOmLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONkPK+MpUVfdojofm/5ZJ9hnVbiWweoVy9ql2Zgz+IybBW/gqNPTl1q0oI5CUZQs5
         hfhy23xoHkgGZvdnDWT85Tz+0i+H0Y54kXxuGWmyDwdT5wM4cg/0ei+FU0uaH6FUWq
         WOixL2TX4Snxe8GXkbZH7ImDopSwFcpGeXTixMYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihlaf.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0999/1073] ASoC: Intel: Skylake: Fix driver hang during shutdown
Date:   Wed, 28 Dec 2022 15:43:07 +0100
Message-Id: <20221228144355.269890357@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index aeca58246fc7..77cd7d3e9409 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -1097,7 +1097,10 @@ static void skl_shutdown(struct pci_dev *pci)
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



