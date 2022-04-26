Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB8650F6E0
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244086AbiDZJBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345836AbiDZI5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:57:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83900255;
        Tue, 26 Apr 2022 01:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4658AB81CFA;
        Tue, 26 Apr 2022 08:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E13C385A0;
        Tue, 26 Apr 2022 08:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962556;
        bh=m88EaHGaWG+yaFFMZJp6vGUHRl983e7S1YXxudfwUVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcgNivbaUgCcODlZLSTcGUdbTEVLszLuko+uAeH/fms8CBzz7kM8HFwP6BJIU0mLZ
         XruQDm+Ym6bTNZ1VAIQQbMekExuOsT6KJRViNY8PwjY54I+Qa1xhM7x1ayuHeaPMSX
         hUkWXoHH6JJi1MQuuikQa095qAV+9zDS1+bi24r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 012/146] ASoC: topology: Correct error handling in soc_tplg_dapm_widget_create()
Date:   Tue, 26 Apr 2022 10:20:07 +0200
Message-Id: <20220426081750.408766325@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 9c363532413cda3e2c6dfa10e5cca7cd221877a0 ]

Academic correction of error handling:
In case the allocation of kc or kcontrol_type fails the correct label to
jump is hdr_err since the template.sname has been also allocated at this
point.

Fixes: d29d41e28eea6 ("ASoC: topology: Add support for multiple kcontrol types to a widget")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220331114957.519-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index cb24805668bd..f413238117af 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1479,12 +1479,12 @@ static int soc_tplg_dapm_widget_create(struct soc_tplg *tplg,
 	template.num_kcontrols = le32_to_cpu(w->num_kcontrols);
 	kc = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(*kc), GFP_KERNEL);
 	if (!kc)
-		goto err;
+		goto hdr_err;
 
 	kcontrol_type = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(unsigned int),
 				     GFP_KERNEL);
 	if (!kcontrol_type)
-		goto err;
+		goto hdr_err;
 
 	for (i = 0; i < le32_to_cpu(w->num_kcontrols); i++) {
 		control_hdr = (struct snd_soc_tplg_ctl_hdr *)tplg->pos;
-- 
2.35.1



