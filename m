Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A619461E9B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379946AbhK2SiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:38:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379429AbhK2Sfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:35:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A66CB8162F;
        Mon, 29 Nov 2021 18:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B64AC53FAD;
        Mon, 29 Nov 2021 18:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210754;
        bh=ADqAIH+JlR/Qw87ycmNVEjSrtqhs7N6dKfscF6o+sFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JljDpNUpUMDlEakUDzE/4FJswmvtpL9zFMRxaZu1bnhuCjN+S1lG2jlA2XZUisJys
         kNjBR/01igDxE0qIg/dAiozWyhw06Xs/wGAZjyoLMA8Z0xqN8PGzUVygt17E+NCv/0
         kV5rkGkXnlpbhwls76a5QBVaWhjiwjULuyL904Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 106/121] iommu/amd: Clarify AMD IOMMUv2 initialization messages
Date:   Mon, 29 Nov 2021 19:18:57 +0100
Message-Id: <20211129181715.226271829@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 717e88aad37befedfd531378b632e794e24e9afb upstream.

The messages printed on the initialization of the AMD IOMMUv2 driver
have caused some confusion in the past. Clarify the messages to lower
the confusion in the future.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20211123105507.7654-3-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu_v2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -927,10 +927,8 @@ static int __init amd_iommu_v2_init(void
 {
 	int ret;
 
-	pr_info("AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>\n");
-
 	if (!amd_iommu_v2_supported()) {
-		pr_info("AMD IOMMUv2 functionality not available on this system\n");
+		pr_info("AMD IOMMUv2 functionality not available on this system - This is not a bug.\n");
 		/*
 		 * Load anyway to provide the symbols to other modules
 		 * which may use AMD IOMMUv2 optionally.
@@ -947,6 +945,8 @@ static int __init amd_iommu_v2_init(void
 
 	amd_iommu_register_ppr_notifier(&ppr_nb);
 
+	pr_info("AMD IOMMUv2 loaded and initialized\n");
+
 	return 0;
 
 out:


