Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDC55AEAEC
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiIFNo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbiIFNnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:43:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227377CA9C;
        Tue,  6 Sep 2022 06:38:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2B21B81636;
        Tue,  6 Sep 2022 13:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AF9C4314C;
        Tue,  6 Sep 2022 13:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471398;
        bh=PUGgoVZZTJScvvtPoB/2rewiBTZxS5R7xBg7g7fXaeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bR7z+UeMX25AE7sxwLcDpOeMriBLoOWFfWzofXXxHsOvS1VlnCi6XWhHuZNOQkJYE
         HeU25JkOM2t2RdRXBZMkdkc/wwmR4Sjmhg9zPPkZ4l/ulDKdBztFlCGhMpPHtGmS5C
         ss+1yodbDJrCIdG2UkdNSSoUPwCJT9+LDE/2eOlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/107] ALSA: hda: intel-nhlt: Correct the handling of fmt_config flexible array
Date:   Tue,  6 Sep 2022 15:29:55 +0200
Message-Id: <20220906132822.365219132@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

[ Upstream commit 2e6481a3f3ee6234ce577454e1d88aca55f51d47 ]

The struct nhlt_format's fmt_config is a flexible array, it must not be
used as normal array.
When moving to the next nhlt_fmt_cfg we need to take into account the data
behind the ->config.caps (indicated by ->config.size).

Fixes: a864e8f159b13 ("ALSA: hda: intel-nhlt: verify config type")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Jaska Uimonen <jaska.uimonen@linux.intel.com>
Link: https://lore.kernel.org/r/20220823122405.18464-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-nhlt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/hda/intel-nhlt.c b/sound/hda/intel-nhlt.c
index 5e04fedaec49e..8714891f50b0a 100644
--- a/sound/hda/intel-nhlt.c
+++ b/sound/hda/intel-nhlt.c
@@ -55,16 +55,22 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 
 		/* find max number of channels based on format_configuration */
 		if (fmt_configs->fmt_count) {
+			struct nhlt_fmt_cfg *fmt_cfg = fmt_configs->fmt_config;
+
 			dev_dbg(dev, "found %d format definitions\n",
 				fmt_configs->fmt_count);
 
 			for (i = 0; i < fmt_configs->fmt_count; i++) {
 				struct wav_fmt_ext *fmt_ext;
 
-				fmt_ext = &fmt_configs->fmt_config[i].fmt_ext;
+				fmt_ext = &fmt_cfg->fmt_ext;
 
 				if (fmt_ext->fmt.channels > max_ch)
 					max_ch = fmt_ext->fmt.channels;
+
+				/* Move to the next nhlt_fmt_cfg */
+				fmt_cfg = (struct nhlt_fmt_cfg *)(fmt_cfg->config.caps +
+								  fmt_cfg->config.size);
 			}
 			dev_dbg(dev, "max channels found %d\n", max_ch);
 		} else {
-- 
2.35.1



