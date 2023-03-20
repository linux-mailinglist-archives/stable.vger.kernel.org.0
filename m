Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03706C1852
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjCTPX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjCTPXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE6A303E6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B37AB80E6F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8632C433A4;
        Mon, 20 Mar 2023 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325356;
        bh=43RDQauyGFVaRdKerke8+1dBtn596l0XMDW8DA3/vOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVo8422cUvAgXQdQCylbNXarN5YERY87wkPsrB4qovkXHrrbXVGOD0V6Bpd0G1ndG
         UsEf603iNZmSTg//PN40TEpV3X/HNZzgV07BFZiBYg4W8aEk+9uQtfslrafOTlkaDZ
         IekCNDTriXnufgxEPYtw40CfokfX9NcRgL+XZ950=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 013/211] ASOC: SOF: Intel: pci-tgl: Fix device description
Date:   Mon, 20 Mar 2023 15:52:28 +0100
Message-Id: <20230320145513.849190195@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 376f79bbf521fc37b871b536276319951b5bef3a ]

Add the missing ops_free callback.

Fixes: 63d375b9f2a9 ("ASoC: SOF: Intel: pci-tgl: use RPL specific firmware definitions")

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307093914.25409-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-tgl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index adc7314a1b578..22e769e0831d9 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -239,6 +239,7 @@ static const struct sof_dev_desc rpls_desc = {
 	.nocodec_tplg_filename = "sof-rpl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static const struct sof_dev_desc rpl_desc = {
@@ -270,6 +271,7 @@ static const struct sof_dev_desc rpl_desc = {
 	.nocodec_tplg_filename = "sof-rpl-nocodec.tplg",
 	.ops = &sof_tgl_ops,
 	.ops_init = sof_tgl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
-- 
2.39.2



