Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4EA521F5F
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346215AbiEJPsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346189AbiEJPsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0084327F138;
        Tue, 10 May 2022 08:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D986614A9;
        Tue, 10 May 2022 15:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C452C385A6;
        Tue, 10 May 2022 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197440;
        bh=ZO5qsyXdW8wuKjQ+Ebr8/toVqnfcSnecFh2EH4y2c9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5rfVX8sKnlg4XeIVXEZoPlLw2QbyvGMwGOs7PsbRMYx1+MEc+ALQh3G+qZXbYJb8
         5+esoIRZXIEpLkd6vAJ8mRiSZUIigqKDuEQ+8qGE3xD32dkkzftluKHduLXlgSc6WB
         J2eScZ6GQ6E8PlNPOltfjjK5+6xH1MV7v7r2QhO8w3ZCYzkCr5dZzWJ0tyabpvYx3Q
         Zo1pqZ+2T5HUYVfZUIAJpkqOp51SA6oBPAQOPwDSK1/NGuNykIUv1JelFjXp+yF/kJ
         MLC+sImt5ZfvCu5QaLUI3qGzfyBk4PDUMYAvzBuc+izfAfbY7V7/Mh+0GNPuxpTfwU
         b4RGqDNKy5ztA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        kai.vehmanen@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 09/21] ASoC: SOF: Fix NULL pointer exception in sof_pci_probe callback
Date:   Tue, 10 May 2022 11:43:28 -0400
Message-Id: <20220510154340.153400-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154340.153400-1-sashal@kernel.org>
References: <20220510154340.153400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

