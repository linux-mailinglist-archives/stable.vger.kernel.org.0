Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D866B4A43
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbjCJPUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbjCJPUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:20:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F28212EAD9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:10:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28E6A61A7F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D65AC4339B;
        Fri, 10 Mar 2023 15:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461000;
        bh=XkhP0c11ZZ/sBRy++pnXIfWS93ca6LoPps4HATArmUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxMLmDdiabHsNhCMtlZzJkWJ3drLzZp6IcgA41qIUmVNYGN4lFWAnq0iDhEYzbGTS
         olBCz0B4AyZBwSsrOtfd2k/RawsCLI3la2hhoWkUOYd5DQqPYgyx38JQS0okCCXrx/
         tlZFrVCwV9cKy8n7PxiHT5w2FjZdT0wNU6ddaPnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 523/529] Revert "scsi: mpt3sas: Fix return value check of dma_get_required_mask()"
Date:   Fri, 10 Mar 2023 14:41:06 +0100
Message-Id: <20230310133829.051460435@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Salvatore Bonaccorso <carnil@debian.org>

This reverts commit e0e0747de0ea3dd87cdbb0393311e17471a9baf1.

As noted in 1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask
fix") in mainline there was a mis-merge in commit 62e6e5940c0c ("Merge
tag 'scsi-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi"). causing that
the fix needed to be redone later on again. To make series of patches
apply cleanly to the stable series where e0e0747de0ea ("scsi: mpt3sas:
Fix return value check of dma_get_required_mask()") was backported,
revert the aforementioned commit.

No upstream commit exists for this commit.

Link: https://lore.kernel.org/regressions/yq1sfehmjnb.fsf@ca-mkp.ca.oracle.com/
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2825,7 +2825,7 @@ _base_config_dma_addressing(struct MPT3S
 
 	if (ioc->is_mcpu_endpoint ||
 	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
+	    dma_get_required_mask(&pdev->dev) <= 32)
 		ioc->dma_mask = 32;
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
 	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)


