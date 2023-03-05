Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527946AB06C
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjCENzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCENzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:55:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3C6166E5;
        Sun,  5 Mar 2023 05:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E37D060B38;
        Sun,  5 Mar 2023 13:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72A6C4339E;
        Sun,  5 Mar 2023 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024488;
        bh=t1Sf8eOW7/8p5QnXIuqv9ABRMVcDjrAaTTq5g0Or39I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYqmI50o/q+OL3qCuIGh1nDCwnBOLK+H0UtnBH9Q+mMmrPab6jiZ1xtYYdlTfJXAb
         F7/bu35psvpQjquwnaqifHp7jBrRulGrYYCuWxvKBQYnY/qyR6UM+qs2CtxXDJOL+c
         KwO7cDMVo1pDC5WPqUZv1o5WEXBXzx4O0E3j+6vDgURb2ks+7sQzuXK3S3cpzofu5s
         KESVlYJ4NyrlMnm9r6qMJZscjQHzr9wSVMZqgiHGOaynsTELFp/2kZoJdHW57OO0uN
         NQud+is3EzuF6Fh8yH1QN0VvmfDbX5I79cEvaRSl2kB/1UwDp5i/sI+WBvmSRu5p8m
         Yixn4jYN/sRDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 8/8] PCI: Avoid FLR for SolidRun SNET DPU rev 1
Date:   Sun,  5 Mar 2023 08:54:25 -0500
Message-Id: <20230305135425.1793964-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135425.1793964-1-sashal@kernel.org>
References: <20230305135425.1793964-1-sashal@kernel.org>
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
index fb2e52fd01b39..939652f55d949 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5305,6 +5305,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
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

