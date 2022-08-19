Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0D159A507
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354286AbiHSQqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353775AbiHSQoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:44:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EE611231F;
        Fri, 19 Aug 2022 09:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D774B8282A;
        Fri, 19 Aug 2022 16:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7433FC433D6;
        Fri, 19 Aug 2022 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925405;
        bh=3+8jeA0wp8PJ0PEzbB8vnRQ2Naz3OJjw1F1s8NNDeWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hC9qG3XgcOjS8D5Ok0KS+yTitVJF1sLixSNhcguUSQDXVNROzAjZsf1hlMD7tKUPD
         F/JwKFcumc/BRhqZDG+z+721ipzlGHVOrFZqax2c+iVRfFvny8EJFUrdGBtqdx6HLK
         oNkrlzMG+Y3XcEQng6BSdZpDe41MP15p4wMGxyog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meeta Saggi <msaggi@purestorage.com>,
        Mohamed Khalfella <mkhalfella@purestorage.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Eric Badger <ebadger@purestorage.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 482/545] PCI/AER: Iterate over error counters instead of error strings
Date:   Fri, 19 Aug 2022 17:44:12 +0200
Message-Id: <20220819153851.001765437@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 2ab708ab7218..9564b74003f0 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -538,7 +538,7 @@ static const char *aer_agent_string[] = {
 	struct pci_dev *pdev = to_pci_dev(dev);				\
 	u64 *stats = pdev->aer_stats->stats_array;			\
 									\
-	for (i = 0; i < ARRAY_SIZE(strings_array); i++) {		\
+	for (i = 0; i < ARRAY_SIZE(pdev->aer_stats->stats_array); i++) {\
 		if (strings_array[i])					\
 			str += sprintf(str, "%s %llu\n",		\
 				       strings_array[i], stats[i]);	\
@@ -1338,6 +1338,11 @@ static int aer_probe(struct pcie_device *dev)
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



