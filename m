Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB772541AC3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379730AbiFGViC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381124AbiFGVgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:36:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44772163F4C;
        Tue,  7 Jun 2022 12:04:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F65B8233E;
        Tue,  7 Jun 2022 19:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB14C34115;
        Tue,  7 Jun 2022 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628689;
        bh=pGs7DucsfOyXb3V7w2Exptx3i43BThzarD4FoLRpck0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pm43wSLkfAMCnxjKG27kyl364CM5RAcjuJhsECzPNGScuMZZWcWGr6uC1I+C73Lud
         05CimDAQyl1XsOpMto3fZuzYkpEt1185mq45XVu7zkF6rEmYJz2AIC9sWu2ycUkC+P
         ewyJpzSDpxtmuGY95pzD5uwuQrJgaUJrgswSnSdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 413/879] scsi: lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event()
Date:   Tue,  7 Jun 2022 18:58:51 +0200
Message-Id: <20220607165014.849610239@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 596fc8adb171dce3751a359018e2ade612af8d97 ]

Upon driver receipt of a CT cmd for type = 0xFA (Management Server) and
subtype = 0x11 (Fabric Device Management Interface), the driver is
responding with garbage CT cmd data when it should send a properly formed
RJT.

The __lpfc_prep_xmit_seq64_s4() routine was using the wrong buffer for the
reject.

Fix by converting the routine to use the buffer specified in the bde within
the wqe rather than the ill-set bmp element.

Link: https://lore.kernel.org/r/20220506035519.50908-6-jsmart2021@gmail.com
Fixes: 61910d6a5243 ("scsi: lpfc: SLI path split: Refactor CT paths")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c307f551d114..331241a71452 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10800,24 +10800,15 @@ __lpfc_sli_prep_xmit_seq64_s4(struct lpfc_iocbq *cmdiocbq,
 {
 	union lpfc_wqe128 *wqe;
 	struct ulp_bde64 *bpl;
-	struct ulp_bde64_le *bde;
 
 	wqe = &cmdiocbq->wqe;
 	memset(wqe, 0, sizeof(*wqe));
 
 	/* Words 0 - 2 */
 	bpl = (struct ulp_bde64 *)bmp->virt;
-	if (cmdiocbq->cmd_flag & (LPFC_IO_LIBDFC | LPFC_IO_LOOPBACK)) {
-		wqe->xmit_sequence.bde.addrHigh = bpl->addrHigh;
-		wqe->xmit_sequence.bde.addrLow = bpl->addrLow;
-		wqe->xmit_sequence.bde.tus.w = bpl->tus.w;
-	} else {
-		bde = (struct ulp_bde64_le *)&wqe->xmit_sequence.bde;
-		bde->addr_low = cpu_to_le32(putPaddrLow(bmp->phys));
-		bde->addr_high = cpu_to_le32(putPaddrHigh(bmp->phys));
-		bde->type_size = cpu_to_le32(bpl->tus.f.bdeSize);
-		bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
-	}
+	wqe->xmit_sequence.bde.addrHigh = bpl->addrHigh;
+	wqe->xmit_sequence.bde.addrLow = bpl->addrLow;
+	wqe->xmit_sequence.bde.tus.w = bpl->tus.w;
 
 	/* Word 5 */
 	bf_set(wqe_ls, &wqe->xmit_sequence.wge_ctl, last_seq);
-- 
2.35.1



