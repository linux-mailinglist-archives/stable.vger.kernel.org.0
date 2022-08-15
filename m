Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB01595120
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiHPEwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiHPEuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:50:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8D0199B00;
        Mon, 15 Aug 2022 13:46:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B12466122E;
        Mon, 15 Aug 2022 20:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E999C433D6;
        Mon, 15 Aug 2022 20:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596395;
        bh=ztuiYlmLkVZncfWoJY2ReqlKwgNsbOSNGQvAWdyy7tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRI0+mbLndZAT1BxGjuaPMBj2RpM3MWPzzm4yS1f2wLbJ5Lz5tr4tANR2bM2oAHGF
         YmMct2s5U7x0RjlZal45NVpV0rbDJbPX7cKMaxbHQyEbsixu4ynWAATLAOxzr9zMJl
         Pwy5cL8ibo7hNJUvQKsI0quDbayAHr9LXpFb976g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meeta Saggi <msaggi@purestorage.com>,
        Mohamed Khalfella <mkhalfella@purestorage.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Eric Badger <ebadger@purestorage.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1066/1157] PCI/AER: Iterate over error counters instead of error strings
Date:   Mon, 15 Aug 2022 20:07:02 +0200
Message-Id: <20220815180522.727862498@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit 5e6ae050955b566484f3cc6a66e3925eae87a0ed ]

Previously we iterated over AER stat *names*, e.g.,
aer_correctable_error_string[32], but the actual stat *counters* may not be
that large, e.g., pdev->aer_stats->dev_cor_errs[16], which means that we
printed junk in the sysfs stats files.

Iterate over the stat counter arrays instead of the names to avoid this
junk.

Also, added a build time check to make sure all
counters have entries in strings array.

Fixes: 0678e3109a3c ("PCI/AER: Simplify __aer_print_error()")
Link: https://lore.kernel.org/r/20220509181441.31884-1-mkhalfella@purestorage.com
Reported-by: Meeta Saggi <msaggi@purestorage.com>
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Meeta Saggi <msaggi@purestorage.com>
Reviewed-by: Eric Badger <ebadger@purestorage.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 7952e5efd6cf..a1e38ca93cd9 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -538,7 +538,7 @@ static const char *aer_agent_string[] = {
 	u64 *stats = pdev->aer_stats->stats_array;			\
 	size_t len = 0;							\
 									\
-	for (i = 0; i < ARRAY_SIZE(strings_array); i++) {		\
+	for (i = 0; i < ARRAY_SIZE(pdev->aer_stats->stats_array); i++) {\
 		if (strings_array[i])					\
 			len += sysfs_emit_at(buf, len, "%s %llu\n",	\
 					     strings_array[i],		\
@@ -1347,6 +1347,11 @@ static int aer_probe(struct pcie_device *dev)
 	struct device *device = &dev->device;
 	struct pci_dev *port = dev->port;
 
+	BUILD_BUG_ON(ARRAY_SIZE(aer_correctable_error_string) <
+		     AER_MAX_TYPEOF_COR_ERRS);
+	BUILD_BUG_ON(ARRAY_SIZE(aer_uncorrectable_error_string) <
+		     AER_MAX_TYPEOF_UNCOR_ERRS);
+
 	/* Limit to Root Ports or Root Complex Event Collectors */
 	if ((pci_pcie_type(port) != PCI_EXP_TYPE_RC_EC) &&
 	    (pci_pcie_type(port) != PCI_EXP_TYPE_ROOT_PORT))
-- 
2.35.1



