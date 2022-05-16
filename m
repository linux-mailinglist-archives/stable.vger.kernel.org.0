Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82145290D7
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbiEPUJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350803AbiEPUBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0450F45067;
        Mon, 16 May 2022 12:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8003EB81611;
        Mon, 16 May 2022 19:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9BEC34100;
        Mon, 16 May 2022 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730949;
        bh=ZO5qsyXdW8wuKjQ+Ebr8/toVqnfcSnecFh2EH4y2c9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JN1FAyCLLj89aWoPBGRLrKFQJFirPc4FpszOnSMIwUGzgxfGyeiJPf8AlJ6H3u7VX
         ZHj3RQY72FnAkTOS73B1zPHdRIVNxpTF6bhF5t0zlBz5e5znhueNm2qOcevfFC4VDR
         ImetkBYos+UhW0MaKhcdr5Q4tZ7Jp/UwcqgUpbiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 057/114] ASoC: SOF: Fix NULL pointer exception in sof_pci_probe callback
Date:   Mon, 16 May 2022 21:36:31 +0200
Message-Id: <20220516193627.132024996@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>

[ Upstream commit c61711c1c95791850be48dd65a1d72eb34ba719f ]

We are accessing "desc->ops" in sof_pci_probe without checking "desc"
pointer. This results in NULL pointer exception if pci_id->driver_data
i.e desc pointer isn't defined in sof device probe:

BUG: kernel NULL pointer dereference, address: 0000000000000060
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:sof_pci_probe+0x1e/0x17f [snd_sof_pci]
Code: Unable to access opcode bytes at RIP 0xffffffffc043dff4.
RSP: 0018:ffffac4b03b9b8d8 EFLAGS: 00010246

Add NULL pointer check for sof_dev_desc pointer to avoid such exception.

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220426183357.102155-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index 20c6ca37dbc4..53e97abbe6e3 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -130,6 +130,11 @@ int sof_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 
 	dev_dbg(&pci->dev, "PCI DSP detected");
 
+	if (!desc) {
+		dev_err(dev, "error: no matching PCI descriptor\n");
+		return -ENODEV;
+	}
+
 	if (!desc->ops) {
 		dev_err(dev, "error: no matching PCI descriptor ops\n");
 		return -ENODEV;
-- 
2.35.1



