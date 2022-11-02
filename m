Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBE5615923
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiKBDFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiKBDE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:04:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3F223BFA
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E68FD617C3
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90310C433D6;
        Wed,  2 Nov 2022 03:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358297;
        bh=B7mP4qPHMjezz/6/W8M/gJovK6icAbs3Zhiwanx1w0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZYKOrgp5RB2vVk1XNbUXmUlr0xbL/NrG9ZaO+aXGIfWcJWXh9vMXN1QmcFclwfz/
         3//x6s4x6kxYcbSED7KqQh3GKMMHYptjBgUUUBSN+SiVA3jeQV9izNTc8ob0PZkJt6
         MTnb4F57CwCX4T0ft0ZRS8Hu32PxSuKR8YA/ooZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Smart <jsmart2021@gmail.com>
Subject: [PATCH 5.15 049/132] Revert "scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()"
Date:   Wed,  2 Nov 2022 03:32:35 +0100
Message-Id: <20221102022100.908061417@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

This reverts commit 9a570069cdbbc28c4b5b4632d5c9369371ec739c.

LTS 5.15 pulled in several lpfc "SLI Path split" patches.  The Path
Split mods were a 14-patch set, which refactors the driver from
to split the sli-3 hw (now eol) from the sli-4 hw and use sli4
structures natively. The patches are highly inter-related.

Given only some of the patches were included, it created a situation
where FLOGI's fail, thus SLI Ports can't start communication.

Reverting this patch as its a fix specific to the Path Split patches,
which were partially included and now being pulled from 5.15.

Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3644,15 +3644,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 	unsigned long iflag;
 	u32 ulp_command, ulp_status, ulp_word4, ulp_context, iotag;
 
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_lock_irqsave(&pring->ring_lock, iflag);
-	else
-		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_unlock_irqrestore(&pring->ring_lock, iflag);
-	else
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 	ulp_command = get_job_cmnd(phba, saveq);
 	ulp_status = get_job_ulpstatus(phba, saveq);
@@ -3989,8 +3981,10 @@ lpfc_sli_handle_fast_ring_event(struct l
 				break;
 			}
 
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
 			if (cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED)


