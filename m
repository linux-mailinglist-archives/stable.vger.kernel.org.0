Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50189717A2
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387568AbfGWMBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:01:08 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44853 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728418AbfGWMBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:01:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5268A2208C;
        Tue, 23 Jul 2019 08:01:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZgxjYW
        B0biJ6N5ylKqGKkhN3Himrsb8zCQt1hB9kNCg=; b=zRe9FDodbsgq48qF7+noUr
        Zn+//GvW65XdOvTTwGrTWrGy+XUDPrXRhKVRfeqEg79KgKdDgu/5Bc92IBKlKxCx
        9Bj8eaTb7W2PhPfqayr8Sg1TVgm8cdgOPCsyeCYp732dqXtxklQbMgbbtaz84ZN5
        2tlOyP3kQ2x1KjjjDAHL5YWwIYPr3DwSM/4FvO8UN5L2ysIzylFq8tEk+w1dWJWx
        C0+WOWURJXcfZHm51gvRIy/SnqNsDBFDZxrOolJWZ0YFTQwgf1buzfz8VA52lm5p
        8OqxMvhANSB3XQ4PlJ3/74C+sXwDXonWJM0rYMHkcf84NNVggaYdVSNb12L2KrMA
        ==
X-ME-Sender: <xms:Avc2XTI8SmKQMj1-HU5l1TTagGBgjMHr6z5LhGc7ybf61LcL9ftBJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Avc2XbJ9W6iKq8EABMcGW4_orX7-1-m8rE_C6QFIpKYZN3x_MShfig>
    <xmx:Avc2XcWlqvH4HdEuVBAgi-u27uecM8BIj0kjdMX4VsJEGoFXHe4spA>
    <xmx:Avc2XcTgNnM15J9JRmwHrsehYBXhKdj0JvwwKY95pHsRHbw7D121BQ>
    <xmx:A_c2XXr6Aft4EOthJHU-pfk90lJ8o6_pOLw9QtqfYixe1-YXHDLrCg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B79548005A;
        Tue, 23 Jul 2019 08:01:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: qcom: Ensure that PERST is asserted for at least 100 ms" failed to apply to 4.14-stable tree
To:     niklas.cassel@linaro.org, lorenzo.pieralisi@arm.com,
        svarbanov@mm-sol.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:01:03 +0200
Message-ID: <156388326325354@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 64adde31c8e996a6db6f7a1a4131180e363aa9f2 Mon Sep 17 00:00:00 2001
From: Niklas Cassel <niklas.cassel@linaro.org>
Date: Wed, 29 May 2019 11:43:52 +0200
Subject: [PATCH] PCI: qcom: Ensure that PERST is asserted for at least 100 ms

Currently, there is only a 1 ms sleep after asserting PERST.

Reading the datasheets for different endpoints, some require PERST to be
asserted for 10 ms in order for the endpoint to perform a reset, others
require it to be asserted for 50 ms.

Several SoCs using this driver uses PCIe Mini Card, where we don't know
what endpoint will be plugged in.

The PCI Express Card Electromechanical Specification r2.0, section
2.2, "PERST# Signal" specifies:

"On power up, the deassertion of PERST# is delayed 100 ms (TPVPERL) from
the power rails achieving specified operating limits."

Add a sleep of 100 ms before deasserting PERST, in order to ensure that
we are compliant with the spec.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org # 4.5+

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index da5dd3639a49..7e581748ee9f 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -178,6 +178,8 @@ static void qcom_ep_reset_assert(struct qcom_pcie *pcie)
 
 static void qcom_ep_reset_deassert(struct qcom_pcie *pcie)
 {
+	/* Ensure that PERST has been asserted for at least 100 ms */
+	msleep(100);
 	gpiod_set_value_cansleep(pcie->reset, 0);
 	usleep_range(PERST_DELAY_US, PERST_DELAY_US + 500);
 }

