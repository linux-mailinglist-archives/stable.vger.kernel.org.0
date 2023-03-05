Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7B76AB03A
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjCENxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjCENxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:53:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D187B13D5F;
        Sun,  5 Mar 2023 05:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59976B80ACE;
        Sun,  5 Mar 2023 13:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0B9C4339B;
        Sun,  5 Mar 2023 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024386;
        bh=P+C/F+PSp7FrUfSop9nKIwaLsIUBXRuGBlsYGl7+qCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwnwR40gTHW85yUqPdMzrNXxf4giN8XNShx3yzZa5KF4YihOFGcj7SJtpsJvLcxnA
         FAyUpSyykFzd9KRgIVO/hChlLf/MS97+kJKxj0CiyGS93ZR2y4ZbGLdr1lQuI84Gd6
         ZGJNfKwSMRL3V3PVh4efYzdTaVXQRFHrG1T1DukwUWwsuvzbnzHvOfHvbduMpxhEE5
         GDqAa6VQ4fEPIZOOp9/wksIY6qVUXYQzy/e2UErFVYySdB7AessT7wGh2EMpjHqaAX
         Qt+dZGYYbyA5lSemSAS+MnRAn0J6uGPPBm+DiLDjjPtUv+qfRx34ygx16Zu6kKthjA
         LPIuhtTq5n3qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 16/16] PCI: Avoid FLR for SolidRun SNET DPU rev 1
Date:   Sun,  5 Mar 2023 08:52:07 -0500
Message-Id: <20230305135207.1793266-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135207.1793266-1-sashal@kernel.org>
References: <20230305135207.1793266-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvaro Karsz <alvaro.karsz@solid-run.com>

[ Upstream commit d089d69cc1f824936eeaa4fa172f8fa1a0949eaa ]

This patch fixes a FLR bug on the SNET DPU rev 1 by setting the
PCI_DEV_FLAGS_NO_FLR_RESET flag.

As there is a quirk to avoid FLR (quirk_no_flr), I added a new quirk
to check the rev ID before calling to quirk_no_flr.

Without this patch, a SNET DPU rev 1 may hang when FLR is applied.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Message-Id: <20230110165638.123745-3-alvaro.karsz@solid-run.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 285acc4aaccc1..809d03272c205 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5343,6 +5343,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 
+/* FLR may cause the SolidRun SNET DPU (rev 0x1) to hang */
+static void quirk_no_flr_snet(struct pci_dev *dev)
+{
+	if (dev->revision == 0x1)
+		quirk_no_flr(dev);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLIDRUN, 0x1000, quirk_no_flr_snet);
+
 static void quirk_no_ext_tags(struct pci_dev *pdev)
 {
 	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
-- 
2.39.2

