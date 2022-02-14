Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CDA4B4721
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244488AbiBNJly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:41:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244972AbiBNJlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C25E65798;
        Mon, 14 Feb 2022 01:36:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0CE6B80DCB;
        Mon, 14 Feb 2022 09:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E292CC340E9;
        Mon, 14 Feb 2022 09:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831389;
        bh=KvmdLp6G040VjpO7IuJ2RHy/LaQdJtkxJmJzfRYcEvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zh9mOo21hEEXkHujLWWQboa3dWxB8bWP9cgYzPB7imkL+jo5Xv1yWrhrIPdu3qnyW
         3HdPpAnW1WJh75pUPk/YNCEoP6KMn1w/gu5DOMvd4ZP6o72/CEuEVr6VkEi/LkbJxf
         go14xfEyWxOsDMQqHl9GO7neqGeB86OAlkdrlUXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.4 31/71] ACPI/IORT: Check node revision for PMCG resources
Date:   Mon, 14 Feb 2022 10:25:59 +0100
Message-Id: <20220214092453.067325044@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit da5fb9e1ad3fbf632dce735f1bdad257ca528499 upstream.

The original version of the IORT PMCG definition had an oversight
wherein there was no way to describe the second register page for an
implementation using the recommended RELOC_CTRS feature. Although the
spec was fixed, and the final patches merged to ACPICA and Linux written
against the new version, it seems that some old firmware based on the
original revision has survived and turned up in the wild.

Add a check for the original PMCG definition, and avoid filling in the
second memory resource with nonsense if so. Otherwise it is likely that
something horrible will happen when the PMCG driver attempts to probe.

Reported-by: Michael Petlan <mpetlan@redhat.com>
Fixes: 24e516049360 ("ACPI/IORT: Add support for PMCG")
Cc: <stable@vger.kernel.org> # 5.2.x
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/75628ae41c257fb73588f7bf1c4459160e04be2b.1643916258.git.robin.murphy@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/arm64/iort.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1373,9 +1373,17 @@ static void __init arm_smmu_v3_pmcg_init
 	res[0].start = pmcg->page0_base_address;
 	res[0].end = pmcg->page0_base_address + SZ_4K - 1;
 	res[0].flags = IORESOURCE_MEM;
-	res[1].start = pmcg->page1_base_address;
-	res[1].end = pmcg->page1_base_address + SZ_4K - 1;
-	res[1].flags = IORESOURCE_MEM;
+	/*
+	 * The initial version in DEN0049C lacked a way to describe register
+	 * page 1, which makes it broken for most PMCG implementations; in
+	 * that case, just let the driver fail gracefully if it expects to
+	 * find a second memory resource.
+	 */
+	if (node->revision > 0) {
+		res[1].start = pmcg->page1_base_address;
+		res[1].end = pmcg->page1_base_address + SZ_4K - 1;
+		res[1].flags = IORESOURCE_MEM;
+	}
 
 	if (pmcg->overflow_gsiv)
 		acpi_iort_register_irq(pmcg->overflow_gsiv, "overflow",


