Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877406C1818
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjCTPUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjCTPTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:19:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E35265A8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D93A5615B5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E504BC433A0;
        Mon, 20 Mar 2023 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325265;
        bh=rkwlp0RnQwFwSrinQ4bN0yAHUfgOWBVnIrAX7S3cYTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCwNNmCptPTgYSdX1V4rK1kiv836EHerYm+RQixQug6zRUJa8gyqkxVczQBQIvPAu
         hLSueE3xYzvQh8lV6cMv7h2nAigW7TaTQBv5YHucVi5uK54MIKlggRczma7FuMZEc0
         kdUS8Og1HorWpKh6NvWQnSwF+AJkqivVacEkfuj0=
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
Subject: [PATCH 6.2 012/211] ASoC: SOF: Intel: SKL: Fix device description
Date:   Mon, 20 Mar 2023 15:52:27 +0100
Message-Id: <20230320145513.813287109@linuxfoundation.org>
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

[ Upstream commit 1f320bdb29b644a2c9fb301a6fb2d6170e6417e9 ]

Add missing ops_free callback for SKL/KBL platforms.

Fixes: 52d7939d10f2 ("ASoC: SOF: Intel: add ops for SKL/KBL")

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307093914.25409-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-skl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/intel/pci-skl.c b/sound/soc/sof/intel/pci-skl.c
index 3a99dc444f92e..5b4bccf819658 100644
--- a/sound/soc/sof/intel/pci-skl.c
+++ b/sound/soc/sof/intel/pci-skl.c
@@ -38,6 +38,7 @@ static struct sof_dev_desc skl_desc = {
 	.nocodec_tplg_filename = "sof-skl-nocodec.tplg",
 	.ops = &sof_skl_ops,
 	.ops_init = sof_skl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static struct sof_dev_desc kbl_desc = {
@@ -61,6 +62,7 @@ static struct sof_dev_desc kbl_desc = {
 	.nocodec_tplg_filename = "sof-kbl-nocodec.tplg",
 	.ops = &sof_skl_ops,
 	.ops_init = sof_skl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
-- 
2.39.2



