Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0264462600
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhK2Wpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbhK2WpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:45:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F01C1E03D0;
        Mon, 29 Nov 2021 10:41:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 887AAB81639;
        Mon, 29 Nov 2021 18:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDEEC53FC7;
        Mon, 29 Nov 2021 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211276;
        bh=JvZPDbto5cKDBqsR0XZxIL6sD8bpk/XuEEzw4h5lyH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bp3JayfOYHaM8bEexuOBeRwyTIOeKHHvKMdJKEbuxWk7bL347xJ7ZeUMnlRjtcJHR
         2PhkScd+1Ak0gjmZhwguAyCoTHtFXqPvQlwBZtGHFU81ZkSsRzPDAdH0PS7sTPGQ8L
         RBPP95znXshDtnHFOOTWTTL3RlDcUDdY9B+IP8SA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 166/179] iommu/amd: Clarify AMD IOMMUv2 initialization messages
Date:   Mon, 29 Nov 2021 19:19:20 +0100
Message-Id: <20211129181724.397523379@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
@@ -928,10 +928,8 @@ static int __init amd_iommu_v2_init(void
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
@@ -946,6 +944,8 @@ static int __init amd_iommu_v2_init(void
 
 	amd_iommu_register_ppr_notifier(&ppr_nb);
 
+	pr_info("AMD IOMMUv2 loaded and initialized\n");
+
 	return 0;
 
 out:


