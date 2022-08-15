Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52913593DAD
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbiHOUCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346022AbiHOUBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:01:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5CBEA4;
        Mon, 15 Aug 2022 11:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2D85B810A0;
        Mon, 15 Aug 2022 18:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A381BC433C1;
        Mon, 15 Aug 2022 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589623;
        bh=Ki9OpC+liXeodytwk+5NFoK0HolAbgb1uPiEuSySNmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cob0tQlRDxrmAQCaH8v5hQWj5sP6AyZoYbwj6odXAOF+HDoPiHdLbU/KyfbYfcI35
         JCkPtZr3M+0WBHcQrO9xS56P4F+LuR6qjpeRIN0oiPqt2gMfaknThBr0O7B4ZGgt0c
         MmPq6/k+f3Y9UlTNhvYj4p21JB4VyCs7yvyw1xuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 777/779] scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()
Date:   Mon, 15 Aug 2022 20:07:01 +0200
Message-Id: <20220815180410.592934784@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: James Smart <jsmart2021@gmail.com>

commit c26bd6602e1d348bfa754dc55e5608c922dd2801 upstream.

The rules changed for lpfc_sli_iocbq_lookup() vs locking. Prior, the
routine properly took out the lock. In newly refactored code, the locks
must be held when calling the routine.

Fix lpfc_sli_process_sol_iocb() to take the locks before calling the
routine.

Fix lpfc_sli_handle_fast_ring_event() to not release the locks to call the
routine.

Link: https://lore.kernel.org/r/20220323205545.81814-3-jsmart2021@gmail.com
Fixes: 1b64aa9eae28 ("scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3642,7 +3642,15 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 	unsigned long iflag;
 	u32 ulp_command, ulp_status, ulp_word4, ulp_context, iotag;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		spin_lock_irqsave(&pring->ring_lock, iflag);
+	else
+		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		spin_unlock_irqrestore(&pring->ring_lock, iflag);
+	else
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 	ulp_command = get_job_cmnd(phba, saveq);
 	ulp_status = get_job_ulpstatus(phba, saveq);
@@ -3979,10 +3987,8 @@ lpfc_sli_handle_fast_ring_event(struct l
 				break;
 			}
 
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
-			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
 			if (cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED)


