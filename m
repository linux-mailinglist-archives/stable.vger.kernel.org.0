Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32326B4A2E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjCJPUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbjCJPTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:19:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254941378B8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:10:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B96E5B8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E27BC433D2;
        Fri, 10 Mar 2023 15:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461006;
        bh=cBBInSU2rt6fRvzkogTjFE/NEH2IRfHn57opg4yfwv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwKT/bv6QRFMeiHDzQYlN+fyxiF4eRWMPbt9sGr9sc41efbCElwdyspdy9yFKT2LY
         Bdj68YRLWOLVueP2166AnofFqxITycefFLRUp1M+lICtgRRwYK/eVnCtQyVPCn9TP6
         /eZ9oRpx1XzfTPrfbNkj7GPJ1MzYNHATiI5+F68o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 525/529] scsi: mpt3sas: re-do lost mpt3sas DMA mask fix
Date:   Fri, 10 Mar 2023 14:41:08 +0100
Message-Id: <20230310133829.138814589@linuxfoundation.org>
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 1a2dcbdde82e3a5f1db9b2f4c48aa1aeba534fb2 upstream.

This is a re-do of commit e0e0747de0ea ("scsi: mpt3sas: Fix return value
check of dma_get_required_mask()"), which I ended up undoing in a
mis-merge in commit 62e6e5940c0c ("Merge tag 'scsi-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi").

The original commit message was

  scsi: mpt3sas: Fix return value check of dma_get_required_mask()

  Fix the incorrect return value check of dma_get_required_mask().  Due to
  this incorrect check, the driver was always setting the DMA mask to 63 bit.

  Link: https://lore.kernel.org/r/20220913120538.18759-2-sreekanth.reddy@broadcom.com
  Fixes: ba27c5cf286d ("scsi: mpt3sas: Don't change the DMA coherent mask after allocations")
  Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
  Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

and this fix was lost when I mis-merged the conflict with commit
9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while reallocating
pools").

Reported-by: Juergen Gross <jgross@suse.com>
Fixes: 62e6e5940c0c ("Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi")
Link: https://lore.kernel.org/all/CAHk-=wjaK-TxrNaGtFDpL9qNHL1MVkWXO1TT6vObD5tXMSC4Zg@mail.gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2825,7 +2825,7 @@ _base_config_dma_addressing(struct MPT3S
 	u64 coherent_dma_mask, dma_mask;
 
 	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
-	    dma_get_required_mask(&pdev->dev) <= 32) {
+	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32)) {
 		ioc->dma_mask = 32;
 		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */


