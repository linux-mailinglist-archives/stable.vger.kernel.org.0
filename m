Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB836D4A36
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbjDCOpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjDCOov (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:44:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66576EAE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B97E6B81D24
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CAFC433D2;
        Mon,  3 Apr 2023 14:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533033;
        bh=ngCYb9YfkC/oTCBrMAIKUM8kyMQxJhxBWrHXc+Ju2WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyWtgHgzTeMuMSDoTUl+HRMvyuz7UipntP8AU3QohVsCOyiP8eTqrG+YpNPfRTDtR
         W5299TJbIisCfzaxd1gifC784vB5AeDfTfK8/R8xigIJV7eQMolB1YMbzRxQBdrup5
         XExU5TJVdRJ7f9Mm2PbZrye2wqbDAUAl7tgEVVFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 029/187] ASoC: SOF: ipc4-topology: Fix incorrect sample rate print unit
Date:   Mon,  3 Apr 2023 16:07:54 +0200
Message-Id: <20230403140416.962951925@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>

[ Upstream commit 9e269e3aa9006440de639597079ee7140ef5b5f3 ]

This patch fixes the sample rate print unit from KHz to Hz.
E.g. 48000KHz becomes 48000Hz.

Signed-off-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307110751.2053-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 59f4d42f9011e..65da1cf790d9c 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -155,7 +155,7 @@ static void sof_ipc4_dbg_audio_format(struct device *dev,
 	for (i = 0; i < num_format; i++, ptr = (u8 *)ptr + object_size) {
 		fmt = ptr;
 		dev_dbg(dev,
-			" #%d: %uKHz, %ubit (ch_map %#x ch_cfg %u interleaving_style %u fmt_cfg %#x)\n",
+			" #%d: %uHz, %ubit (ch_map %#x ch_cfg %u interleaving_style %u fmt_cfg %#x)\n",
 			i, fmt->sampling_frequency, fmt->bit_depth, fmt->ch_map,
 			fmt->ch_cfg, fmt->interleaving_style, fmt->fmt_cfg);
 	}
-- 
2.39.2



