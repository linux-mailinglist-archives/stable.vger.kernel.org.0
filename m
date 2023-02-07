Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9636E68D752
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjBGM6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjBGM6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:58:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FA039B96
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:58:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5497B8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ACCC433D2;
        Tue,  7 Feb 2023 12:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774717;
        bh=6NXM2cNWe9mvAHoptd+dLPMweXAWTHdVAfbPjXKp9yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKsfvITLUGO8xXiaVhVUzFvZEFBwZcURsGXwo8+jTBuruTO9Uwm1U+VUouV/UEloC
         iZ0J5FtS4+X/FstoTiaOqYEIQGhSHYoZq3MWhpSJMKlYxVZuBi+wSJvyb8CUQqh8zy
         Y64ygBTslHYdzqsntW8SEiDWOhssPbpqcauknzL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@google.com>,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/208] ASoC: Intel: avs: Implement PCI shutdown
Date:   Tue,  7 Feb 2023 13:54:25 +0100
Message-Id: <20230207125634.843468179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit f89d783d68dcc6b2ce4fe3bda972ae0f84df0dca ]

On shutdown reference to i915 driver needs to be released to not spam
logs with unnecessary warnings. While at it do some additional cleanup
to make sure DSP is powered down and interrupts from device are
disabled.

Fixes: 1affc44ea5dd ("ASoC: Intel: avs: PCI driver implementation")
Reported-by: Kornel Dulęba <korneld@google.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20230113190310.1451693-2-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 4f93639ce488..5bb3eee2f783 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -476,6 +476,29 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	return ret;
 }
 
+static void avs_pci_shutdown(struct pci_dev *pci)
+{
+	struct hdac_bus *bus = pci_get_drvdata(pci);
+	struct avs_dev *adev = hdac_to_avs(bus);
+
+	cancel_work_sync(&adev->probe_work);
+	avs_ipc_block(adev->ipc);
+
+	snd_hdac_stop_streams(bus);
+	avs_dsp_op(adev, int_control, false);
+	snd_hdac_ext_bus_ppcap_int_enable(bus, false);
+	snd_hdac_ext_bus_link_power_down_all(bus);
+
+	snd_hdac_bus_stop_chip(bus);
+	snd_hdac_display_power(bus, HDA_CODEC_IDX_CONTROLLER, false);
+
+	if (avs_platattr_test(adev, CLDMA))
+		pci_free_irq(pci, 0, &code_loader);
+	pci_free_irq(pci, 0, adev);
+	pci_free_irq(pci, 0, bus);
+	pci_free_irq_vectors(pci);
+}
+
 static void avs_pci_remove(struct pci_dev *pci)
 {
 	struct hdac_device *hdev, *save;
@@ -679,6 +702,7 @@ static struct pci_driver avs_pci_driver = {
 	.id_table = avs_ids,
 	.probe = avs_pci_probe,
 	.remove = avs_pci_remove,
+	.shutdown = avs_pci_shutdown,
 	.driver = {
 		.pm = &avs_dev_pm,
 	},
-- 
2.39.0



