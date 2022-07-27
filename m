Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9CF582B2E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiG0Q33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237254AbiG0Q2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:28:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C351D50188;
        Wed, 27 Jul 2022 09:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E30EA617F3;
        Wed, 27 Jul 2022 16:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87B0C433D6;
        Wed, 27 Jul 2022 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939060;
        bh=RcrKG+om7QizUr7G5MTJNYhf8ZbjqH7rKkIdTUsFlvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3ZY6Cpgq0BjE4NOIInFlrC2VEP5myIV5Hu0KLisCMwQo1WzJM087cgiBeDSGf6Z5
         N4MsKERxXuhIUbzBPBtNVnikCP4bU4lpFAfi5wsqGf64ncJgnyVoQPmfCM8FF75/K1
         61WZuzS1In9uCdbLAF7gbOTUDiPCKutrxi5YrmGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Carl Vanderlip <quic_carlv@quicinc.com>
Subject: [PATCH 4.14 36/37] PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()
Date:   Wed, 27 Jul 2022 18:11:02 +0200
Message-Id: <20220727161002.297940565@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
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

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

commit b4b77778ecc5bfbd4e77de1b2fd5c1dd3c655f1f upstream.

Currently if compose_msi_msg() is called multiple times, it will free any
previous IRTE allocation, and generate a new allocation.  While nothing
prevents this from occurring, it is extraneous when Linux could just reuse
the existing allocation and avoid a bunch of overhead.

However, when future IRTE allocations operate on blocks of MSIs instead of
a single line, freeing the allocation will impact all of the lines.  This
could cause an issue where an allocation of N MSIs occurs, then some of
the lines are retargeted, and finally the allocation is freed/reallocated.
The freeing of the allocation removes all of the configuration for the
entire block, which requires all the lines to be retargeted, which might
not happen since some lines might already be unmasked/active.

4.14 backport - driver location change to host/pci-hyperv.c

Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1652282582-21595-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pci-hyperv.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -1128,6 +1128,15 @@ static void hv_compose_msi_msg(struct ir
 	u32 size;
 	int ret;
 
+	/* Reuse the previous allocation */
+	if (data->chip_data) {
+		int_desc = data->chip_data;
+		msg->address_hi = int_desc->address >> 32;
+		msg->address_lo = int_desc->address & 0xffffffff;
+		msg->data = int_desc->data;
+		return;
+	}
+
 	pdev = msi_desc_to_pci_dev(irq_data_get_msi_desc(data));
 	dest = irq_data_get_effective_affinity_mask(data);
 	pbus = pdev->bus;
@@ -1136,13 +1145,6 @@ static void hv_compose_msi_msg(struct ir
 	if (!hpdev)
 		goto return_null_message;
 
-	/* Free any previous message that might have already been composed. */
-	if (data->chip_data) {
-		int_desc = data->chip_data;
-		data->chip_data = NULL;
-		hv_int_desc_free(hpdev, int_desc);
-	}
-
 	int_desc = kzalloc(sizeof(*int_desc), GFP_ATOMIC);
 	if (!int_desc)
 		goto drop_reference;


