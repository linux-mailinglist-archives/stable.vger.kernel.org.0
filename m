Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0256AB097
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjCEN5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjCEN5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:57:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FDE2D63;
        Sun,  5 Mar 2023 05:56:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0E3AB80A36;
        Sun,  5 Mar 2023 13:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD6BC433D2;
        Sun,  5 Mar 2023 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024508;
        bh=5pq+WA9b1ZPBvhrwtWx6thZ7pT0GlWpeEMlEm7dJ/4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSGjd+jFyN3VlX5oy4va6IH/oy3+crvVg3EKXSBz4TOqgam/eP8G05va6+14aQf9D
         ZcaYqqVzUwqITZJpmJq2ucYCAMJWLwdognAjcaGU5TQyKnDIh9Fvguazi7I4iobmSs
         UChRSm/YSzC2CkbzbYOdASJrgYF830e62qdxQgzMNuSiNauLdjbAzmPazYNPpO/OVw
         OOFT6tgGTyCoB3PF1/TkZ7x0lACdh1rRcNb7b9I5+k4qkSrNGNEgbQkxVWcnoVRJ9x
         Sr71ZNOEAlZ3CuaJJ+384h9REPlGFx3YS5lTDwaqSlfcl4E5kSeyC7wSk6ssRIKXOx
         27wtlD6BXiqRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 7/7] PCI: Avoid FLR for SolidRun SNET DPU rev 1
Date:   Sun,  5 Mar 2023 08:54:48 -0500
Message-Id: <20230305135449.1794083-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135449.1794083-1-sashal@kernel.org>
References: <20230305135449.1794083-1-sashal@kernel.org>
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
index 8b98b7f3eb246..ba32f18075544 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5341,6 +5341,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
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

