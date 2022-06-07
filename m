Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7DA541691
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376946AbiFGUx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378817AbiFGUwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDBD1057B;
        Tue,  7 Jun 2022 11:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDCDD6169F;
        Tue,  7 Jun 2022 18:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF70C385A2;
        Tue,  7 Jun 2022 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627389;
        bh=p6AyCMNuodEwCOkW6r5sEFSQXrSzPjcthGFZPDEb/Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/4IzPnM6QEd5U6THkPyc7/RE/G9iXLH1rbx/pmOunImiLe2aD5yQOoJtAIdqDe5L
         lpEYh7/CedW5NUIG+pehfXqQDjRZypIO42lIUaqG5MXFJMiMMPHdmrNR0Z/fAirkPL
         U5frNQ1mRnXcBwi56x+hr4k3h1y5DCHIpWQejeho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.17 721/772] iommu/msm: Fix an incorrect NULL check on list iterator
Date:   Tue,  7 Jun 2022 19:05:13 +0200
Message-Id: <20220607165010.287116485@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 8b9ad480bd1dd25f4ff4854af5685fa334a2f57a upstream.

The bug is here:
	if (!iommu || iommu->dev->of_node != spec->np) {

The list iterator value 'iommu' will *always* be set and non-NULL by
list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element is found (in fact,
it will point to a invalid structure object containing HEAD).

To fix the bug, use a new value 'iter' as the list iterator, while use
the old value 'iommu' as a dedicated variable to point to the found one,
and remove the unneeded check for 'iommu->dev->of_node != spec->np'
outside the loop.

Cc: stable@vger.kernel.org
Fixes: f78ebca8ff3d6 ("iommu/msm: Add support for generic master bindings")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220501132823.12714-1-xiam0nd.tong@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/msm_iommu.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -615,16 +615,19 @@ static void insert_iommu_master(struct d
 static int qcom_iommu_of_xlate(struct device *dev,
 			       struct of_phandle_args *spec)
 {
-	struct msm_iommu_dev *iommu;
+	struct msm_iommu_dev *iommu = NULL, *iter;
 	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&msm_iommu_lock, flags);
-	list_for_each_entry(iommu, &qcom_iommu_devices, dev_node)
-		if (iommu->dev->of_node == spec->np)
+	list_for_each_entry(iter, &qcom_iommu_devices, dev_node) {
+		if (iter->dev->of_node == spec->np) {
+			iommu = iter;
 			break;
+		}
+	}
 
-	if (!iommu || iommu->dev->of_node != spec->np) {
+	if (!iommu) {
 		ret = -ENODEV;
 		goto fail;
 	}


