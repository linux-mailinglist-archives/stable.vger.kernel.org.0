Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB32615922
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKBDFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiKBDEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:04:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E545C23394
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:04:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98335B82062
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7241AC433D6;
        Wed,  2 Nov 2022 03:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358291;
        bh=MbsjvXhqEO/k07jpr/JlXaHbxHzfI6JX+07V6T3xoUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrGwtPna3QbvJY/yw+JXGvyI3d8688g2asfsuayfL01jPN1QWrqRUbxbqOm57lOZA
         U3nnUsO7EvUESzi6w6W7DInYjGowVoxUBjwohuT8iI2DD0Y39CuuaNEGOP8p628d/e
         o+rdT2uf2BRlCUNkfnud8VBSWwAUP/7zPnfeA0iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Smart <jsmart2021@gmail.com>
Subject: [PATCH 5.15 048/132] Revert "scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()"
Date:   Wed,  2 Nov 2022 03:32:34 +0100
Message-Id: <20221102022100.884099582@linuxfoundation.org>
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

This reverts commit 6e99860de6f4e286c386f533c4d35e7e283803d4.

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
 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1384,7 +1384,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
+	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 


